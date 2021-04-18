import 'dart:async';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/history/history_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/favourite_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/related_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/touch_count_provider.dart';
import 'package:fluttermultistoreflutter/repository/basket_repository.dart';
import 'package:fluttermultistoreflutter/repository/history_repsitory.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_hero.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/success_dialog.dart';
import 'package:fluttermultistoreflutter/ui/product/detail/views/attributes_item_view.dart';
import 'package:fluttermultistoreflutter/ui/product/detail/views/color_list_item_view.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/attribute_detail.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:fluttermultistoreflutter/viewobject/basket_selected_attribute.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/favourite_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/attribute_detail_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'views/description_tile_view.dart';
import 'views/detail_info_tile_view.dart';
import 'views/related_products_tile_view.dart';
import 'views/terms_and_policy_tile_view.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({
    @required this.product,
    this.heroTagImage,
    this.heroTagTitle,
    this.heroTagOriginalPrice,
    this.heroTagUnitPrice,
    this.intentId,
    this.intentQty,
    this.intentSelectedColorId,
    this.intentSelectedColorValue,
    this.intentBasketPrice,
    this.intentBasketSelectedAttributeList,
  });

  final String intentId;
  final String intentBasketPrice;
  final List<BasketSelectedAttribute> intentBasketSelectedAttributeList;
  final String intentSelectedColorId;
  final String intentSelectedColorValue;
  final Product product;
  final String intentQty;
  final String heroTagImage;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  ProductRepository relatedProductRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  TouchCountProvider touchCountProvider;
  BasketProvider basketProvider;
  PsValueHolder psValueHolder;
  AnimationController controller;
  BasketRepository basketRepository;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  List<Product> basketList = <Product>[];
  bool isReadyToShowAppBarIcons = false;

  @override
  Widget build(BuildContext context) {
    print('****** Building *********');
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    psValueHolder = Provider.of<PsValueHolder>(context);
    productRepo = Provider.of<ProductRepository>(context);
    relatedProductRepo = Provider.of<ProductRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<ProductDetailProvider>(
            create: (BuildContext context) {
              final ProductDetailProvider productDetailProvider =
                  ProductDetailProvider(
                      repo: productRepo, psValueHolder: psValueHolder);

              final String loginUserId = Utils.checkUserLoginId2(psValueHolder);
              productDetailProvider.loadProduct(widget.product.id, loginUserId,
                  productDetailProvider.psValueHolder.shopId);

              return productDetailProvider;
            },
          ),
          ChangeNotifierProvider<RelatedProductProvider>(
              create: (BuildContext context) {
            final RelatedProductProvider relatedProductProvider =
                RelatedProductProvider(
                    repo: relatedProductRepo, psValueHolder: psValueHolder);

            relatedProductProvider.loadRelatedProductList(
                widget.product.id, widget.product.catId, widget.product.shopId);
            return relatedProductProvider;
          }),
          ChangeNotifierProvider<BasketProvider>(
              create: (BuildContext context) {
            basketProvider = BasketProvider(
                repo: basketRepository, psValueHolder: psValueHolder);
            return basketProvider;
          }),
          ChangeNotifierProvider<HistoryProvider>(
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo);
              return historyProvider;
            },
          ),
          ChangeNotifierProvider<TouchCountProvider>(
            create: (BuildContext context) {
              touchCountProvider = TouchCountProvider(
                  repo: productRepo, psValueHolder: psValueHolder);
              final String loginUserId = Utils.checkUserLoginId2(psValueHolder);

              final TouchCountParameterHolder touchCountParameterHolder =
                  TouchCountParameterHolder(
                      typeId: widget.product.id,
                      typeName: PsConst.FILTERING_TYPE_NAME_PRODUCT,
                      userId: loginUserId,
                      shopId: touchCountProvider.psValueHolder.shopId);
              touchCountProvider
                  .postTouchCount(touchCountParameterHolder.toMap());
              return touchCountProvider;
            },
          )
        ],
            child: Consumer<ProductDetailProvider>(
              builder: (BuildContext context, ProductDetailProvider provider,
                  Widget child) {
                if (provider.productDetail == null ||
                    provider.productDetail.data == null) {
                  provider.updateProduct(widget.product);
                }

                ///
                /// Add to History
                ///
                historyProvider.addHistoryList(provider.productDetail.data);

                ///
                /// Load Basket List
                ///
                ///
                basketProvider = Provider.of<BasketProvider>(context,
                    listen: false); // Listen : False is important.

                basketProvider
                    .loadBasketList(basketProvider.psValueHolder.shopId);

                return Stack(
                  children: <Widget>[
                    CustomScrollView(slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: true,
                        brightness: Utils.getBrightnessForAppBar(context),
                        expandedHeight: PsDimens.space300,
                        iconTheme: Theme.of(context)
                            .iconTheme
                            .copyWith(color: PsColors.mainColorWithWhite),
                        leading: PsBackButtonWithCircleBgWidget(
                          isReadyToShow: isReadyToShowAppBarIcons,
                        ),
                        floating: false,
                        pinned: false,
                        stretch: true,
                        actions: <Widget>[
                          Consumer<BasketProvider>(builder:
                              (BuildContext context,
                                  BasketProvider basketProvider, Widget child) {
                            // print('Basket Count');
                            // print(
                            //     'lenght ${basketProvider.basketList.data.length}');
                            // for (Basket product
                            //     in basketProvider.basketList.data) {
                            //   print('shop id ${product.shopId}');
                            // }
                            return InkWell(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: PsDimens.space40,
                                      height: PsDimens.space40,
                                      margin: const EdgeInsets.only(
                                          top: PsDimens.space8,
                                          left: PsDimens.space8,
                                          right: PsDimens.space8),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.shopping_basket,
                                          color: PsColors.mainColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: PsDimens.space4,
                                      top: PsDimens.space1,
                                      child: Container(
                                        width: PsDimens.space28,
                                        height: PsDimens.space28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: PsColors.black.withAlpha(200),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            basketProvider.basketList.data
                                                        .length >
                                                    99
                                                ? '99+'
                                                : basketProvider
                                                    .basketList.data.length
                                                    .toString(),
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .copyWith(
                                                    color: PsColors.white),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.basketList,
                                  );
                                });
                          })
                        ],
                        backgroundColor: PsColors.mainColorWithBlack,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: PsColors.backgroundColor,
                            child: PsNetworkImage(
                              photoKey: widget.heroTagImage,
                              defaultPhoto: widget.product.defaultPhoto,
                              width: double.infinity,
                              height: double.infinity,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.galleryGrid,
                                    arguments: widget.product);
                              },
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                          Container(
                            color: PsColors.baseColor,
                            child: Column(children: <Widget>[
                              _HeaderBoxWidget(
                                  productDetail: provider,
                                  product: widget.product,
                                  originalPriceFormatString:
                                      Utils.getPriceFormat(provider
                                          .productDetail.data.originalPrice),
                                  unitPriceFormatString: Utils.getPriceFormat(
                                      provider.productDetail.data.unitPrice),
                                  heroTagTitle: widget.heroTagTitle,
                                  heroTagOriginalPrice:
                                      widget.heroTagOriginalPrice,
                                  heroTagUnitPrice: widget.heroTagUnitPrice),
                           
                             
                              RelatedProductsTileView(
                                productDetail: provider,
                              ),
                              const SizedBox(
                                height: PsDimens.space40,
                              ),
                            ]),
                          )
                        ]),
                      )
                    ]),
                    _AddToBasketAndBuyButtonWidget(
                      controller: controller,
                      productProvider: provider,
                      basketProvider: basketProvider,
                      product: widget.product,
                      psValueHolder: psValueHolder,
                      intentQty: widget.intentQty ?? '',
                      intentSelectedColorId: widget.intentSelectedColorId ?? '',
                      intentSelectedColorValue:
                          widget.intentSelectedColorValue ?? '',
                      intentbasketPrice: widget.intentBasketPrice ?? '',
                      intentbasketSelectedAttributeList:
                          widget.intentBasketSelectedAttributeList ??
                              <BasketSelectedAttribute>[],
                    )
                  ],
                );
              },
            )));
  }
}

class UserCommentTileView extends StatelessWidget {
  const UserCommentTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'user_comment_tile__user_comment'),
        style: Theme.of(context).textTheme.subhead);
    if (productDetail != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    final dynamic returnData = await Navigator.pushNamed(
                        context, RoutePaths.commentList,
                        arguments: productDetail.productDetail.data);

                    if (returnData != null && returnData) {
                      productDetail.loadProduct(
                          productDetail.productDetail.data.id,
                          productDetail.psValueHolder.loginUserId,
                          productDetail.psValueHolder.shopId);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Utils.getString(
                              context, 'user_comment_tile__view_all_comment'),
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: PsColors.mainColor),
                        ),
                        GestureDetector(
                            onTap: () async {
                              final dynamic returnData =
                                  await Navigator.pushNamed(
                                      context, RoutePaths.commentList,
                                      arguments:
                                          productDetail.productDetail.data);

                              if (returnData) {
                                productDetail.loadProduct(
                                    productDetail.productDetail.data.id,
                                    productDetail.psValueHolder.loginUserId,
                                    productDetail.psValueHolder.shopId);
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: PsDimens.space16,
                            )),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      final dynamic returnData = await Navigator.pushNamed(
                          context, RoutePaths.commentList,
                          arguments: productDetail.productDetail.data);

                      if (returnData != null && returnData) {
                        productDetail.loadProduct(
                            productDetail.productDetail.data.id,
                            productDetail.psValueHolder.loginUserId,
                            productDetail.psValueHolder.shopId);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(PsDimens.space16),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              Utils.getString(
                                  context, 'user_comment_tile__write_comment'),
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    color: PsColors.mainColor,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
      @required this.productDetail,
      @required this.product,
      @required this.originalPriceFormatString,
      @required this.unitPriceFormatString,
      @required this.heroTagTitle,
      @required this.heroTagOriginalPrice,
      @required this.heroTagUnitPrice})
      : super(key: key);

  final ProductDetailProvider productDetail;
  final Product product;
  final String originalPriceFormatString;
  final String unitPriceFormatString;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.product != null &&
        widget.productDetail != null &&
        widget.productDetail.productDetail != null &&
        widget.productDetail.productDetail.data != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Column(
                  children: <Widget>[
                    _FavouriteWidget(
                        productDetail: widget.productDetail,
                        product: widget.product,
                        heroTagTitle: widget.heroTagTitle),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    _HeaderPriceWidget(
                      product: widget.productDetail.productDetail.data,
                      originalPriceFormatString:
                          widget.originalPriceFormatString,
                      unitPriceFormatString: widget.unitPriceFormatString,
                      heroTagOriginalPrice: widget.heroTagOriginalPrice,
                      heroTagUnitPrice: widget.heroTagUnitPrice,
                    ),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    Divider(
                      height: PsDimens.space1,
                      color: PsColors.mainColor,
                    )
                  ],
                ))
 
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _FavouriteWidget extends StatefulWidget {
  const _FavouriteWidget(
      {Key key,
      @required this.productDetail,
      @required this.product,
      @required this.heroTagTitle})
      : super(key: key);

  final ProductDetailProvider productDetail;
  final Product product;
  final String heroTagTitle;

  @override
  __FavouriteWidgetState createState() => __FavouriteWidgetState();
}

class __FavouriteWidgetState extends State<_FavouriteWidget> {
  Widget icon;
  ProductRepository favouriteRepo;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    favouriteRepo = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    if (widget.product != null &&
        widget.productDetail != null &&
        widget.productDetail.productDetail != null &&
        widget.productDetail.productDetail.data != null &&
        widget.productDetail.productDetail.data.isFavourited != null) {
      return ChangeNotifierProvider<FavouriteProductProvider>(
          create: (BuildContext context) {
        final FavouriteProductProvider provider = FavouriteProductProvider(
            repo: favouriteRepo, psValueHolder: psValueHolder);

        return provider;
      }, child: Consumer<FavouriteProductProvider>(builder:
              (BuildContext context, FavouriteProductProvider provider,
                  Widget child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: PsHero(
                    tag: widget.heroTagTitle,
                    child: Text(
                      widget.productDetail.productDetail.data.name ?? '',
                      style: Theme.of(context).textTheme.headline,
                    )),
              ),
              GestureDetector(
                  onTap: () async {
                    if (await Utils.checkInternetConnectivity()) {
                      Utils.navigateOnUserVerificationView(provider, context,
                          () async {
                        if (widget.productDetail.productDetail.data
                                .isFavourited ==
                            '0') {
                          setState(() {
                            widget.productDetail.productDetail.data
                                .isFavourited = '1';
                          });
                        } else {
                          setState(() {
                            widget.productDetail.productDetail.data
                                .isFavourited = '0';
                          });
                        }

                        final FavouriteParameterHolder
                            favouriteParameterHolder = FavouriteParameterHolder(
                                userId: provider.psValueHolder.loginUserId,
                                productId: widget.product.id,
                                shopId: provider.psValueHolder.shopId);

                        final PsResource<Product> _apiStatus = await provider
                            .postFavourite(favouriteParameterHolder.toMap());

                        if (_apiStatus.data != null) {
                          if (_apiStatus.status == PsStatus.SUCCESS) {
                            await widget.productDetail.loadProductForFav(
                                widget.product.id,
                                provider.psValueHolder.loginUserId,
                                provider.psValueHolder.shopId);
                          }
                          if (widget.productDetail != null &&
                              widget.productDetail.productDetail != null &&
                              widget.productDetail.productDetail.data != null &&
                              widget.productDetail.productDetail.data
                                      .isFavourited ==
                                  '0') {
                            icon = Container(
                              padding: const EdgeInsets.only(
                                  top: PsDimens.space8,
                                  left: PsDimens.space8,
                                  right: PsDimens.space8,
                                  bottom: PsDimens.space6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: PsColors.mainColor),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.favorite,
                                  color: PsColors.mainColor),
                            );
                          } else {
                            icon = Container(
                              padding: const EdgeInsets.only(
                                  top: PsDimens.space8,
                                  left: PsDimens.space8,
                                  right: PsDimens.space8,
                                  bottom: PsDimens.space6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: PsColors.mainColor),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.favorite_border,
                                  color: PsColors.mainColor),
                            );
                          }
                        } else {
                          print('There is no comment');
                        }
                      });
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'error_dialog__no_internet'),
                            );
                          });
                    }
                  },
                  child: widget.productDetail.productDetail.data.isFavourited !=
                          null
                      ? widget.productDetail.productDetail.data.isFavourited ==
                              '0'
                          ? icon = Container(
                              padding: const EdgeInsets.only(
                                  top: PsDimens.space8,
                                  left: PsDimens.space8,
                                  right: PsDimens.space8,
                                  bottom: PsDimens.space6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: PsColors.mainColor),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.favorite_border,
                                  color: PsColors.mainColor),
                            )
                          : icon = Container(
                              padding: const EdgeInsets.only(
                                  top: PsDimens.space8,
                                  left: PsDimens.space8,
                                  right: PsDimens.space8,
                                  bottom: PsDimens.space6),
                              decoration: BoxDecoration(
                                  border: Border.all(color: PsColors.mainColor),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.favorite,
                                  color: PsColors.mainColor),
                            )
                      : null)
            ]);
      }));
    } else {
      return Container();
    }
  }
}

class _HeaderRatingWidget extends StatelessWidget {
  const _HeaderRatingWidget({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;

  @override
  Widget build(BuildContext context) {
    dynamic result;
    if (productDetail != null &&
        productDetail.productDetail != null &&
        productDetail.productDetail.data != null &&
        productDetail.productDetail.data.ratingDetail != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                        Container(),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Text(
                  productDetail.productDetail.data.code ?? '',
                  // textAlign: TextAlign.end,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: PsColors.mainDarkColor),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _HeaderPriceWidget extends StatefulWidget {
  const _HeaderPriceWidget({
    Key key,
    @required this.product,
    @required this.originalPriceFormatString,
    @required this.unitPriceFormatString,
    @required this.heroTagOriginalPrice,
    @required this.heroTagUnitPrice,
  }) : super(key: key);

  final Product product;
  final String originalPriceFormatString;
  final String unitPriceFormatString;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
  @override
  __HeaderPriceWidgetState createState() => __HeaderPriceWidgetState();
}

class __HeaderPriceWidgetState extends State<_HeaderPriceWidget> {
  Future<bool> requestWritePermission() async {
    final Map<PermissionGroup, PermissionStatus> permissionss =
        await PermissionHandler()
            .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);
    if (permissionss != null &&
        permissionss.isNotEmpty &&
        permissionss[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('******* ${widget.unitPriceFormatString}');
    if (widget.product != null && widget.product.unitPrice != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: PsColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (widget.product.isDiscount == PsConst.ONE)
                  PsHero(
                      tag: widget.heroTagOriginalPrice,
                      flightShuttleBuilder: Utils.flightShuttleBuilder,
                      child: Material(
                          color: PsColors.transparent,
                          child: Text(
                            '${widget.product.currencySymbol}${widget.originalPriceFormatString}',
                            style: Theme.of(context).textTheme.body1.copyWith(
                                decoration: TextDecoration.lineThrough),
                          )))
                else
                  Container(),
                const SizedBox(
                  height: PsDimens.space4,
                ),
                PsHero(
                  tag: widget.heroTagUnitPrice,
                  flightShuttleBuilder: Utils.flightShuttleBuilder,
                  child: Material(
                      color: PsColors.transparent,
                      child: Text(
                        '${widget.product.currencySymbol}${widget.unitPriceFormatString}',
                        //overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: PsColors.mainColor),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          if (widget.product.isDiscount == PsConst.ONE)
            Card(
              elevation: 0,
              color: PsColors.mainColor,
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(PsDimens.space8),
                      bottomLeft: Radius.circular(PsDimens.space8))),
              child: Container(
                width: 60,
                height: 30,
                padding: const EdgeInsets.only(
                    left: PsDimens.space4, right: PsDimens.space4),
                child: Align(
                  child: Text(
                    '- ${widget.product.discountPercent} %',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: PsColors.white),
                  ),
                ),
              ),
            )
          else
            Container(),
          const SizedBox(
            width: PsDimens.space10,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _HeaderButtonWidget extends StatelessWidget {
  const _HeaderButtonWidget({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    if (productDetail != null) {
      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: PsDimens.space4, vertical: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space10, bottom: PsDimens.space10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
           
              Column(
                children: <Widget>[
                  Text(
                    productDetail.favouriteCount ?? '',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'product_detail__whih_list'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    productDetail.touchCount ?? '',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'product_detail__seen'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Card();
    }
  }
}

class _AddToBasketAndBuyButtonWidget extends StatefulWidget {
  const _AddToBasketAndBuyButtonWidget({
    Key key,
    @required this.controller,
    @required this.productProvider,
    @required this.basketProvider,
    @required this.product,
    @required this.psValueHolder,
    @required this.intentQty,
    @required this.intentSelectedColorId,
    @required this.intentSelectedColorValue,
    @required this.intentbasketPrice,
    @required this.intentbasketSelectedAttributeList,
  }) : super(key: key);

  final AnimationController controller;
  final ProductDetailProvider productProvider;
  final BasketProvider basketProvider;
  final Product product;
  final PsValueHolder psValueHolder;
  final String intentQty;
  final String intentSelectedColorId;
  final String intentSelectedColorValue;
  final String intentbasketPrice;
  final List<BasketSelectedAttribute> intentbasketSelectedAttributeList;

  @override
  __AddToBasketAndBuyButtonWidgetState createState() =>
      __AddToBasketAndBuyButtonWidgetState();
}

class __AddToBasketAndBuyButtonWidgetState
    extends State<_AddToBasketAndBuyButtonWidget> {
  String qty;
  String colorId;
  String colorValue;
  bool checkAttribute;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  Basket basket;
  String id;
  double bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = widget.psValueHolder.phone == '' &&
            widget.psValueHolder.messenger == '' &&
            widget.psValueHolder.whatsApp == ''
        ? <IconData>[]
        : widget.psValueHolder.phone == '' &&
                widget.psValueHolder.messenger == ''
            ? <IconData>[
                FontAwesome.whatsapp,
              ]
            : widget.psValueHolder.phone == '' &&
                    widget.psValueHolder.whatsApp == ''
                ? <IconData>[
                    MaterialCommunityIcons.facebook_messenger,
                  ]
                : widget.psValueHolder.messenger == '' &&
                        widget.psValueHolder.whatsApp == ''
                    ? <IconData>[
                        Feather.phone,
                      ]
                    : widget.psValueHolder.phone == ''
                        ? <IconData>[
                            MaterialCommunityIcons.facebook_messenger,
                            FontAwesome.whatsapp,
                          ]
                        : widget.psValueHolder.messenger == ''
                            ? <IconData>[
                                FontAwesome.whatsapp,
                                Feather.phone,
                              ]
                            : widget.psValueHolder.whatsApp == ''
                                ? <IconData>[
                                    MaterialCommunityIcons.facebook_messenger,
                                    Feather.phone,
                                  ]
                                : <IconData>[
                                    MaterialCommunityIcons.facebook_messenger,
                                    FontAwesome.whatsapp,
                                    Feather.phone,
                                  ];

    final List<String> iconsLabel = widget.psValueHolder.phone == '' &&
            widget.psValueHolder.messenger == '' &&
            widget.psValueHolder.whatsApp == ''
        ? <String>[]
        : widget.psValueHolder.phone == '' &&
                widget.psValueHolder.messenger == ''
            ? <String>[
                Utils.getString(context, 'product_detail__whatsapp'),
              ]
            : widget.psValueHolder.phone == '' &&
                    widget.psValueHolder.whatsApp == ''
                ? <String>[
                    Utils.getString(context, 'product_detail__messenger')
                  ]
                : widget.psValueHolder.messenger == '' &&
                        widget.psValueHolder.whatsApp == ''
                    ? <String>[
                        Utils.getString(context, 'product_detail__call_phone')
                      ]
                    : widget.psValueHolder.phone == ''
                        ? <String>[
                            Utils.getString(
                                context, 'product_detail__messenger'),
                            Utils.getString(context, 'product_detail__whatsapp')
                          ]
                        : widget.psValueHolder.messenger == ''
                            ? <String>[
                                Utils.getString(
                                    context, 'product_detail__whatsapp'),
                                Utils.getString(
                                    context, 'product_detail__call_phone')
                              ]
                            : widget.psValueHolder.whatsApp == ''
                                ? <String>[
                                    Utils.getString(
                                        context, 'product_detail__messenger'),
                                    Utils.getString(
                                        context, 'product_detail__call_phone')
                                  ]
                                : <String>[
                                    Utils.getString(
                                        context, 'product_detail__messenger'),
                                    Utils.getString(
                                        context, 'product_detail__whatsapp'),
                                    Utils.getString(
                                        context, 'product_detail__call_phone')
                                  ];
    if (widget.intentQty != '') {
      qty = widget.intentQty;
    }
    if (widget.intentSelectedColorValue != '' &&
        widget.intentSelectedColorId != '') {
      colorId = widget.intentSelectedColorId;
      colorValue = widget.intentSelectedColorValue;
    }
    if (widget.intentbasketPrice != '') {
      bottomSheetPrice = double.parse(widget.intentbasketPrice);
    }
    if (widget.intentbasketSelectedAttributeList != null) {
      for (int i = 0;
          i < widget.intentbasketSelectedAttributeList.length;
          i++) {
        basketSelectedAttribute.addAttribute(BasketSelectedAttribute(
            headerId: widget.intentbasketSelectedAttributeList[i].headerId,
            id: widget.intentbasketSelectedAttributeList[i].id,
            name: widget.intentbasketSelectedAttributeList[i].name,
            price: widget.intentbasketSelectedAttributeList[i].price,
            currencySymbol:
                widget.intentbasketSelectedAttributeList[i].currencySymbol));
      }
    }
    Future<void> updatePrice(double price, double totalOriginalPrice) async {
      this.totalOriginalPrice = totalOriginalPrice;
      setState(() {
        bottomSheetPrice = price;
      });
    }

    Future<void> updateQty(String minimumOrder) async {
      setState(() {
        qty = minimumOrder;
      });
    }

    Future<void> updateColorIdAndValue(String id, String value) async {
      colorId = id;
      colorValue = value;
    }

    Future<void> addToBasketAndBuyClickEvent(bool isBuyButtonType) async {
 
        colorId = '1';
        if (colorId == null || colorId == '') {
          await showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(
                      context, 'product_detail__please_select_color'),
                );
              });
          return;
        }
      
      id =
          '${widget.product.id}$colorId ${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
      // Check All Attribute is selected
      if (widget.product.attributesHeaderList != null) {
        if (widget.product.attributesHeaderList[0].id != '' &&
            widget.product.attributesHeaderList[0].attributesDetail != null &&
            widget.product.attributesHeaderList[0].attributesDetail[0].id !=
                '' &&
            !basketSelectedAttribute.isAllAttributeSelected(
                widget.product.attributesHeaderList.length)) {
          await showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(
                      context, 'product_detail__please_choose_attribute'),
                );
              });
          return;
        }
      }

      basket = Basket(
          id: id,
          productId: widget.product.id,
          qty: qty ?? widget.product.minimumOrder,
          shopId: widget.basketProvider.psValueHolder.shopId,
          selectedColorId: colorId,
          selectedColorValue: colorValue,
          basketPrice: bottomSheetPrice == null
              ? widget.product.unitPrice
              : bottomSheetPrice.toString(),
          basketOriginalPrice: totalOriginalPrice == 0.0
              ? widget.product.originalPrice
              : totalOriginalPrice.toString(),
          selectedAttributeTotalPrice: basketSelectedAttribute
              .getTotalSelectedAttributePrice()
              .toString(),
          product: widget.product,
          basketSelectedAttributeList:
              basketSelectedAttribute.getSelectedAttributeList());

      await widget.basketProvider.addBasket(basket);

      Fluttertoast.showToast(
          msg:
              Utils.getString(context, 'product_detail__success_add_to_basket'),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: PsColors.mainColor,
          textColor: PsColors.white);

      await showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return SuccessDialog(
              message: Utils.getString(
                  context, 'product_detail__success_add_to_basket'),
            );
          });

      if (isBuyButtonType) {
        final dynamic result = await Navigator.pushNamed(
            context, RoutePaths.basketList,
            arguments: widget.productProvider.productDetail.data);
        if (result != null && result) {
          widget.productProvider.loadProduct(widget.product.id,
              widget.psValueHolder.loginUserId, widget.psValueHolder.shopId);
        }
      }
    }

    void _showDrawer(bool isBuyButtonType) {
      showModalBottomSheet<Widget>(
          elevation: 3.0,
          isScrollControlled: true,
          useRootNavigator: true,
          isDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(height: PsDimens.space12),
                  Container(
                    width: PsDimens.space52,
                    height: PsDimens.space4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: PsColors.mainDividerColor,
                    ),
                  ),
                  const SizedBox(height: PsDimens.space24),
                ],
              ),
              _ImageAndTextForBottomSheetWidget(
                product: widget.product,
                price:
                    bottomSheetPrice ?? double.parse(widget.product.unitPrice),
              ),
              Divider(height: PsDimens.space20, color: PsColors.mainColor),
              Flexible(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space16,
                      right: PsDimens.space16,
                      top: PsDimens.space8,
                      bottom: PsDimens.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _ColorsWidget(
                        product: widget.product,
                        updateColorIdAndValue: updateColorIdAndValue,
                        selectedColorId: colorId,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8,
                            left: PsDimens.space12,
                            right: PsDimens.space12),
                        child: Text(
                          Utils.getString(context, 'product_detail__how_many'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      _IconAndTextWidget(
                        product: widget.product,
                        updateQty: updateQty,
                        qty: qty,
                      ),
                      _AttributesWidget(
                          product: widget.product,
                          updatePrice: updatePrice,
                          basketSelectedAttribute: basketSelectedAttribute),
                      const SizedBox(
                        height: PsDimens.space12,
                      ),
                      if (isBuyButtonType)
                        _AddToBasketAndBuyForBottomSheetWidget(
                          addToBasketAndBuyClickEvent:
                              addToBasketAndBuyClickEvent,
                          isBuyButtonType: true,
                        )
                      else
                        _AddToBasketAndBuyForBottomSheetWidget(
                          addToBasketAndBuyClickEvent:
                              addToBasketAndBuyClickEvent,
                          isBuyButtonType: false,
                        ),
                    ],
                  ),
                ),
              ))
            ]);
          });
    }
    // basketRepo = Provider.of<BasketRepository>(context);

    if (widget.productProvider != null &&
        widget.productProvider.productDetail != null &&
        widget.productProvider.productDetail.data != null &&
        widget.basketProvider != null &&
        widget.basketProvider.basketList != null &&
        widget.basketProvider.basketList.data != null) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: PsDimens.space8),
              child: _FloatingActionButton(
                icons: icons,
                label: iconsLabel,
                controller: widget.controller,
                psValueHolder: widget.psValueHolder,
              ),
            ),
            const SizedBox(height: PsDimens.space12),
            SizedBox(
              width: double.infinity,
              height: PsDimens.space72,
              child: Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(PsDimens.space12),
                      topRight: Radius.circular(PsDimens.space12)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PsColors.mainShadowColor,
                        offset: const Offset(0.0, 0.0),
                        spreadRadius: 0,
                        blurRadius: 15.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: PSButtonWithIconWidget(
                          hasShadow: true,
                          colorData: PsColors.grey,
                          icon: Icons.add_shopping_cart,
                          width: double.infinity,
                          titleText: Utils.getString(
                              context, 'product_detail__add_to_basket'),
                          onPressed: () async {
                            if (widget.product.isAvailable == '1') {
                              _showDrawer(false);
                            } else {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WarningDialog(
                                      message: Utils.getString(context,
                                          'product_detail__is_not_available'),
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space10,
                      ),
                      Expanded(
                        child: PSButtonWithIconWidget(
                          hasShadow: true,
                          icon: Icons.shopping_cart,
                          width: double.infinity,
                          titleText:
                              Utils.getString(context, 'product_detail__buy'),
                          onPressed: () async {
                            if (widget.product.isAvailable == '1') {
                              _showDrawer(true);
                            } else {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return WarningDialog(
                                      message: Utils.getString(context,
                                          'product_detail__is_not_available'),
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _ImageAndTextForBottomSheetWidget extends StatefulWidget {
  const _ImageAndTextForBottomSheetWidget({
    Key key,
    @required this.product,
    @required this.price,
  }) : super(key: key);

  final Product product;
  final double price;
  @override
  __ImageAndTextForBottomSheetWidgetState createState() =>
      __ImageAndTextForBottomSheetWidgetState();
}

class __ImageAndTextForBottomSheetWidgetState
    extends State<_ImageAndTextForBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PsNetworkImage(
              photoKey: '',
              width: PsDimens.space60,
              height: PsDimens.space60,
              defaultPhoto: widget.product.defaultPhoto,
            ),
            const SizedBox(
              width: PsDimens.space8,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: PsDimens.space8),
                    child: (widget.product.isDiscount == PsConst.ONE)
                        ? Row(
                            children: <Widget>[
                              Text(
                                widget.price != null
                                    ? '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.price.toString())}'
                                    : '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.unitPrice)}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(color: PsColors.mainColor),
                              ),
                              const SizedBox(
                                width: PsDimens.space8,
                              ),
                              Text(
                                '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.originalPrice)}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        decoration: TextDecoration.lineThrough),
                              )
                            ],
                          )
                        : Text(
                            widget.price != null
                                ? '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.price.toString())}'
                                : '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.unitPrice)}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .copyWith(color: PsColors.mainColor),
                          ),
                  ),
                  const SizedBox(
                    height: PsDimens.space2,
                  ),
                  Text(
                    widget.product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: PsColors.grey),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _IconAndTextWidget extends StatefulWidget {
  const _IconAndTextWidget({
    Key key,
    @required this.product,
    @required this.updateQty,
    @required this.qty,
  }) : super(key: key);

  final Product product;
  final Function updateQty;
  final String qty;

  @override
  _IconAndTextWidgetState createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<_IconAndTextWidget> {
  String minimumItemCount = '';
  bool isFirstTime = true;
  @override
  Widget build(BuildContext context) {
    if (minimumItemCount == '') {
      minimumItemCount = widget.qty;
    }
    if (widget.product.minimumOrder == '0') {
      widget.product.minimumOrder = '1';
    }
    void _increaseItemCount() {
      if (isFirstTime) {
        setState(() {
          minimumItemCount =
              (int.parse(widget.product.minimumOrder) + 1).toString();
          isFirstTime = false;
          widget.updateQty(minimumItemCount ?? widget.product.minimumOrder);
        });
      } else {
        setState(() {
          minimumItemCount = (int.parse(minimumItemCount) + 1).toString();
          widget.updateQty(minimumItemCount ?? widget.product.minimumOrder);
        });
      }
    }

    void _decreaseItemCount() {
      if (minimumItemCount != null &&
          int.parse(minimumItemCount) >
              int.parse(widget.product.minimumOrder)) {
        setState(() {
          minimumItemCount = (int.parse(minimumItemCount) - 1).toString();
          widget.updateQty(minimumItemCount ?? widget.product.minimumOrder);
        });
      } else {
        Fluttertoast.showToast(
            msg:
                ' ${Utils.getString(context, 'product_detail__minimum_order')}  ${widget.product.minimumOrder}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: PsColors.mainColor,
            textColor: PsColors.white);
      }
    }

    void onUpdateItemCount(int buttonType) {
      if (buttonType == 1) {
        _increaseItemCount();
      } else if (buttonType == 2) {
        _decreaseItemCount();
      }
    }

    final Widget _addIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.add_circle, color: PsColors.mainColor),
        onPressed: () {
          onUpdateItemCount(1);
        });

    final Widget _removeIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.remove_circle, color: PsColors.grey),
        onPressed: () {
          onUpdateItemCount(2);
        });
    return Container(
      margin:
          const EdgeInsets.only(top: PsDimens.space8, bottom: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _removeIconWidget,
          Center(
            child: Container(
              height: PsDimens.space24,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(border: Border.all(color: PsColors.grey)),
              padding: const EdgeInsets.only(
                  left: PsDimens.space24, right: PsDimens.space24),
              child: Text(
                minimumItemCount ?? widget.product.minimumOrder,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: PsColors.mainColor),
              ),
            ),
          ),
          _addIconWidget,
        ],
      ),
    );
  }
}

class _ColorsWidget extends StatefulWidget {
  const _ColorsWidget({
    Key key,
    @required this.product,
    @required this.updateColorIdAndValue,
    @required this.selectedColorId,
  }) : super(key: key);

  final Product product;
  final Function updateColorIdAndValue;
  final String selectedColorId;
  @override
  __ColorsWidgetState createState() => __ColorsWidgetState();
}

class __ColorsWidgetState extends State<_ColorsWidget> {
  String _selectedColorId = '';

  @override
  Widget build(BuildContext context) {
    if (_selectedColorId == '') {
      _selectedColorId = widget.selectedColorId;
    }
   return Container();
  }
}

class _AttributesWidget extends StatefulWidget {
  const _AttributesWidget({
    Key key,
    @required this.product,
    @required this.updatePrice,
    @required this.basketSelectedAttribute,
  }) : super(key: key);

  final Product product;
  final Function updatePrice;
  final BasketSelectedAttribute basketSelectedAttribute;
  @override
  __AttributesWidgetState createState() => __AttributesWidgetState();
}

class __AttributesWidgetState extends State<_AttributesWidget> {
  double totalPrice;
  double totalOriginalPrice;

  @override
  Widget build(BuildContext context) {
    if (widget.product.attributesHeaderList.isNotEmpty &&
        widget.product.attributesHeaderList[0].id != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  top: PsDimens.space8,
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space8),
              child: Text(
                Utils.getString(context, 'product_detail__other_information'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              )),
          Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.product.attributesHeaderList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AttributesItemView(
                          attribute: widget.product.attributesHeaderList[index],
                          attributeName: widget.basketSelectedAttribute
                              .getSelectedAttributeNameByHeaderId(
                                  widget.product.attributesHeaderList[index].id,
                                  widget.product.attributesHeaderList[index]
                                      .name),
                          onTap: () async {
                            final dynamic result = await Navigator.pushNamed(
                                context, RoutePaths.attributeDetailList,
                                arguments: AttributeDetailIntentHolder(
                                    attributeDetail: widget
                                        .product
                                        .attributesHeaderList[index]
                                        .attributesDetail,
                                    product: widget.product));

                            if (result != null && result is AttributeDetail) {
                              // Update selected attribute
                              widget.basketSelectedAttribute.addAttribute(
                                  BasketSelectedAttribute(
                                      headerId: result.headerId,
                                      id: result.id,
                                      name: result.name,
                                      price: result.additionalPrice,
                                      currencySymbol:
                                          widget.product.currencySymbol));
                              // Get Total Selected Attribute Price
                              final double selectedAttributePrice = widget
                                  .basketSelectedAttribute
                                  .getTotalSelectedAttributePrice();

                              // Update Price
                              totalPrice =
                                  double.parse(widget.product.unitPrice) +
                                      selectedAttributePrice;

                              totalOriginalPrice =
                                  double.parse(widget.product.originalPrice) +
                                      selectedAttributePrice;

                              widget.updatePrice(
                                  totalPrice, totalOriginalPrice);

                              // Update UI
                              setState(() {});
                            } else {}
                          });
                    }),
              )),
        ],
      );
    } else {
      return Container();
    }
  }
}

class _AddToBasketAndBuyForBottomSheetWidget extends StatefulWidget {
  const _AddToBasketAndBuyForBottomSheetWidget({
    Key key,
    @required this.addToBasketAndBuyClickEvent,
    @required this.isBuyButtonType,
  }) : super(key: key);

  final Function addToBasketAndBuyClickEvent;
  final bool isBuyButtonType;
  @override
  __AddToBasketAndBuyForBottomSheetWidgetState createState() =>
      __AddToBasketAndBuyForBottomSheetWidgetState();
}

class __AddToBasketAndBuyForBottomSheetWidgetState
    extends State<_AddToBasketAndBuyForBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isBuyButtonType) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            right: PsDimens.space16,
            left: PsDimens.space16,
            bottom: PsDimens.space16),
        child: PSButtonWithIconWidget(
            hasShadow: true,
            icon: Icons.shopping_cart,
            width: double.infinity,
            titleText: Utils.getString(context, 'product_detail__buy'),
            onPressed: () async {
              widget.addToBasketAndBuyClickEvent(true);
            }),
      );
    } else {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            right: PsDimens.space16,
            left: PsDimens.space16,
            bottom: PsDimens.space16),
        child: PSButtonWithIconWidget(
            hasShadow: true,
            icon: Icons.add_shopping_cart,
            width: double.infinity,
            titleText:
                Utils.getString(context, 'product_detail__add_to_basket'),
            onPressed: () async {
              widget.addToBasketAndBuyClickEvent(false);
            }),
      );
    }
  }
}

class _FloatingActionButton extends StatefulWidget {
  const _FloatingActionButton({
    Key key,
    @required this.controller,
    @required this.icons,
    @required this.label,
    @required this.psValueHolder,
  }) : super(key: key);

  final AnimationController controller;
  final List<IconData> icons;
  final List<String> label;
  final PsValueHolder psValueHolder;
  @override
  __FloatingActionButtonState createState() => __FloatingActionButtonState();
}

class __FloatingActionButtonState extends State<_FloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    final String whatsappUrl = 'https://wa.me/${widget.psValueHolder.whatsApp}';
    final String messengerUrl = 'http://m.me/${widget.psValueHolder.messenger}';
    final String phoneCall = 'tel://${widget.psValueHolder.phone}';

    if (widget.icons.isNotEmpty && widget.label.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List<Widget>.generate(widget.icons.length, (int index) {
          Widget _getChip() {
            return Chip(
              backgroundColor: PsColors.mainColor,
              label: InkWell(
                onTap: () async {
                  print(index);

                  await launch(widget.label[index] ==
                          Utils.getString(context, 'product_detail__messenger')
                      ? messengerUrl
                      : widget.label[index] ==
                              Utils.getString(
                                  context, 'product_detail__whatsapp')
                          ? whatsappUrl
                          : phoneCall);
                },
                child: Text(
                  widget.label[index],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: PsColors.white),
                ),
              ),
            );
          }

          final Widget child = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: PsDimens.space8),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve:
                        Interval((index + 1) / 10, 1.0, curve: Curves.easeIn),
                  ),
                  child: _getChip(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space4, vertical: PsDimens.space2),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: widget.controller,
                    curve: Interval(
                        0.0, 1.0 - index / widget.icons.length / 2.0,
                        curve: Curves.easeIn),
                  ),
                  child: FloatingActionButton(
                    heroTag: widget.label[index],
                    backgroundColor: PsColors.mainColor,
                    mini: true,
                    child: Icon(widget.icons[index], color: PsColors.white),
                    onPressed: () async {
                      print(widget.label[index]);

                      await launch(widget.label[index] ==
                              Utils.getString(
                                  context, 'product_detail__messenger')
                          ? messengerUrl
                          : widget.label[index] ==
                                  Utils.getString(
                                      context, 'product_detail__whatsapp')
                              ? whatsappUrl
                              : phoneCall);
                    },
                  ),
                ),
              ),
            ],
          );
          return child;
        }).toList()
          ..add(
            Container(
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: FloatingActionButton(
                backgroundColor: PsColors.mainColor,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform:
                          Matrix4.rotationZ(widget.controller.value * 0.5 * 8),
                      alignment: FractionalOffset.center,
                      child: Icon(
                        widget.controller.isDismissed ? Icons.sms : Icons.sms,
                        color: PsColors.white,
                      ),
                    );
                  },
                ),
                onPressed: () {
                  if (widget.controller.isDismissed) {
                    widget.controller.forward();
                  } else {
                    widget.controller.reverse();
                  }
                },
              ),
            ),
          ),
      );
    } else {
      return Container();
    }
  }
}
