import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/provider/category/trending_category_provider.dart';
import 'package:fluttermultistoreflutter/provider/common/notification_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/discount_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/feature_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/search_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/product/trending_product_provider.dart';
import 'package:fluttermultistoreflutter/provider/productcollection/product_collection_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultistoreflutter/repository/Common/notification_repository.dart';
import 'package:fluttermultistoreflutter/repository/product_collection_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_info_repository.dart';
import 'package:fluttermultistoreflutter/ui/category/item/category_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/ui/category/item/category_horizontal_trending_list_item.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/noti_dialog.dart';
import 'package:fluttermultistoreflutter/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:fluttermultistoreflutter/ui/product/item/product_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/ui/product_dashboard/product_home/collection_product_slider.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/noti_register_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:fluttermultistoreflutter/viewobject/product_collection_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/category/category_provider.dart';
import 'package:fluttermultistoreflutter/repository/category_repository.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';

class ProductHomeDashboardViewWidget extends StatefulWidget {
  const ProductHomeDashboardViewWidget(
      this._scrollController,
      this.animationController,
      this.context,
      this.shopId,
      // this.sliverAppBar,
      this.onNotiClicked);
  final ScrollController _scrollController;
  final AnimationController animationController;
  final BuildContext context;
  final String shopId;

  // final Widget sliverAppBar;
  final Function onNotiClicked;

  @override
  _ProductHomeDashboardViewWidgetState createState() =>
      _ProductHomeDashboardViewWidgetState();
}

class _ProductHomeDashboardViewWidgetState
    extends State<ProductHomeDashboardViewWidget> {
  // var provider2;
  PsValueHolder valueHolder;
  CategoryRepository repo1;
  ProductRepository repo2;
  ProductCollectionRepository repo3;
  ShopInfoRepository shopInfoRepository;
  NotificationRepository notificationRepository;
  CategoryProvider _categoryProvider;
  final int count = 8;

  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider
          .loadCategoryList(_categoryProvider.latestCategoryParameterHolder);
    }

    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels ==
          widget._scrollController.position.maxScrollExtent) {
        _categoryProvider
            .nextCategoryList(_categoryProvider.latestCategoryParameterHolder);
      }
    });

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    }

    _fcm.subscribeToTopic('broadcast');
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final dynamic data = message['notification'] ?? message;
        print('data message : $data');
        final String notiMessage = data['title'];
        print('noti message : $notiMessage');
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
      //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        final dynamic data = message['notification'] ?? message;
        final String notiMessage = data['title'];
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        final dynamic data = message['notification'] ?? message;
        final String notiMessage = data['title'];
        //_showNotificationWithDefaultSound(notiMessage);
        onSelectNotification(notiMessage);
      },
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (context == null) {
      widget.onNotiClicked(payload);
    } else {
      return showDialog<dynamic>(
        context: context,
        builder: (_) {
          return NotiDialog(message: '$payload');
        },
      );
    }
  }

  Future<void> _saveDeviceToken(
      FirebaseMessaging _fcm, NotificationProvider notificationProvider) async {
    // Get the current user

    // Get the token for this device
    final String fcmToken = await _fcm.getToken();
    await notificationProvider.replaceNotiToken(fcmToken);

    final NotiRegisterParameterHolder notiRegisterParameterHolder =
        NotiRegisterParameterHolder(
            platformName: PsConst.PLATFORM,
            deviceId: fcmToken,
            loginUserId:
                Utils.checkUserLoginId2(notificationProvider.psValueHolder));
    print('Token Key $fcmToken');
    if (fcmToken != null) {
      await notificationProvider
          .rawRegisterNotiToken(notiRegisterParameterHolder.toMap());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<ShopInfoProvider>(
              create: (BuildContext context) {
            final ShopInfoProvider provider = ShopInfoProvider(
                repo: shopInfoRepository,
                psValueHolder: valueHolder,
                ownerCode: 'ProductHomeDashboardViewWidget');
       
            provider.loadShopInfo('shopd43660cf5ed4cc9f09c2ace31ddd88f6');
            return provider;
          }),
          ChangeNotifierProvider<CategoryProvider>(
              create: (BuildContext context) {
            _categoryProvider ??= CategoryProvider(
                repo: repo1,
                psValueHolder: valueHolder,
                limit: PsConfig.CATEGORY_LOADING_LIMIT);
            _categoryProvider.latestCategoryParameterHolder.shopId =
                'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            _categoryProvider.loadCategoryList(
                _categoryProvider.latestCategoryParameterHolder);
            return _categoryProvider;
          }),
          ChangeNotifierProvider<TrendingCategoryProvider>(
              create: (BuildContext context) {
            final TrendingCategoryProvider provider = TrendingCategoryProvider(
                repo: repo1,
                psValueHolder: valueHolder,
                limit: PsConfig.TRENDING_PRODUCT_LOADING_LIMIT);
            provider.trendingCategoryParameterHolder.shopId = 'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            provider.loadTrendingCategoryList(
                provider.trendingCategoryParameterHolder);
            return provider;
          }),
          ChangeNotifierProvider<SearchProductProvider>(
              create: (BuildContext context) {
            final SearchProductProvider provider = SearchProductProvider(
                repo: repo2, limit: PsConfig.LATEST_PRODUCT_LOADING_LIMIT);
            provider.latestProductParameterHolder.shopId = 'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            provider
                .loadProductListByKey(provider.latestProductParameterHolder);
            return provider;
          }),
          ChangeNotifierProvider<DiscountProductProvider>(
              create: (BuildContext context) {
            final DiscountProductProvider provider = DiscountProductProvider(
                repo: repo2, limit: PsConfig.DISCOUNT_PRODUCT_LOADING_LIMIT);
            provider.discountProductParameterHolder.shopId = 'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            provider.loadProductList(provider.discountProductParameterHolder);
            return provider;
          }),
          ChangeNotifierProvider<TrendingProductProvider>(
              create: (BuildContext context) {
            final TrendingProductProvider provider = TrendingProductProvider(
                repo: repo2, limit: PsConfig.TRENDING_PRODUCT_LOADING_LIMIT);
            provider.trendingProductParameterHolder.shopId = 'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            provider.loadProductList(provider.trendingProductParameterHolder);
            return provider;
          }),
          ChangeNotifierProvider<FeaturedProductProvider>(
              create: (BuildContext context) {
            final FeaturedProductProvider provider = FeaturedProductProvider(
                repo: repo2, limit: PsConfig.FEATURE_PRODUCT_LOADING_LIMIT);
            provider.featuredProductParameterHolder.shopId = 'shopd43660cf5ed4cc9f09c2ace31ddd88f6';
            provider.loadProductList(provider.featuredProductParameterHolder);
            return provider;
          }),
          ChangeNotifierProvider<ProductCollectionProvider>(
              create: (BuildContext context) {
            final ProductCollectionProvider provider =
                ProductCollectionProvider(
                    repo: repo3,
                    psValueHolder: valueHolder,
                    limit: PsConfig.COLLECTION_PRODUCT_LOADING_LIMIT);
            provider.loadProductCollectionList('shopd43660cf5ed4cc9f09c2ace31ddd88f6');
            return provider;
          }),
          ChangeNotifierProvider<NotificationProvider>(
              create: (BuildContext context) {
            final NotificationProvider provider = NotificationProvider(
                repo: notificationRepository, psValueHolder: valueHolder);

            if (provider.psValueHolder.deviceToken == null ||
                provider.psValueHolder.deviceToken == '') {
              final FirebaseMessaging _fcm = FirebaseMessaging();
              _saveDeviceToken(_fcm, provider);
            } else {
              print(
                  'Notification Token is already registered. Notification Setting : true.');
            }

            return provider;
          }),
        ],
        child: Container(
          color: PsColors.coreBackgroundColor,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              _HomeCollectionProductSliderListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 1, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),

              ///
              /// category List Widget
              ///
              _HomeCategoryHorizontalListWidget(
                psValueHolder: valueHolder,
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),

              _DiscountProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 3, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),

              _HomeFeaturedProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 4, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeSelectingProductTypeWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 5, 1.0,
                            curve: Curves.fastOutSlowIn))),
              ),
              _HomeTrendingCategoryHorizontalListWidget(
                psValueHolder: valueHolder,
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 6, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),

              _HomeLatestProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 7, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),

              _HomeTrendingProductHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 4, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
            ],
          ),
        ));
  }
}

class _HomeLatestProductHorizontalListWidget extends StatelessWidget {
  const _HomeLatestProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<SearchProductProvider>(
        builder: (BuildContext context, SearchProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: (productProvider.productList.data != null &&
                            productProvider.productList.data.isNotEmpty)
                        ? Column(children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__latest_product'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.filterProductList,
                                    arguments: ProductListIntentHolder(
                                      appBarTitle: Utils.getString(
                                          context, 'dashboard__latest_product'),
                                      productParameterHolder:
                                          ProductParameterHolder()
                                              .getLatestParameterHolder(),
                                    ));
                              },
                            ),
                            Container(
                                height: PsDimens.space300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    itemCount:
                                        productProvider.productList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (productProvider.productList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        final Product product = productProvider
                                            .productList.data[index];
                                        return ProductHorizontalListItem(
                                          coreTagKey: productProvider.hashCode
                                                  .toString() +
                                              product.id,
                                          product: productProvider
                                              .productList.data[index],
                                          onTap: () {
                                            print(product.defaultPhoto.imgPath);

                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                              product: product,
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__TITLE,
                                              heroTagOriginalPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst
                                                      .HERO_TAG__ORIGINAL_PRICE,
                                              heroTagUnitPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                            );

                                            Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);
                                          },
                                        );
                                      }
                                    }))
                          ])
                        : Container(),
                  ),
                );
              });
        },
      ),
    );
  }
}

class _HomeFeaturedProductHorizontalListWidget extends StatelessWidget {
  const _HomeFeaturedProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeaturedProductProvider>(
        builder: (BuildContext context, FeaturedProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: (productProvider.productList.data != null &&
                          productProvider.productList.data.isNotEmpty)
                      ? Column(
                          children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__feature_product'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.filterProductList,
                                    arguments: ProductListIntentHolder(
                                        appBarTitle: Utils.getString(context,
                                            'dashboard__feature_product'),
                                        productParameterHolder:
                                            ProductParameterHolder()
                                                .getFeaturedParameterHolder()));
                              },
                            ),
                            Container(
                                height: PsDimens.space300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    itemCount:
                                        productProvider.productList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (productProvider.productList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        final Product product = productProvider
                                            .productList.data[index];
                                        return ProductHorizontalListItem(
                                          coreTagKey: productProvider.hashCode
                                                  .toString() +
                                              product.id,
                                          product: productProvider
                                              .productList.data[index],
                                          onTap: () {
                                            print(productProvider
                                                .productList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                              product: productProvider
                                                  .productList.data[index],
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__TITLE,
                                              heroTagOriginalPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst
                                                      .HERO_TAG__ORIGINAL_PRICE,
                                              heroTagUnitPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                            );

                                            Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);
                                          },
                                        );
                                      }
                                    }))
                          ],
                        )
                      : Container(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeTrendingProductHorizontalListWidget extends StatelessWidget {
  const _HomeTrendingProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<TrendingProductProvider>(
        builder: (BuildContext context, TrendingProductProvider productProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: (productProvider.productList.data != null &&
                          productProvider.productList.data.isNotEmpty)
                      ? Column(
                          children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__trending_product'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.filterProductList,
                                    arguments: ProductListIntentHolder(
                                        appBarTitle: Utils.getString(context,
                                            'dashboard__trending_product'),
                                        productParameterHolder:
                                            ProductParameterHolder()
                                                .getTrendingParameterHolder()));
                              },
                            ),
                            Container(
                                height: PsDimens.space300,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        productProvider.productList.data.length,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (productProvider.productList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        final Product product = productProvider
                                            .productList.data[index];
                                        return ProductHorizontalListItem(
                                          coreTagKey: productProvider.hashCode
                                                  .toString() +
                                              product.id,
                                          product: productProvider
                                              .productList.data[index],
                                          onTap: () {
                                            print(productProvider
                                                .productList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                              product: productProvider
                                                  .productList.data[index],
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__TITLE,
                                              heroTagOriginalPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst
                                                      .HERO_TAG__ORIGINAL_PRICE,
                                              heroTagUnitPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                            );
                                            Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);
                                          },
                                        );
                                      }
                                    }))
                          ],
                        )
                      : Container(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeSelectingProductTypeWidget extends StatelessWidget {
  const _HomeSelectingProductTypeWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: Container(
                    color: PsColors.backgroundColor,
                    margin: const EdgeInsets.only(top: PsDimens.space20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                       
                      ],
                    )),
              ),
            );
          }),
    );
  }
}

class _SelectingImageAndTextWidget extends StatelessWidget {
  const _SelectingImageAndTextWidget(
      {Key key,
      @required this.imagePath,
      @required this.title,
      @required this.description,
      @required this.onTap})
      : super(key: key);

  final String imagePath;
  final String title;
  final String description;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                imagePath,
                width: PsDimens.space60,
                height: PsDimens.space60,
              ),
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subhead),
            const SizedBox(
              height: PsDimens.space12,
            ),
            Text(description,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption),
          ],
        ),
      ),
    );
  }
}

class _HomeTrendingCategoryHorizontalListWidget extends StatelessWidget {
  const _HomeTrendingCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<TrendingCategoryProvider>(builder:
        (BuildContext context,
            TrendingCategoryProvider trendingCategoryProvider, Widget child) {
      return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: Consumer<TrendingCategoryProvider>(builder:
                      (BuildContext context,
                          TrendingCategoryProvider trendingCategoryProvider,
                          Widget child) {
                    return (trendingCategoryProvider.categoryList.data !=
                                null &&
                            trendingCategoryProvider
                                .categoryList.data.isNotEmpty)
                        ? Column(children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__trending_category'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.trendingCategoryList,
                                    arguments: Utils.getString(context,
                                        'tranding_category__trending_category_list'));
                              },
                            ),
                            Container(
                              height: PsDimens.space320,
                              margin: const EdgeInsets.only(
                                  top: PsDimens.space12,
                                  bottom: PsDimens.space12,
                                  left: PsDimens.space16),
                              width: MediaQuery.of(context).size.width,
                              child: CustomScrollView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio: 0.8),
                                      delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                          if (trendingCategoryProvider
                                                  .categoryList.status ==
                                              PsStatus.BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor: PsColors.grey,
                                                highlightColor: PsColors.white,
                                                child: Row(
                                                    children: const <Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            if (trendingCategoryProvider
                                                        .categoryList.data !=
                                                    null ||
                                                trendingCategoryProvider
                                                    .categoryList
                                                    .data
                                                    .isNotEmpty) {
                                              return CategoryHorizontalTrendingListItem(
                                                category:
                                                    trendingCategoryProvider
                                                        .categoryList
                                                        .data[index],
                                                animationController:
                                                    animationController,
                                                animation: Tween<double>(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(
                                                  CurvedAnimation(
                                                    parent: animationController,
                                                    curve: Interval(
                                                        (1 /
                                                                trendingCategoryProvider
                                                                    .categoryList
                                                                    .data
                                                                    .length) *
                                                            index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Utils.checkUserLoginId(
                                                          psValueHolder)
                                                      .then((String
                                                          loginUserId) async {
                                                    final TouchCountParameterHolder
                                                        touchCountParameterHolder =
                                                        TouchCountParameterHolder(
                                                            typeId:
                                                                trendingCategoryProvider
                                                                    .categoryList
                                                                    .data[index]
                                                                    .id,
                                                            typeName: PsConst
                                                                .FILTERING_TYPE_NAME_CATEGORY,
                                                            userId:
                                                                trendingCategoryProvider
                                                                    .psValueHolder
                                                                    .loginUserId,
                                                            shopId:
                                                                trendingCategoryProvider
                                                                    .categoryList
                                                                    .data[index]
                                                                    .shopId);

                                                    trendingCategoryProvider
                                                        .postTouchCount(
                                                            touchCountParameterHolder
                                                                .toMap());
                                                  });
                                                  print(trendingCategoryProvider
                                                      .categoryList
                                                      .data[index]
                                                      .defaultPhoto
                                                      .imgPath);
                                                  final ProductParameterHolder
                                                      productParameterHolder =
                                                      ProductParameterHolder()
                                                          .getLatestParameterHolder();
                                                  productParameterHolder.catId =
                                                      trendingCategoryProvider
                                                          .categoryList
                                                          .data[index]
                                                          .id;
                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutePaths
                                                          .filterProductList,
                                                      arguments:
                                                          ProductListIntentHolder(
                                                        appBarTitle:
                                                            trendingCategoryProvider
                                                                .categoryList
                                                                .data[index]
                                                                .name,
                                                        productParameterHolder:
                                                            productParameterHolder,
                                                      ));
                                                },
                                              );
                                            } else {
                                              return null;
                                            }
                                          }
                                        },
                                        childCount: trendingCategoryProvider
                                            .categoryList.data.length,
                                      ),
                                    ),
                                  ]),
                            )
                          ])
                        : Container();
                  })));
        },
      );
    }));
  }
}

class _DiscountProductHorizontalListWidget extends StatefulWidget {
  const _DiscountProductHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __DiscountProductHorizontalListWidgetState createState() =>
      __DiscountProductHorizontalListWidgetState();
}

class __DiscountProductHorizontalListWidgetState
    extends State<_DiscountProductHorizontalListWidget> {
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
    return SliverToBoxAdapter(
        // fdfdf
        child: Consumer<DiscountProductProvider>(builder: (BuildContext context,
            DiscountProductProvider productProvider, Widget child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: (productProvider.productList.data != null &&
                            productProvider.productList.data.isNotEmpty)
                        ? Column(children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'dashboard__discount_product'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.filterProductList,
                                    arguments: ProductListIntentHolder(
                                        appBarTitle: Utils.getString(context,
                                            'dashboard__discount_product'),
                                        productParameterHolder:
                                            ProductParameterHolder()
                                                .getDiscountParameterHolder()));
                              },
                            ),
                            Container(
                                height: PsDimens.space320,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    itemCount:
                                        productProvider.productList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (productProvider.productList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        final Product product = productProvider
                                            .productList.data[index];
                                        return ProductHorizontalListItem(
                                          coreTagKey: productProvider.hashCode
                                                  .toString() +
                                              product.id,
                                          product: productProvider
                                              .productList.data[index],
                                          onTap: () {
                                            print(productProvider
                                                .productList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                              product: productProvider
                                                  .productList.data[index],
                                              heroTagImage: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__IMAGE,
                                              heroTagTitle: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__TITLE,
                                              heroTagOriginalPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst
                                                      .HERO_TAG__ORIGINAL_PRICE,
                                              heroTagUnitPrice: productProvider
                                                      .hashCode
                                                      .toString() +
                                                  product.id +
                                                  PsConst.HERO_TAG__UNIT_PRICE,
                                            );
                                            Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);
                                          },
                                        );
                                      }
                                    })),
                            const PsAdMobBannerWidget(
                              admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            ),
                            // Visibility(
                            //   visible: PsConst.SHOW_ADMOB &&
                            //       isSuccessfullyLoaded &&
                            //       isConnectedToInternet,
                            //   child: AdmobBanner(
                            //     adUnitId: Utils.getBannerAdUnitId(),
                            //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                            //     listener: (AdmobAdEvent event,
                            //         Map<String, dynamic> map) {
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
                          ])
                        : Container()));
          });
    }));
  }
}

class _HomeCollectionProductSliderListWidget extends StatelessWidget {
  const _HomeCollectionProductSliderListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<ProductCollectionProvider>(builder: (BuildContext context,
          ProductCollectionProvider collectionProductProvider, Widget child) {
        return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: (collectionProductProvider
                                      .productCollectionList.data !=
                                  null &&
                              collectionProductProvider
                                  .productCollectionList.data.isNotEmpty)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _MyHeaderWidget(
                                  headerName: Utils.getString(
                                      context, 'dashboard__collection_product'),
                                  viewAllClicked: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutePaths.collectionProductList,
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: PsColors.mainLightShadowColor,
                                          offset: const Offset(1.1, 1.1),
                                          blurRadius: PsDimens.space8),
                                    ],
                                  ),
                                  margin: const EdgeInsets.only(
                                      top: PsDimens.space8,
                                      bottom: PsDimens.space20),
                                  width: double.infinity,
                                  child: CollectionProductSliderView(
                                    collectionProductList:
                                        collectionProductProvider
                                            .productCollectionList.data,
                                    onTap: (ProductCollectionHeader
                                        collectionProduct) {
                                      Navigator.pushNamed(context,
                                          RoutePaths.productListByCollectionId,
                                          arguments:
                                              ProductListByCollectionIdView(
                                            productCollectionHeader:
                                                collectionProduct,
                                            appBarTitle: collectionProduct.name,
                                          ));
                                    },
                                  ),
                                )
                              ],
                            )
                          : Container()));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: (categoryProvider.categoryList.data != null &&
                              categoryProvider.categoryList.data.isNotEmpty)
                          ? Column(children: <Widget>[
                              _MyHeaderWidget(
                                headerName: Utils.getString(
                                    context, 'dashboard__categories'),
                                viewAllClicked: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.categoryList,
                                      arguments: 'Categories');
                                },
                              ),
                              Container(
                                height: PsDimens.space140,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryProvider
                                        .categoryList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (categoryProvider
                                              .categoryList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        return CategoryHorizontalListItem(
                                          category: categoryProvider
                                              .categoryList.data[index],
                                          onTap: () {
                                            Utils.checkUserLoginId(
                                                    widget.psValueHolder)
                                                .then(
                                                    (String loginUserId) async {
                                              final TouchCountParameterHolder
                                                  touchCountParameterHolder =
                                                  TouchCountParameterHolder(
                                                      typeId: categoryProvider
                                                          .categoryList
                                                          .data[index]
                                                          .id,
                                                      typeName: PsConst
                                                          .FILTERING_TYPE_NAME_CATEGORY,
                                                      userId: categoryProvider
                                                          .psValueHolder
                                                          .loginUserId,
                                                      shopId: categoryProvider
                                                          .categoryList
                                                          .data[index]
                                                          .shopId);

                                              categoryProvider.postTouchCount(
                                                  touchCountParameterHolder
                                                      .toMap());
                                            });
                                            print(categoryProvider
                                                .categoryList
                                                .data[index]
                                                .defaultPhoto
                                                .imgPath);
                                            final ProductParameterHolder
                                                productParameterHolder =
                                                ProductParameterHolder()
                                                    .getLatestParameterHolder();
                                            productParameterHolder.catId =
                                                categoryProvider.categoryList
                                                    .data[index].id;
                                            Navigator.pushNamed(context,
                                                RoutePaths.filterProductList,
                                                arguments:
                                                    ProductListIntentHolder(
                                                  appBarTitle: categoryProvider
                                                      .categoryList
                                                      .data[index]
                                                      .name,
                                                  productParameterHolder:
                                                      productParameterHolder,
                                                ));
                                          },
                                          // )
                                        );
                                      }
                                    }),
                              )
                            ])
                          : Container()));
            });
      },
    ));
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.productCollectionHeader,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function viewAllClicked;
  final ProductCollectionHeader productCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.title.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
