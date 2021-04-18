import 'package:admob_flutter/admob_flutter.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/provider/blog/blog_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop/featured_shop_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop/new_shop_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop/popular_shop_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_tag_provider.dart';
import 'package:fluttermultistoreflutter/repository/Common/notification_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_info_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_tag_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultistoreflutter/ui/shop_dashboard/item/popular_shop_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/ui/shop_dashboard/item/shop_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/ui/shop_dashboard/item/blog_slider.dart';
import 'package:fluttermultistoreflutter/ui/shop_dashboard/item/shop_tag_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/blog.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_list_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_tag_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shop_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_data_intent_holer.dart';
import 'package:fluttermultistoreflutter/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/repository/blog_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';

class ShopHomeDashboardViewWidget extends StatefulWidget {
  const ShopHomeDashboardViewWidget(
      this.animationController, this.context, this.onNotiClicked);
  final AnimationController animationController;
  final BuildContext context;
  final Function onNotiClicked;

  @override
  _ShopHomeDashboardViewWidgetState createState() =>
      _ShopHomeDashboardViewWidgetState();
}

class _ShopHomeDashboardViewWidgetState
    extends State<ShopHomeDashboardViewWidget> {
  PsValueHolder valueHolder;
  ShopInfoRepository shopInfoRepository;
  NotificationRepository notificationRepository;
  BlogRepository blogRepository;
  ShopTagRepository shopTagRepository;
  ShopRepository shopRepository;
  NewShopProvider newShopProvider;
  ShopTagProvider shopTagProvider;
  BlogProvider blogProvider;
  PopularShopProvider popularShopProvider;
  FeaturedShopProvider featuredShopProvider;

  final int count = 8;

  @override
  Widget build(BuildContext context) {
    ///repo
    blogRepository = Provider.of<BlogRepository>(context);
    shopRepository = Provider.of<ShopRepository>(context);
    shopTagRepository = Provider.of<ShopTagRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    ///provider

    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider<NewShopProvider>(
              create: (BuildContext context) {
            newShopProvider = NewShopProvider(
                repo: shopRepository, limit: PsConfig.SHOP_LOADING_LIMIT);
            newShopProvider.loadShopList();
            return newShopProvider;
          }),
          ChangeNotifierProvider<ShopTagProvider>(
              create: (BuildContext context) {
            shopTagProvider = ShopTagProvider(
                repo: shopTagRepository,
                limit: PsConfig.SHOP_TAG_LOADING_LIMIT);
            shopTagProvider.loadShopTagList();
            return shopTagProvider;
          }),
          ChangeNotifierProvider<BlogProvider>(create: (BuildContext context) {
            blogProvider = BlogProvider(
                repo: blogRepository, limit: PsConfig.BLOG_LOADING_LIMIT);
            blogProvider.loadBlogList();
            return blogProvider;
          }),
          ChangeNotifierProvider<ShopProvider>(create: (BuildContext context) {
            final ShopProvider provider = ShopProvider(
                repo: shopRepository, limit: PsConfig.SHOP_LOADING_LIMIT);
            return provider;
          }),
          ChangeNotifierProvider<PopularShopProvider>(
              create: (BuildContext context) {
            popularShopProvider = PopularShopProvider(
                repo: shopRepository, limit: PsConfig.SHOP_LOADING_LIMIT);
            popularShopProvider.loadShopList();
            return popularShopProvider;
          }),
          ChangeNotifierProvider<FeaturedShopProvider>(
              create: (BuildContext context) {
            featuredShopProvider = FeaturedShopProvider(
                repo: shopRepository, limit: PsConfig.SHOP_LOADING_LIMIT);
            featuredShopProvider.loadShopList();
            return featuredShopProvider;
          }),
        ],
        child: Container(
          color: PsColors.coreBackgroundColor,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              _HomeShopTagHorizontalListWidget(
                psValueHolder: valueHolder,
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 2, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeBlogSliderListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 3, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeNewShopHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 4, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomeFeaturedShopHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 5, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
              _HomePopularShopHorizontalListWidget(
                animationController:
                    widget.animationController, //animationController,
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * 6, 1.0,
                            curve: Curves.fastOutSlowIn))), //animation
              ),
            ],
          ),
        ));
  }
}

class _HomeFeaturedShopHorizontalListWidget extends StatelessWidget {
  const _HomeFeaturedShopHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<FeaturedShopProvider>(
        builder: (BuildContext context,
            FeaturedShopProvider featuredShopProvider, Widget child) {
          return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: (featuredShopProvider.shopList.data != null &&
                            featuredShopProvider.shopList.data.isNotEmpty)
                        ? Container(
                            color: PsColors.mainColor,
                            child: Column(children: <Widget>[
                              const SizedBox(height: 16),
                              _MyHeaderWidget(
                                headerName: Utils.getString(
                                    context, 'shop_dashboard__featured_shop'),
                                flag: Utils.getString(
                                    context, 'shop_dashboard__featured_shop'),
                                viewAllClicked: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.shopList,
                                      arguments: ShopListIntentHolder(
                                        appBarTitle: Utils.getString(context,
                                            'shop_dashboard__featured_shop'),
                                        shopParameterHolder: ShopParameterHolder()
                                            .getFeaturedShopParameterHolder(),
                                      ));
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: PsDimens.space16,
                                    right: PsDimens.space16,
                                    bottom: PsDimens.space28),
                                child: Container(
                                    height: PsDimens.space320,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: featuredShopProvider
                                            .shopList.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (featuredShopProvider
                                                  .shopList.status ==
                                              PsStatus.BLOCK_LOADING) {
                                            return Shimmer.fromColors(
                                                baseColor: PsColors.grey,
                                                highlightColor: PsColors.white,
                                                child: Row(
                                                    children: const <Widget>[
                                                      PsFrameUIForLoading(),
                                                    ]));
                                          } else {
                                            return ShopHorizontalListItem(
                                              shop: featuredShopProvider
                                                  .shopList.data[index],
                                              onTap: () {
                                                featuredShopProvider
                                                    .replaceShop(
                                                        featuredShopProvider
                                                            .shopList
                                                            .data[index]
                                                            .id,
                                                        featuredShopProvider
                                                            .shopList
                                                            .data[index]
                                                            .name);
                                                Navigator.pushNamed(
                                                    context, RoutePaths.home,
                                                    arguments: ShopDataIntentHolder(
                                                        shopId:
                                                            featuredShopProvider
                                                                .shopList
                                                                .data[index]
                                                                .id,
                                                        shopName:
                                                            featuredShopProvider
                                                                .shopList
                                                                .data[index]
                                                                .name));
                                              },
                                            );
                                          }
                                        })),
                              )
                            ]),
                          )
                        : Container(),
                  ),
                );
              });
        },
      ),
    );
  }
}

class _HomePopularShopHorizontalListWidget extends StatelessWidget {
  const _HomePopularShopHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<PopularShopProvider>(
        builder: (BuildContext context, PopularShopProvider shopProvider,
            Widget child) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: (shopProvider.shopList.data != null &&
                          shopProvider.shopList.data.isNotEmpty)
                      ? Column(children: <Widget>[
                          _MyHeaderWidget(
                            headerName: Utils.getString(
                                context, 'shop_dashboard__popular_shop'),
                            viewAllClicked: () {
                              Navigator.pushNamed(context, RoutePaths.shopList,
                                  arguments: ShopListIntentHolder(
                                    appBarTitle: Utils.getString(context,
                                        'shop_dashboard__popular_shop'),
                                    shopParameterHolder: ShopParameterHolder()
                                        .getPopularShopParameterHolder(),
                                  ));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: PsDimens.space16,
                                right: PsDimens.space16,
                                bottom: PsDimens.space16),
                            child: Container(
                                height: 500,
                                width: MediaQuery.of(context).size.width,
                                child: CustomScrollView(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  slivers: <Widget>[
                                    SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 400,
                                                childAspectRatio: 1.0),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (shopProvider.shopList.status ==
                                                PsStatus.BLOCK_LOADING) {
                                              return Shimmer.fromColors(
                                                  baseColor: PsColors.grey,
                                                  highlightColor:
                                                      PsColors.white,
                                                  child: Row(
                                                      children: const <Widget>[
                                                        PsFrameUIForLoading(),
                                                      ]));
                                            } else {
                                              return PopularShopHorizontalListItem(
                                                shop: shopProvider
                                                    .shopList.data[index],
                                                onTap: () {
                                                  shopProvider.replaceShop(
                                                      shopProvider.shopList
                                                          .data[index].id,
                                                      shopProvider.shopList
                                                          .data[index].name);
                                                  Navigator.pushNamed(
                                                      context, RoutePaths.home,
                                                      arguments:
                                                          ShopDataIntentHolder(
                                                              shopId:
                                                                  shopProvider
                                                                      .shopList
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                              shopName:
                                                                  shopProvider
                                                                      .shopList
                                                                      .data[
                                                                          index]
                                                                      .name));
                                                },
                                              );
                                            }
                                          },
                                          childCount:
                                              shopProvider.shopList.data.length,
                                        ))
                                  ],
                                )),
                          )
                        ])
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

class _HomeShopTagHorizontalListWidget extends StatefulWidget {
  const _HomeShopTagHorizontalListWidget(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeShopTagHorizontalListWidgetState createState() =>
      __HomeShopTagHorizontalListWidgetState();
}

class __HomeShopTagHorizontalListWidgetState
    extends State<_HomeShopTagHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<ShopTagProvider>(
      builder: (BuildContext context, ShopTagProvider shopTagProvider,
          Widget child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: (shopTagProvider.shopTagList != null &&
                              shopTagProvider.shopTagList.data.isNotEmpty)
                          ? Column(children: <Widget>[
                              _MyHeaderWidget(
                                headerName: Utils.getString(
                                    context, 'shop_dashboard__shop_category'),
                                viewAllClicked: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.shopTagList,
                                      arguments: shopTagProvider);
                                },
                              ),
                              Container(
                                height: PsDimens.space120,
                                margin:
                                    const EdgeInsets.only(top: PsDimens.space4),
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space16),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        shopTagProvider.shopTagList.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (shopTagProvider.shopTagList.status ==
                                          PsStatus.BLOCK_LOADING) {
                                        return Shimmer.fromColors(
                                            baseColor: PsColors.grey,
                                            highlightColor: PsColors.white,
                                            child: Row(children: const <Widget>[
                                              PsFrameUIForLoading(),
                                            ]));
                                      } else {
                                        return ShopTagHorizontalListItem(
                                          shopTag: shopTagProvider
                                              .shopTagList.data[index],
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                RoutePaths.shopListByTagId,
                                                arguments: ShopTagIntentHolder(
                                                  appBarTitle: shopTagProvider
                                                      .shopTagList
                                                      .data[index]
                                                      .name,
                                                  tagId: shopTagProvider
                                                      .shopTagList
                                                      .data[index]
                                                      .id,
                                                ));
                                          },
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

class _HomeBlogSliderListWidget extends StatelessWidget {
  const _HomeBlogSliderListWidget({
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
      child: Consumer<BlogProvider>(builder:
          (BuildContext context, BlogProvider blogProvider, Widget child) {
        if (blogProvider.blogList != null &&
            blogProvider.blogList.data != null &&
            blogProvider.blogList.data.isNotEmpty) {
          return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1.0 - animation.value), 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'shop_dashboard__blog'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutePaths.blogList,
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: PsColors.mainLightShadowColor,
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: PsDimens.space8)
                                ],
                              ),
                              margin: const EdgeInsets.only(
                                  top: PsDimens.space8,
                                  bottom: PsDimens.space20),
                              width: double.infinity,
                              child: (blogProvider.blogList.data != null)
                                  ? BlogSliderView(
                                      blogList: blogProvider.blogList.data,
                                      onTap: (Blog blog) {
                                        Navigator.pushNamed(
                                            context, RoutePaths.blogDetail,
                                            arguments: blog);
                                      },
                                    )
                                  : Container(),
                            )
                          ],
                        )));
              });
        } else {
          return Container();
        }
      }),
    );
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key key,
    @required this.headerName,
    this.flag,
    this.productCollectionHeader,
    @required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String flag;
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
            if (widget.flag ==
                Utils.getString(context, 'shop_dashboard__featured_shop'))
              Container(
                width: PsDimens.space8,
                height: PsDimens.space20,
                decoration: BoxDecoration(color: PsColors.white),
              )
            else
              Container(
                width: PsDimens.space8,
                height: PsDimens.space20,
                decoration: BoxDecoration(color: PsColors.mainColor),
              ),
            const SizedBox(
              width: PsDimens.space12,
            ),
            if (widget.flag ==
                Utils.getString(context, 'shop_dashboard__featured_shop'))
              Expanded(
                child: Text(widget.headerName,
                    style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold, color: PsColors.white)),
              )
            else
              Expanded(
                child: Text(widget.headerName,
                    style: Theme.of(context).textTheme.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: PsColors.textPrimaryDarkColor)),
              ),
            if (widget.flag ==
                Utils.getString(context, 'shop_dashboard__featured_shop'))
              Text(
                Utils.getString(context, 'dashboard__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: PsColors.white),
              )
            else
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

class _HomeNewShopHorizontalListWidget extends StatefulWidget {
  const _HomeNewShopHorizontalListWidget({
    Key key,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  __HomeNewShopHorizontalListWidgetState createState() =>
      __HomeNewShopHorizontalListWidgetState();
}

class __HomeNewShopHorizontalListWidgetState
    extends State<_HomeNewShopHorizontalListWidget> {
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
      child: Consumer<NewShopProvider>(
        builder: (BuildContext context, NewShopProvider newShopProvider,
            Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: (newShopProvider.shopList.data != null &&
                            newShopProvider.shopList.data.isNotEmpty)
                        ? Column(children: <Widget>[
                            _MyHeaderWidget(
                              headerName: Utils.getString(
                                  context, 'shop_dashboard__new_shop'),
                              viewAllClicked: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.shopList,
                                    arguments: ShopListIntentHolder(
                                      appBarTitle: Utils.getString(
                                          context, 'shop_dashboard__new_shop'),
                                      shopParameterHolder: ShopParameterHolder()
                                          .getNewShopParameterHolder(),
                                    ));
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space16,
                                  right: PsDimens.space16,
                                  bottom: PsDimens.space16),
                              child: Container(
                                  height: PsDimens.space320,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(
                                      left: PsDimens.space16),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          newShopProvider.shopList.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (newShopProvider.shopList.status ==
                                            PsStatus.BLOCK_LOADING) {
                                          return Shimmer.fromColors(
                                              baseColor: PsColors.grey,
                                              highlightColor: PsColors.white,
                                              child:
                                                  Row(children: const <Widget>[
                                                PsFrameUIForLoading(),
                                              ]));
                                        } else {
                                          return ShopHorizontalListItem(
                                            shop: newShopProvider
                                                .shopList.data[index],
                                            onTap: () {
                                              newShopProvider.replaceShop(
                                                  newShopProvider
                                                      .shopList.data[index].id,
                                                  newShopProvider.shopList
                                                      .data[index].name);
                                              Navigator.pushNamed(
                                                  context, RoutePaths.home,
                                                  arguments:
                                                      ShopDataIntentHolder(
                                                          shopId:
                                                              newShopProvider
                                                                  .shopList
                                                                  .data[index]
                                                                  .id,
                                                          shopName:
                                                              newShopProvider
                                                                  .shopList
                                                                  .data[index]
                                                                  .name));
                                            },
                                          );
                                        }
                                      })),
                            ),
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
                        : Container(),
                  ),
                );
              });
        },
      ),
    );
  }
}
