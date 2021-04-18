import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/product/favourite_product_provider.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/product/item/product_vertical_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:provider/provider.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider _favouriteProductProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConst.SHOW_ADMOB) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConst.SHOW_ADMOB) {
      print('loading ads....');
      checkConnection();
    }
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<FavouriteProductProvider>(
          create: (BuildContext context) {
            final FavouriteProductProvider provider = FavouriteProductProvider(
                repo: repo1, psValueHolder: psValueHolder);
            provider.loadFavouriteProductList();
            _favouriteProductProvider = provider;
            return _favouriteProductProvider;
          },
          child: Consumer<FavouriteProductProvider>(
            builder: (BuildContext context, FavouriteProductProvider provider,
                Widget child) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  // Visibility(
                  //   visible: PsConst.SHOW_ADMOB &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.FULL_BANNER,
                  //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
                  //       print('BannerAd event is $event');
                  //       if (event == AdmobAdEvent.loaded) {
                  //         isSuccessfullyLoaded = true;
                  //       } else {
                  //         isSuccessfullyLoaded = false;
                  //         setState(() {});
                  //       }
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(
                              left: PsDimens.space4,
                              right: PsDimens.space4,
                              top: PsDimens.space4,
                              bottom: PsDimens.space4),
                          child: RefreshIndicator(
                            child: CustomScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220,
                                            childAspectRatio: 0.6),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (provider.favouriteProductList
                                                    .data !=
                                                null ||
                                            provider.favouriteProductList.data
                                                .isNotEmpty) {
                                          final int count = provider
                                              .favouriteProductList.data.length;
                                          return ProductVeticalListItem(
                                            coreTagKey:
                                                provider.hashCode.toString() +
                                                    provider
                                                        .favouriteProductList
                                                        .data[index]
                                                        .id,
                                            animationController:
                                                widget.animationController,
                                            animation: Tween<double>(
                                                    begin: 0.0, end: 1.0)
                                                .animate(
                                              CurvedAnimation(
                                                parent:
                                                    widget.animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn),
                                              ),
                                            ),
                                            product: provider
                                                .favouriteProductList
                                                .data[index],
                                            onTap: () async {
                                              final Product product = provider
                                                  .favouriteProductList
                                                  .data[index];
                                              final ProductDetailIntentHolder
                                                  holder =
                                                  ProductDetailIntentHolder(
                                                product: product,
                                                heroTagImage: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst.HERO_TAG__IMAGE,
                                                heroTagTitle: provider.hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst.HERO_TAG__TITLE,
                                                heroTagOriginalPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst
                                                        .HERO_TAG__ORIGINAL_PRICE,
                                                heroTagUnitPrice: provider
                                                        .hashCode
                                                        .toString() +
                                                    product.id +
                                                    PsConst
                                                        .HERO_TAG__UNIT_PRICE,
                                              );

                                              await Navigator.pushNamed(context,
                                                  RoutePaths.productDetail,
                                                  arguments: holder);

                                              await provider
                                                  .resetFavouriteProductList();
                                            },
                                          );
                                        } else {
                                          return null;
                                        }
                                      },
                                      childCount: provider
                                          .favouriteProductList.data.length,
                                    ),
                                  ),
                                ]),
                            onRefresh: () {
                              return provider.resetFavouriteProductList();
                            },
                          )),
                      PSProgressIndicator(provider.favouriteProductList.status)
                    ]),
                  )
                ],
              );
            },
          ),
        ));
  }
}
