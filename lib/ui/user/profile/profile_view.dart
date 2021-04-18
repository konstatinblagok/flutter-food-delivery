import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/transaction/transaction_header_provider.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/repository/transaction_header_repository.dart';
import 'package:fluttermultistoreflutter/repository/user_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/transaction/item/transaction_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key key,
    this.animationController,
    @required this.flag,
    this.userId,
    @required this.scaffoldKey,
  }) : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int flag;
  final String userId;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SingleChildScrollView(
        child: Container(
      color: PsColors.coreBackgroundColor,
      height: widget.flag ==
              PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT
          ? MediaQuery.of(context).size.height - 100
          : MediaQuery.of(context).size.height - 40,
      child: CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
        _ProfileDetailWidget(
          animationController: widget.animationController,
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve:
                  const Interval((1 / 4) * 2, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          userId: widget.userId,
        ),
        _TransactionListViewWidget(
          scaffoldKey: widget.scaffoldKey,
          animationController: widget.animationController,
          userId: widget.userId,
        )
      ]),
    ));
  }
}

class _TransactionListViewWidget extends StatelessWidget {
  const _TransactionListViewWidget(
      {Key key,
      @required this.animationController,
      @required this.userId,
      @required this.scaffoldKey})
      : super(key: key);

  final AnimationController animationController;
  final String userId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    TransactionHeaderRepository transactionHeaderRepository;
    PsValueHolder psValueHolder;
    transactionHeaderRepository =
        Provider.of<TransactionHeaderRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<TransactionHeaderProvider>(
            create: (BuildContext context) {
      final TransactionHeaderProvider provider = TransactionHeaderProvider(
          repo: transactionHeaderRepository, psValueHolder: psValueHolder);
      if (provider.psValueHolder.loginUserId == null ||
          provider.psValueHolder.loginUserId == '') {
        provider.loadTransactionList(userId);
      } else {
        provider.loadTransactionList(provider.psValueHolder.loginUserId);
      }

      return provider;
    }, child: Consumer<TransactionHeaderProvider>(builder:
                (BuildContext context, TransactionHeaderProvider provider,
                    Widget child) {
      if (provider.transactionList != null &&
          provider.transactionList.data != null) {
        return Padding(
          padding: const EdgeInsets.only(bottom: PsDimens.space44),
          child: Stack(children: <Widget>[
            Container(
                child: RefreshIndicator(
              child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (provider.transactionList.data != null ||
                              provider.transactionList.data.isNotEmpty) {
                            final int count =
                                provider.transactionList.data.length;
                            return TransactionListItem(
                              scaffoldKey: scaffoldKey,
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              transaction: provider.transactionList.data[index],
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.transactionDetail,
                                    arguments:
                                        provider.transactionList.data[index]);
                              },
                            );
                          } else {
                            return null;
                          }
                        },
                        childCount: provider.transactionList.data.length,
                      ),
                    ),
                  ]),
              onRefresh: () {
                return provider.resetTransactionList();
              },
            )),
          ]),
        );
      } else {
        return Container();
      }
    })));
  }
}

class _ProfileDetailWidget extends StatefulWidget {
  const _ProfileDetailWidget({
    Key key,
    this.animationController,
    this.animation,
    @required this.userId,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  __ProfileDetailWidgetState createState() => __ProfileDetailWidgetState();
}

class __ProfileDetailWidgetState extends State<_ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: 1,
    );
    UserRepository userRepository;
    PsValueHolder psValueHolder;
    UserProvider provider;
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    provider = UserProvider(repo: userRepository, psValueHolder: psValueHolder);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(create:
          (BuildContext context) {
        if (provider.psValueHolder.loginUserId == null ||
            provider.psValueHolder.loginUserId == '') {
          provider.getUser(widget.userId);
        } else {
          provider.getUser(provider.psValueHolder.loginUserId);
        }
        return provider;
      }, child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        if (provider.user != null && provider.user.data != null) {
          return AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 100 * (1.0 - widget.animation.value), 0.0),
                        child: Container(
                          color: PsColors.backgroundColor,
                          child: Column(
                            children: <Widget>[
                              _ImageAndTextWidget(userProvider: provider),
                              _dividerWidget,
                              _EditAndHistoryRowWidget(
                                  userLoginProvider: provider),
                              _dividerWidget,
                              _FavAndSettingWidget(),
                              _dividerWidget,
                              _JoinDateWidget(userProvider: provider),
                              _dividerWidget,
                              _OrderAndSeeAllWidget(),
                            ],
                          ),
                        )));
              });
        } else {
          return Container();
        }
      })),
    );
  }
}

class _JoinDateWidget extends StatelessWidget {
  const _JoinDateWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'profile__join_on'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.body1,
                ),
                const SizedBox(
                  width: PsDimens.space2,
                ),
                Text(userProvider.user.data.addedDate,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.body1),
              ],
            )));
  }
}

class _FavAndSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Widget _sizedBoxWidget = SizedBox(
      width: PsDimens.space4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.favouriteProductList,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__favourite'),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
        Container(
          color: Theme.of(context).dividerColor,
          width: PsDimens.space1,
          height: PsDimens.space48,
        ),
        Expanded(
            flex: 2,
            child: MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutePaths.setting,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.settings,
                      color: Theme.of(context).iconTheme.color),
                  _sizedBoxWidget,
                  Text(
                    Utils.getString(context, 'profile__setting'),
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class _EditAndHistoryRowWidget extends StatelessWidget {
  const _EditAndHistoryRowWidget({@required this.userLoginProvider});
  final UserProvider userLoginProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space48,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _EditAndHistoryTextWidget(
          userLoginProvider: userLoginProvider,
          checkText: 0,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userLoginProvider: userLoginProvider,
          checkText: 1,
        ),
        _verticalLineWidget,
        _EditAndHistoryTextWidget(
          userLoginProvider: userLoginProvider,
          checkText: 2,
        )
      ],
    );
  }
}

class _EditAndHistoryTextWidget extends StatelessWidget {
  const _EditAndHistoryTextWidget({
    Key key,
    @required this.userLoginProvider,
    @required this.checkText,
  }) : super(key: key);

  final UserProvider userLoginProvider;
  final int checkText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: MaterialButton(
            height: 50,
            minWidth: double.infinity,
            onPressed: () async {
              if (checkText == 0) {
                final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                );
                if (returnData) {
                  userLoginProvider
                      .getUser(userLoginProvider.psValueHolder.loginUserId);
                }
              } else if (checkText == 1) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.historyList,
                );
              } else if (checkText == 2) {
                Navigator.pushNamed(
                  context,
                  RoutePaths.transactionList,
                );
              }
            },
            child: checkText == 0
                ? Text(
                    Utils.getString(context, 'profile__edit'),
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(fontWeight: FontWeight.bold),
                  )
                : checkText == 1
                    ? Text(
                        Utils.getString(context, 'profile__history'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Utils.getString(context, 'profile__transaction'),
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontWeight: FontWeight.bold),
                      )));
  }
}

class _OrderAndSeeAllWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutePaths.transactionList,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(Utils.getString(context, 'profile__order'),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subhead),
            InkWell(
              child: Text(
                Utils.getString(context, 'profile__view_all'),
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: PsColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = Padding(
      padding: const EdgeInsets.only(left: PsDimens.space16),
      child: PsNetworkCircleImage(
        photoKey: '',
        imagePath: userProvider.user.data.userProfilePhoto,
        width: PsDimens.space60,
        height: PsDimens.space60,
        boxfit: BoxFit.cover,
        onTap: () {},
      ),
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );
    return Container(
      width: double.infinity,
      height: PsDimens.space100,
      margin: const EdgeInsets.only(top: PsDimens.space16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _imageWidget,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: PsDimens.space12,
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
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
