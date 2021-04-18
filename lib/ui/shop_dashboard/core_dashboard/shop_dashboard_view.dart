import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/noti_dialog.dart';
import 'package:fluttermultistoreflutter/ui/contact/contact_us_view.dart';
import 'package:fluttermultistoreflutter/ui/history/list/history_list_view.dart';
import 'package:fluttermultistoreflutter/ui/language/setting/language_setting_view.dart';
import 'package:fluttermultistoreflutter/ui/product/favourite/favourite_product_list_view.dart';
import 'package:fluttermultistoreflutter/ui/setting/setting_view.dart';
import 'package:fluttermultistoreflutter/ui/shop_dashboard/shop_home/shop_home_dashboard_view.dart';
import 'package:fluttermultistoreflutter/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:fluttermultistoreflutter/ui/transaction/list/transaction_list_view.dart';
import 'package:fluttermultistoreflutter/ui/user/forgot_password/forgot_password_view.dart';
import 'package:fluttermultistoreflutter/ui/user/login/login_view.dart';
import 'package:fluttermultistoreflutter/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:fluttermultistoreflutter/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:fluttermultistoreflutter/ui/user/profile/profile_view.dart';
import 'package:fluttermultistoreflutter/ui/user/register/register_view.dart';
import 'package:fluttermultistoreflutter/ui/user/verify/verify_email_view.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ShopDashboardView extends StatefulWidget {
  @override
  _ShopDashboardViewState createState() => _ShopDashboardViewState();
}

class _ShopDashboardViewState extends State<ShopDashboardView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  String appBarTitle = 'Home';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  UserRepository userRepository;
  PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    final dynamic data = EasyLocalizationProvider.of(context).data;

    if (isFirstTime) {
      appBarTitle = Utils.getString(
          context, 'app_name'); //Utils.getString(context, 'dashboard__home');
      isFirstTime = false;
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

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_dialog_description'),
                    leftButtonText: Utils.getString(
                        context, 'app_info__cancel_button_name'),
                    rightButtonText: Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
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
          drawer: Drawer(
            child: MultiProvider(
              providers: <SingleChildCloneableWidget>[
                ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                  return UserProvider(
                      repo: userRepository, psValueHolder: valueHolder);
                }),
              ],
              child: Consumer<UserProvider>(
                builder: (BuildContext context, UserProvider provider,
                    Widget child) {
                  print(provider.psValueHolder.loginUserId);
                  return ListView(padding: EdgeInsets.zero, children: <Widget>[
                    _DrawerHeaderWidget(),
                    ListTile(
                      title: Text(
                          Utils.getString(context, 'home__drawer_menu_home')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.store,
                        title:
                            Utils.getString(context, 'home__drawer_menu_home'),
                        index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(
                              Utils.getString(context, 'app_name'), index);
                        }),
                    // _DrawerMenuWidget(
                    //     icon: Icons.category,
                    //     title: Utils.getString(
                    //         context, 'home__drawer_menu_category'),
                    //     index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    // _DrawerMenuWidget(
                    //     icon: Icons.schedule,
                    //     title: Utils.getString(
                    //         context, 'home__drawer_menu_latest_product'),
                    //     index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    // _DrawerMenuWidget(
                    //     icon: Feather.percent,
                    //     title: Utils.getString(
                    //         context, 'home__drawer_menu_discount_product'),
                    //     index: PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT,
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    // _DrawerMenuWidget(
                    //     icon: FontAwesome5.gem,
                    //     title: Utils.getString(
                    //         context, 'home__menu_drawer_featured_product'),
                    //     index:
                    //         PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT, //17
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    // _DrawerMenuWidget(
                    //     icon: Icons.trending_up,
                    //     title: Utils.getString(
                    //         context, 'home__drawer_menu_trending_product'),
                    //     index: PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    // _DrawerMenuWidget(
                    //     icon: Icons.folder_open,
                    //     title: Utils.getString(
                    //         context, 'home__menu_drawer_collection'),
                    //     index: PsConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT,
                    //     onTap: (String title, int index) {
                    //       Navigator.pop(context);
                    //       updateSelectedIndexWithAnimation(title, index);
                    //     }),
                    const Divider(
                      height: PsDimens.space1,
                    ),
                    ListTile(
                      title: Text(Utils.getString(
                          context, 'home__menu_drawer_user_info')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.person,
                        title: Utils.getString(
                            context, 'home__menu_drawer_profile'),
                        index: PsConst
                            .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          title = (valueHolder == null ||
                                  valueHolder.userIdToVerify == null ||
                                  valueHolder.userIdToVerify == '')
                              ? Utils.getString(
                                  context, 'home__menu_drawer_profile')
                              : Utils.getString(
                                  context, 'home__bottom_app_bar_verify_email');
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                              icon: Icons.favorite_border,
                              title: Utils.getString(
                                  context, 'home__menu_drawer_favourite'),
                              index:
                                  PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                              onTap: (String title, int index) {
                                Navigator.pop(context);
                                updateSelectedIndexWithAnimation(title, index);
                              }),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                            icon: Icons.swap_horiz,
                            title: Utils.getString(
                                context, 'home__menu_drawer_transaction'),
                            index:
                                PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            },
                          ),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: _DrawerMenuWidget(
                              icon: Icons.book,
                              title: Utils.getString(
                                  context, 'home__menu_drawer_user_history'),
                              index: PsConst
                                  .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                              onTap: (String title, int index) {
                                Navigator.pop(context);
                                updateSelectedIndexWithAnimation(title, index);
                              }),
                        ),
                    if (provider != null)
                      if (provider.psValueHolder.loginUserId != null &&
                          provider.psValueHolder.loginUserId != '')
                        Visibility(
                          visible: true,
                          child: ListTile(
                            leading: Icon(
                              Icons.power_settings_new,
                              color: PsColors.mainColorWithWhite,
                            ),
                            title: Text(
                              Utils.getString(
                                  context, 'home__menu_drawer_logout'),
                              style: Theme.of(context).textTheme.body1,
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmDialogView(
                                        description: Utils.getString(context,
                                            'home__logout_dialog_description'),
                                        leftButtonText: Utils.getString(context,
                                            'home__logout_dialog_cancel_button'),
                                        rightButtonText: Utils.getString(
                                            context,
                                            'home__logout_dialog_ok_button'),
                                        onAgreeTap: () async {
                                          setState(() {
                                            Navigator.pop(context);
                                            _currentIndex = PsConst
                                                .REQUEST_CODE__MENU_HOME_FRAGMENT;
                                          });
                                          provider.replaceLoginUserId('');
                                          // await deleteTaskProvider.deleteTask();
                                          await FacebookLogin().logOut();
                                          await GoogleSignIn().signOut();
                                          await FirebaseAuth.instance.signOut();

                                          // Navigator.of(context).pop();
                                        });
                                  });
                            },
                          ),
                        ),
                    const Divider(
                      height: PsDimens.space1,
                    ),
                    ListTile(
                      title: Text(
                          Utils.getString(context, 'home__menu_drawer_app')),
                    ),
                    _DrawerMenuWidget(
                        icon: Icons.g_translate,
                        title: Utils.getString(
                            context, 'home__menu_drawer_language'),
                        index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation('', index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.contacts,
                        title: Utils.getString(
                            context, 'home__menu_drawer_contact_us'),
                        index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.settings,
                        title: Utils.getString(
                            context, 'home__menu_drawer_setting'),
                        index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    _DrawerMenuWidget(
                        icon: Icons.info_outline,
                        title: Utils.getString(
                            context, 'home__menu_drawer_terms_and_condition'),
                        index: PsConst
                            .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                        onTap: (String title, int index) {
                          Navigator.pop(context);
                          updateSelectedIndexWithAnimation(title, index);
                        }),
                    ListTile(
                      leading: Icon(
                        Icons.star_border,
                        color: PsColors.mainColorWithWhite,
                      ),
                      title: Text(
                        Utils.getString(
                            context, 'home__menu_drawer_rate_this_app'),
                        style: Theme.of(context).textTheme.body1,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Utils.launchURL();
                      },
                    )
                  ]);
                },
              ),
            ),
          ),
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
            ],
          ),
          body: Builder(
            builder: (BuildContext context) {
              if (_currentIndex ==
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
              } else {
                animationController.forward();
                return ShopHomeDashboardViewWidget(animationController, context,
                    (String payload) {
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

class _CallVerifyPhoneWidget extends StatefulWidget {
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
  __CallVerifyPhoneWidgetState createState() => __CallVerifyPhoneWidgetState();
}

class __CallVerifyPhoneWidgetState extends State<_CallVerifyPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: widget.userName,
          phoneNumber: widget.phoneNumber,
          phoneId: widget.phoneId,
          animationController: widget.animationController,
          onProfileSelected: (String userId) {
            if (widget.currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              widget.updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (widget.currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              widget.updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (widget.currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              widget.updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (widget.currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              widget.updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
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

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.body1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_multi_store_icon.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: PsColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: PsColors.mainColor),
    );
  }
}
