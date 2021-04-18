import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/delete_task/delete_task_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/basket_repository.dart';
import 'package:fluttermultistoreflutter/repository/delete_task_repository.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/repository/shop_info_repository.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/basket/list/basket_list_view.dart';
import 'package:fluttermultistoreflutter/ui/category/list/category_list_view.dart';
import 'package:fluttermultistoreflutter/ui/collection/header_list/collection_header_list_view.dart';
import 'package:fluttermultistoreflutter/ui/contact/contact_us_view.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/noti_dialog.dart';
import 'package:fluttermultistoreflutter/ui/history/list/history_list_view.dart';
import 'package:fluttermultistoreflutter/ui/language/setting/language_setting_view.dart';
import 'package:fluttermultistoreflutter/ui/product/favourite/favourite_product_list_view.dart';
import 'package:fluttermultistoreflutter/ui/product/list_with_filter/product_list_with_filter_view.dart';
import 'package:fluttermultistoreflutter/ui/product_dashboard/product_home/product_home_dashboard_view.dart';
import 'package:fluttermultistoreflutter/ui/search/home_item_search_view.dart';
import 'package:fluttermultistoreflutter/ui/shop/shop_info_view.dart';
import 'package:fluttermultistoreflutter/ui/shop/shop_menu_view.dart';
import 'package:fluttermultistoreflutter/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:fluttermultistoreflutter/ui/transaction/list/transaction_list_view.dart';
import 'package:fluttermultistoreflutter/ui/setting/setting_view.dart';
import 'package:fluttermultistoreflutter/ui/user/forgot_password/forgot_password_view.dart';
import 'package:fluttermultistoreflutter/ui/user/login/login_view.dart';
import 'package:fluttermultistoreflutter/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:fluttermultistoreflutter/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:fluttermultistoreflutter/ui/user/profile/profile_view.dart';
import 'package:fluttermultistoreflutter/ui/user/register/register_view.dart';
import 'package:fluttermultistoreflutter/ui/user/verify/verify_email_view.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/product_parameter_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:fluttermultistoreflutter/main.dart' as core;

class ProductDashboardView extends StatefulWidget {
  const ProductDashboardView({
    Key key,
    @required this.shopId,
    @required this.shopName,
  }) : super(key: key);
  final String shopId;
  final String shopName;
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<ProductDashboardView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AnimationController animationController;

  Animation<double> animation;
  BasketRepository basketRepository;

  String appBarTitle = '';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ShopInfoProvider shopInfoProvider;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT:
        index = 1;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT:
        index = 2;
        break;
      // case PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
      //   index = 2;
      //   break;
      // case PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
      //   index = 2;
      //   break;
      case PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
        index = 3;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = widget.shopName; //Utils.getString(context, 'dashboard__home');
        break;
      case 1:
        index = PsConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_shop_info');
        break;
      case 2:
        index = PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_basket_list');
        break;
      // index = PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
      // title = (psValueHolder == null ||
      //         psValueHolder.userIdToVerify == null ||
      //         psValueHolder.userIdToVerify == '')
      //     ? Utils.getString(context, 'home__bottom_app_bar_login')
      //     : Utils.getString(context, 'home__bottom_app_bar_verify_email');
      // break;
      case 3:
        index = PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_search');
        break;
      case 4:
        index = PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_more');
        break;
      default:
        index = 0;
        title = widget.shopName; //Utils.getString(context, 'dashboard__home');
        break;
    }
    return <dynamic>[title, index];
  }

  ShopInfoRepository shopInfoRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;
  BuildContext buildContext;
  @override
  Widget build(BuildContext context) {
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context); // later check
    basketRepository = Provider.of<BasketRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    final dynamic data = EasyLocalizationProvider.of(context).data;

    buildContext = context;

    timeDilation = 1.0;

    if (appBarTitle.isEmpty) {
      appBarTitle = widget.shopName;
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() async {
      bool isOk = false;
      await showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(context, 'home__quit_shop_text'),
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () {
                  Navigator.pop(context);
                  isOk = true;
                });
          });

      return isOk;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: (appBarTitle ==
                        Utils.getString(context, 'home__verify_email') ||
                    appBarTitle ==
                        Utils.getString(context, 'home_verify_phone'))
                ? PsColors.mainColor
                : PsColors.baseColor,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: (appBarTitle ==
                              Utils.getString(context, 'home__verify_email') ||
                          appBarTitle ==
                              Utils.getString(context, 'home_verify_phone'))
                      ? PsColors.white
                      : PsColors.mainColorWithWhite),
            ),
            titleSpacing: 0,
            elevation: 0,
            iconTheme: IconThemeData(
                color: (appBarTitle ==
                            Utils.getString(context, 'home__verify_email') ||
                        appBarTitle ==
                            Utils.getString(context, 'home_verify_phone'))
                    ? PsColors.white
                    : PsColors.mainColorWithWhite),
            textTheme: Theme.of(context).textTheme,
            brightness: Utils.getBrightnessForAppBar(context),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: (appBarTitle ==
                              Utils.getString(context, 'home__verify_email') ||
                          appBarTitle ==
                              Utils.getString(context, 'home_verify_phone'))
                      ? PsColors.white
                      : Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RoutePaths.notiList,
                  );
                },
              ),
              
              ChangeNotifierProvider<BasketProvider>(
                  create: (BuildContext context) {
                final BasketProvider provider =
                    BasketProvider(repo: basketRepository);
                provider.loadBasketList(widget.shopId);
                return provider;
              }, child: Consumer<BasketProvider>(builder: (BuildContext context,
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
                                basketProvider.basketList.data.length > 99
                                    ? '99+'
                                    : basketProvider.basketList.data.length
                                        .toString(),
                                textAlign: TextAlign.left,
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
              })),
            ],
          ),
          bottomNavigationBar: _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex == PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT
              ? Visibility(
                  visible: true,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: getBottonNavigationIndex(_currentIndex),
                    showUnselectedLabels: true,
                    backgroundColor: PsColors.backgroundColor,
                    selectedItemColor: PsColors.mainColor,
                    elevation: 10,
                    onTap: (int index) {
                      final dynamic _returnValue =
                          getIndexFromBottonNavigationIndex(index);

                      updateSelectedIndexWithAnimation(
                          _returnValue[0], _returnValue[1]);
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.store,
                          size: 20,
                        ),
                        title: Text(
                          Utils.getString(context, 'dashboard__home'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.info_outline),
                        title: Text(
                          Utils.getString(
                              context, 'home__bottom_app_bar_shop_info'),
                        ),
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart),
                          title: Text(
                            Utils.getString(
                                context, 'home__bottom_app_bar_basket_list'),
                          )),
                      // BottomNavigationBarItem(
                      //     icon: Icon(Icons.person),
                      //     title: Text(
                      //       Utils.getString(
                      //           context, 'home__bottom_app_bar_login'),
                      //     )),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text(
                          Utils.getString(
                              context, 'home__bottom_app_bar_search'),
                        ),
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.menu),
                          title: Text(
                            Utils.getString(
                                context, 'home__bottom_app_bar_more'),
                          ))
                    ],
                  ),
                )
              : null,
          floatingActionButton: _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex == PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT
              ? Container(
                  height: 65.0,
                  width: 65.0,
                  child: FittedBox(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainColor.withOpacity(0.3),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Container()),
                  ),
                )
              : null,
          body: Builder(
            builder: (BuildContext context) {
              if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT) {
                // 1 Way
                //
                // return MultiProvider(
                //     providers: <SingleChildCloneableWidget>[
                //       ChangeNotifierProvider<ShopInfoProvider>(
                //           builder: (BuildContext context) {
                //         provider = ShopInfoProvider(repo: repo1);
                //         provider.loadShopInfo();
                //         return provider;
                //       }),
                //       ChangeNotifierProvider<UserInfo
                //     ],
                //     child: CustomScrollView(
                //       scrollDirection: Axis.vertical,
                //       slivers: <Widget>[
                //         _SliverAppbar(
                //           title: 'Shop Info',
                //           scaffoldKey: scaffoldKey,
                //         ),
                //         ShopInfoView(
                //             shopInfoProvider: provider,
                //             animationController: animationController,
                //             animation: Tween<double>(begin: 0.0, end: 1.0)
                //                 .animate(CurvedAnimation(
                //                     parent: animationController,
                //                     curve: Interval((1 / 2) * 1, 1.0,
                //                         curve: Curves.fastOutSlowIn))))
                //       ],
                //     ));
                // 2nd Way
                return ChangeNotifierProvider<ShopInfoProvider>(
                    create: (BuildContext context) {
                      final ShopInfoProvider shopInfoProvider =
                          ShopInfoProvider(
                              repo: shopInfoRepository,
                              psValueHolder: valueHolder,
                              ownerCode: 'ProductDashboardView');
                      shopInfoProvider.loadShopInfo(widget.shopId);
                      return shopInfoProvider;
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        CustomScrollView(
                          scrollDirection: Axis.vertical,
                          slivers: <Widget>[
                            ShopInfoView(
                                animationController: animationController,
                                animation: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: animationController,
                                        curve: const Interval((1 / 2) * 1, 1.0,
                                            curve: Curves.fastOutSlowIn))))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: PsDimens.space56,
                              height: PsDimens.space56,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: PsDimens.space8,
                                  vertical: PsDimens.space8),
                              child: valueHolder.phone != ''
                                  ? FloatingActionButton(
                                      heroTag: '',
                                      backgroundColor: PsColors.mainColor,
                                      mini: true,
                                      child: Icon(
                                        Feather.phone_call,
                                        color: PsColors.white,
                                      ),
                                      onPressed: () async {
                                        final String phoneCall =
                                            'tel://${valueHolder.phone}';
                                        // print(index);
                                        if (await canLaunch(phoneCall)) {
                                          await launch(phoneCall,
                                              forceSafariVC: false);
                                        } else {
                                          throw 'show error';
                                        }
                                      },
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ],
                    ));
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_MORE_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                      final UserProvider userProvider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);
                      userProvider.getUserFromDB(
                          userProvider.psValueHolder.loginUserId);
                      return userProvider;
                    },
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ShopMenuView(
                            animationController: animationController,
                            animation: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: const Interval((1 / 2) * 1, 1.0,
                                        curve: Curves.fastOutSlowIn))))
                      ],
                    ));
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                  final UserProvider provider = UserProvider(
                      repo: userRepository, psValueHolder: valueHolder);
                  //provider.getUserLogin();
                  return provider;
                }, child: Consumer<UserProvider>(builder: (BuildContext context,
                        UserProvider provider, Widget child) {
                  if (provider == null ||
                      provider.psValueHolder.userIdToVerify == null ||
                      provider.psValueHolder.userIdToVerify == '') {
                    if (provider == null ||
                        provider.psValueHolder == null ||
                        provider.psValueHolder.loginUserId == null ||
                        provider.psValueHolder.loginUserId == '') {
                      return _CallLoginWidget(
                          currentIndex: _currentIndex,
                          animationController: animationController,
                          animation: animation,
                          updateCurrentIndex: (String title, int index) {
                            if (index != null) {
                              updateSelectedIndexWithAnimation(title, index);
                            }
                          },
                          updateUserCurrentIndex:
                              (String title, int index, String userId) {
                            if (index != null) {
                              updateSelectedIndexWithAnimation(title, index);
                            }
                            if (userId != null) {
                              _userId = userId;
                              provider.psValueHolder.loginUserId = userId;
                            }
                          });
                    } else {
                      return ProfileView(
                        scaffoldKey: scaffoldKey,
                        animationController: animationController,
                        flag: _currentIndex,
                      );
                    }
                  } else {
                    return _CallVerifyEmailWidget(
                        animationController: animationController,
                        animation: animation,
                        currentIndex: _currentIndex,
                        userId: _userId,
                        updateCurrentIndex: (String title, int index) {
                          updateSelectedIndexWithAnimation(title, index);
                        },
                        updateUserCurrentIndex:
                            (String title, int index, String userId) async {
                          if (userId != null) {
                            _userId = userId;
                            provider.psValueHolder.loginUserId = userId;
                          }
                          setState(() {
                            appBarTitle = title;
                            _currentIndex = index;
                          });
                        });
                  }
                }));
              }
              if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
                // 2nd Way
                //SearchProductProvider searchProductProvider;

                return CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    HomeItemSearchView(
                        animationController: animationController,
                        animation: animation,
                        productParameterHolder:
                            ProductParameterHolder().getLatestParameterHolder())
                  ],
                );
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                      Widget>[
                    PhoneSignInView(
                        animationController: animationController,
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        },
                        phoneSignInSelected:
                            (String name, String phoneNo, String verifyId) {
                          phoneUserName = name;
                          phoneNumber = phoneNo;
                          phoneId = verifyId;
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_verify_phone'),
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_verify_phone'),
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                          }
                        })
                  ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                return _CallVerifyPhoneWidget(
                    userName: phoneUserName,
                    phoneNumber: phoneNumber,
                    phoneId: phoneId,
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                return ProfileView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController,
                  flag: _currentIndex,
                  userId: _userId,
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
                return CategoryListView();
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('1'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getLatestParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('2'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getDiscountParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('3'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getTrendingParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('4'),
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getFeaturedParameterHolder(),
                );
              } else if (_currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ForgotPasswordView(
                          animationController: animationController,
                          goToLoginSelected: () {
                            animationController
                                .reverse()
                                .then<dynamic>((void data) {
                              if (!mounted) {
                                return;
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                              }
                            });
                          },
                        )
                      ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                      Widget>[
                    RegisterView(
                        animationController: animationController,
                        onRegisterSelected: (String userId) {
                          _userId = userId;
                          // widget.provider.psValueHolder.loginUserId = userId;
                          if (_currentIndex ==
                              PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home__verify_email'),
                                PsConst
                                    .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home__verify_email'),
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                          }
                        },
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        })
                  ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                return _CallVerifyEmailWidget(
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    userId: _userId,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                        }
                      });
                      if (userId != null) {
                        _userId = userId;
                      }
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                  final UserProvider provider = UserProvider(
                      repo: userRepository, psValueHolder: valueHolder);

                  return provider;
                }, child: Consumer<UserProvider>(builder: (BuildContext context,
                        UserProvider provider, Widget child) {
                  if (provider == null ||
                      provider.psValueHolder.userIdToVerify == null ||
                      provider.psValueHolder.userIdToVerify == '') {
                    if (provider == null ||
                        provider.psValueHolder == null ||
                        provider.psValueHolder.loginUserId == null ||
                        provider.psValueHolder.loginUserId == '') {
                      return Stack(
                        children: <Widget>[
                          Container(
                            color: PsColors.mainLightColor,
                            width: double.infinity,
                            height: double.maxFinite,
                          ),
                          CustomScrollView(
                              scrollDirection: Axis.vertical,
                              slivers: <Widget>[
                                LoginView(
                                  animationController: animationController,
                                  animation: animation,
                                  onGoogleSignInSelected: (String userId) {
                                    setState(() {
                                      _currentIndex = PsConst
                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                    });
                                    _userId = userId;
                                    provider.psValueHolder.loginUserId = userId;
                                  },
                                  onFbSignInSelected: (String userId) {
                                    setState(() {
                                      _currentIndex = PsConst
                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                    });
                                    _userId = userId;
                                    provider.psValueHolder.loginUserId = userId;
                                  },
                                  onPhoneSignInSelected: () {
                                    if (_currentIndex ==
                                        PsConst
                                            .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(
                                              context, 'home_phone_signin'),
                                          PsConst
                                              .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        PsConst
                                            .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(
                                              context, 'home_phone_signin'),
                                          PsConst
                                              .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        PsConst
                                            .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(
                                              context, 'home_phone_signin'),
                                          PsConst
                                              .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        PsConst
                                            .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(
                                              context, 'home_phone_signin'),
                                          PsConst
                                              .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                    }
                                  },
                                  onProfileSelected: (String userId) {
                                    setState(() {
                                      _currentIndex = PsConst
                                          .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      _userId = userId;
                                      provider.psValueHolder.loginUserId =
                                          userId;
                                    });
                                  },
                                  onForgotPasswordSelected: () {
                                    setState(() {
                                      _currentIndex = PsConst
                                          .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                      appBarTitle = Utils.getString(
                                          context, 'home__forgot_password');
                                    });
                                  },
                                  onSignInSelected: () {
                                    updateSelectedIndexWithAnimation(
                                        Utils.getString(
                                            context, 'home__register'),
                                        PsConst
                                            .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                  },
                                ),
                              ])
                        ],
                      );
                    } else {
                      return ProfileView(
                        scaffoldKey: scaffoldKey,
                        animationController: animationController,
                        flag: _currentIndex,
                      );
                    }
                  } else {
                    return _CallVerifyEmailWidget(
                        animationController: animationController,
                        animation: animation,
                        currentIndex: _currentIndex,
                        userId: _userId,
                        updateCurrentIndex: (String title, int index) {
                          updateSelectedIndexWithAnimation(title, index);
                        },
                        updateUserCurrentIndex:
                            (String title, int index, String userId) async {
                          if (userId != null) {
                            _userId = userId;
                            provider.psValueHolder.loginUserId = userId;
                          }
                          setState(() {
                            appBarTitle = title;
                            _currentIndex = index;
                          });
                        });
                  }
                }));
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                return FavouriteProductListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
                return TransactionListView(
                    scaffoldKey: scaffoldKey,
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                return HistoryListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
                return CollectionHeaderListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                return LanguageSettingView(
                    animationController: animationController,
                    languageIsChanged: () {
                      // _currentIndex = PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT;
                      // appBarTitle = Utils.getString(
                      //     context, 'home__menu_drawer_language');

                      //updateSelectedIndexWithAnimation(
                      //  '', PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT);
                      // setState(() {});
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                return ContactUsView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                return Container(
                  color: PsColors.coreBackgroundColor,
                  height: double.infinity,
                  child: SettingView(
                    animationController: animationController,
                  ),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
                return TermsAndConditionsView(
                  animationController: animationController,
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT) {
                return BasketListView(
                  animationController: animationController,
                );
              } else {
                animationController.forward();
                return ProductHomeDashboardViewWidget(
                    _scrollController,
                    animationController,
                    context,
                    widget.shopId, (String payload) {
                  return showDialog<dynamic>(
                    context: context,
                    builder: (_) {
                      return NotiDialog(message: '$payload');
                    },
                  );
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.mainLightColor,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
            // else if (currentIndex ==
            //     PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            // } else if (currentIndex ==
            //     PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            // }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex,
      @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}
