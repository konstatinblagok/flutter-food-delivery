import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ShopMenuView extends StatefulWidget {
  const ShopMenuView({Key key, this.animationController, this.animation})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ShopMenuViewState createState() => _ShopMenuViewState();
}

class _ShopMenuViewState extends State<ShopMenuView> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SliverToBoxAdapter(
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 30 * (1.0 - widget.animation.value), 0.0),
                        child:
                            provider.user != null && provider.user.data != null
                                ? _ShopMenuViewWidget(
                                    widget: widget, provider: provider)
                                : _ShopMenuViewNoLoginWidget(
                                    widget: widget, provider: provider)));
              });
        },
      ),
    );
  }
}

class _ShopMenuViewWidget extends StatelessWidget {
  const _ShopMenuViewWidget(
      {Key key, @required this.widget, @required this.provider})
      : super(key: key);

  final ShopMenuView widget;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (provider != null ||
            provider.psValueHolder != null ||
            provider.psValueHolder.loginUserId != null ||
            provider.psValueHolder.loginUserId != '')
          _ImageAndTextWidget(userProvider: provider),
        Card(
          child: Column(
            children: <Widget>[
              _DrawerMenuWidget(
                  icon: Icons.category,
                  title: Utils.getString(context, 'home__drawer_menu_category'),
                  index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.schedule,
                  title: Utils.getString(
                      context, 'home__drawer_menu_latest_product'),
                  index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Feather.percent,
                  title: Utils.getString(
                      context, 'home__drawer_menu_discount_product'),
                  index: PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: FontAwesome5.gem,
                  title: Utils.getString(
                      context, 'home__menu_drawer_featured_product'),
                  index:
                      PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT, //17
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.trending_up,
                  title: Utils.getString(
                      context, 'home__drawer_menu_trending_product'),
                  index: PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              
            ],
          ),
        )
      ],
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: PsNetworkCircleImage(
        photoKey: '',
        imagePath: userProvider.user.data.userProfilePhoto,
        width: PsDimens.space80,
        height: PsDimens.space80,
        boxfit: BoxFit.cover,
        onTap: () {},
      ),
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Card(
      child: Container(
        width: double.infinity,
        height: PsDimens.space120,
        child: Row(
          children: <Widget>[
            _imageWidget,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: PsDimens.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      userProvider.user.data.userName,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.title,
                    ),
                    _spacingWidget,
                    Text(
                      userProvider.user.data.userPhone != ''
                          ? userProvider.user.data.userPhone
                          : Utils.getString(context, 'profile__phone_no'),
                      style: Theme.of(context).textTheme.body1,
                    ),
                    _spacingWidget,
                    Text(
                      userProvider.user.data.userAboutMe != ''
                          ? userProvider.user.data.userAboutMe
                          : Utils.getString(context, 'profile__about_me'),
                      style: Theme.of(context).textTheme.body1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopMenuViewNoLoginWidget extends StatelessWidget {
  const _ShopMenuViewNoLoginWidget(
      {Key key, @required this.widget, @required this.provider})
      : super(key: key);

  final ShopMenuView widget;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ImageAndTextNoLoginWidget(userProvider: provider),
        Card(
          child: Column(
            children: <Widget>[
              _DrawerMenuWidget(
                  icon: Icons.category,
                  title: Utils.getString(context, 'home__drawer_menu_category'),
                  index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.schedule,
                  title: Utils.getString(
                      context, 'home__drawer_menu_latest_product'),
                  index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Feather.percent,
                  title: Utils.getString(
                      context, 'home__drawer_menu_discount_product'),
                  index: PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: FontAwesome5.gem,
                  title: Utils.getString(
                      context, 'home__menu_drawer_featured_product'),
                  index:
                      PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT, //17
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              _DrawerMenuWidget(
                  icon: Icons.trending_up,
                  title: Utils.getString(
                      context, 'home__drawer_menu_trending_product'),
                  index: PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                  onTap: (String title, int index) {
                    callView(title, index, context);
                  }),
              
            ],
          ),
        )
      ],
    );
  }
}

class _ImageAndTextNoLoginWidget extends StatelessWidget {
  const _ImageAndTextNoLoginWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10000.0),
          child: Image.asset('assets/images/placeholder_image.png',
              width: PsDimens.space80,
              height: PsDimens.space80,
              fit: BoxFit.cover)),
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Card(
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            _imageWidget,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: PsDimens.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'NoLoginUser',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.title,
                    ),
                    _spacingWidget,
                    // MaterialButton(
                    //   color: PsColors.mainColor,
                    //   shape: const BeveledRectangleBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    //   ),
                    //   child: Text(
                    //     Utils.getString(context, 'login__sign_in'),
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .button
                    //         .copyWith(color: PsColors.white),
                    //   ),
                    //   onPressed: () async {
                    //     if (await Utils.checkInternetConnectivity()) {
                    //       final dynamic returnData =
                    //           await Utils.navigateOnUserVerificationView(
                    //               userProvider, context, () async {});
                    //       if (returnData != null && returnData) {
                    //         //for after register and verify
                    //         await userProvider.getUserFromDB(
                    //             userProvider.psValueHolder.loginUserId);
                    //       }
                    //     } else {
                    //       await showDialog<dynamic>(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return ErrorDialog(
                    //               message: Utils.getString(
                    //                   context, 'error_dialog__no_internet'),
                    //             );
                    //           });
                    //     }
                    //     await userProvider.getUserFromDB(
                    //         userProvider.psValueHolder.loginUserId);
                    //   },
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

dynamic callView(String title, int index, BuildContext context) {
  if (index == PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
    Navigator.pushNamed(context, RoutePaths.categoryList,
        arguments: 'Categories');
  } else if (index == PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
    Navigator.pushNamed(context, RoutePaths.filterProductList,
        arguments: ProductListIntentHolder(
          appBarTitle: Utils.getString(context, 'dashboard__latest_product'),
          productParameterHolder:
              ProductParameterHolder().getLatestParameterHolder(),
        ));
  } else if (index == PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
    Navigator.pushNamed(context, RoutePaths.filterProductList,
        arguments: ProductListIntentHolder(
            appBarTitle:
                Utils.getString(context, 'dashboard__discount_product'),
            productParameterHolder:
                ProductParameterHolder().getDiscountParameterHolder()));
  } else if (index == PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
    Navigator.pushNamed(context, RoutePaths.filterProductList,
        arguments: ProductListIntentHolder(
            appBarTitle: Utils.getString(context, 'dashboard__feature_product'),
            productParameterHolder:
                ProductParameterHolder().getFeaturedParameterHolder()));
  } else if (index == PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
    Navigator.pushNamed(context, RoutePaths.filterProductList,
        arguments: ProductListIntentHolder(
            appBarTitle:
                Utils.getString(context, 'dashboard__trending_product'),
            productParameterHolder:
                ProductParameterHolder().getTrendingParameterHolder()));
  } else if (index == PsConst.REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
    Navigator.pushNamed(
      context,
      RoutePaths.collectionProductList,
    );
  } else {
    //default
    Navigator.pushNamed(context, RoutePaths.filterProductList,
        arguments: ProductListIntentHolder(
          appBarTitle: Utils.getString(context, 'dashboard__latest_product'),
          productParameterHolder:
              ProductParameterHolder().getLatestParameterHolder(),
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
