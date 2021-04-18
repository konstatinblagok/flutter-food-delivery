import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/category/trending_category_provider.dart';
import 'package:fluttermultistoreflutter/repository/basket_repository.dart';
import 'package:fluttermultistoreflutter/repository/category_repository.dart';
import 'package:fluttermultistoreflutter/ui/category/item/category_vertical_list_item.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/category_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/product_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrendingCategoryListView extends StatefulWidget {
  @override
  _TrendingCategoryListViewState createState() {
    return _TrendingCategoryListViewState();
  }
}

class _TrendingCategoryListViewState extends State<TrendingCategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TrendingCategoryProvider _trendingCategoryProvider;
  PsValueHolder psValueHolder;
  final CategoryParameterHolder trendingCategoryParameterHolder =
      CategoryParameterHolder().getTrendingParameterHolder();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _trendingCategoryProvider.nextTrendingCategoryList(
            _trendingCategoryProvider.trendingCategoryParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository categoryRepository;
  BasketRepository basketRepository;
  BasketProvider basketProvider;
  TrendingCategoryProvider trendingCategoryProvider;
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
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    categoryRepository = Provider.of<CategoryRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    //var data = EasyLocalizationProvider.of(context).data;
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithMultiProvider(
            child: MultiProvider(
                providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<TrendingCategoryProvider>(
                  create: (BuildContext context) {
                trendingCategoryProvider = TrendingCategoryProvider(
                    repo: categoryRepository, psValueHolder: psValueHolder);
                trendingCategoryProvider.trendingCategoryParameterHolder
                    .shopId = trendingCategoryProvider.psValueHolder.shopId;
                trendingCategoryProvider.loadTrendingCategoryList(
                    trendingCategoryProvider.trendingCategoryParameterHolder);
                return trendingCategoryProvider;
              }),
              ChangeNotifierProvider<BasketProvider>(
                  create: (BuildContext context) {
                basketProvider = BasketProvider(
                    repo: basketRepository, psValueHolder: psValueHolder);
                return basketProvider;
              }),
            ],
                child: Consumer<TrendingCategoryProvider>(builder:
                    (BuildContext context, TrendingCategoryProvider provider,
                        Widget child) {
                  ///
                  /// Load Basket List
                  ///
                  basketProvider = Provider.of<BasketProvider>(context,
                      listen: false); // Listen : False is important.

                  basketProvider
                      .loadBasketList(basketProvider.psValueHolder.shopId);
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: PsColors.baseColor,
                      iconTheme: Theme.of(context)
                          .iconTheme
                          .copyWith(color: PsColors.mainColor),
                      title: Text(
                        Utils.getString(
                            context, 'tranding_category__app_bar_name'),
                        style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PsColors.mainColorWithWhite),
                      ),
                      titleSpacing: 0,
                      elevation: 0,
                      textTheme: Theme.of(context).textTheme,
                      brightness: Utils.getBrightnessForAppBar(context),
                      actions: <Widget>[
                        Consumer<BasketProvider>(builder: (BuildContext context,
                            BasketProvider basketProvider, Widget child) {
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
                                          basketProvider
                                                      .basketList.data.length >
                                                  99
                                              ? '99+'
                                              : basketProvider
                                                  .basketList.data.length
                                                  .toString(),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(color: PsColors.white),
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
                        }),
                      ],
                    ),
                    body: Stack(children: <Widget>[
                      Column(
                        children: <Widget>[
                          const PsAdMobBannerWidget(),
                          // Visibility(
                          //   visible: PsConst.SHOW_ADMOB &&
                          //       isSuccessfullyLoaded &&
                          //       isConnectedToInternet,
                          //   child: AdmobBanner(
                          //     adUnitId: Utils.getBannerAdUnitId(),
                          //     adSize: AdmobBannerSize.FULL_BANNER,
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
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: PsDimens.space8,
                                    right: PsDimens.space8,
                                    top: PsDimens.space8,
                                    bottom: PsDimens.space8),
                                child: RefreshIndicator(
                                  child: CustomScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      slivers: <Widget>[
                                        SliverGrid(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio: 0.8),
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              if (provider.categoryList.data !=
                                                      null ||
                                                  provider.categoryList.data
                                                      .isNotEmpty) {
                                                final int count = provider
                                                    .categoryList.data.length;
                                                return CategoryVerticalListItem(
                                                  animationController:
                                                      animationController,
                                                  animation: Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                    CurvedAnimation(
                                                      parent:
                                                          animationController,
                                                      curve: Interval(
                                                          (1 / count) * index,
                                                          1.0,
                                                          curve: Curves
                                                              .fastOutSlowIn),
                                                    ),
                                                  ),
                                                  category: provider
                                                      .categoryList.data[index],
                                                  onTap: () {
                                                    Utils.checkUserLoginId(
                                                            psValueHolder)
                                                        .then((String
                                                            loginUserId) async {
                                                      final TouchCountParameterHolder
                                                          touchCountParameterHolder =
                                                          TouchCountParameterHolder(
                                                              typeId: provider
                                                                  .categoryList
                                                                  .data[index]
                                                                  .id,
                                                              typeName: PsConst
                                                                  .FILTERING_TYPE_NAME_CATEGORY,
                                                              userId: provider
                                                                  .psValueHolder
                                                                  .loginUserId,
                                                              shopId: provider
                                                                  .categoryList
                                                                  .data[index]
                                                                  .shopId);

                                                      provider.postTouchCount(
                                                          touchCountParameterHolder
                                                              .toMap());
                                                    });
                                                    print(provider
                                                        .categoryList
                                                        .data[index]
                                                        .defaultPhoto
                                                        .imgPath);
                                                    final ProductParameterHolder
                                                        productParameterHolder =
                                                        ProductParameterHolder()
                                                            .getTrendingParameterHolder();
                                                    productParameterHolder
                                                            .catId =
                                                        provider.categoryList
                                                            .data[index].id;
                                                    Navigator.pushNamed(
                                                        context,
                                                        RoutePaths
                                                            .filterProductList,
                                                        arguments:
                                                            ProductListIntentHolder(
                                                          appBarTitle: provider
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
                                            },
                                            childCount: provider
                                                .categoryList.data.length,
                                          ),
                                        ),
                                      ]),
                                  onRefresh: () {
                                    return provider.resetTrendingCategoryList(
                                        provider
                                            .trendingCategoryParameterHolder);
                                  },
                                )),
                          ),
                        ],
                      ),
                      PSProgressIndicator(provider.categoryList.status)
                    ]),
                  );
                }))));
  }
}
