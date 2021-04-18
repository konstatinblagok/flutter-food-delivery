import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_provider.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/shop_list/shop_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_data_intent_holer.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shop_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';

class ShopListView extends StatefulWidget {
  const ShopListView(
      {Key key, @required this.appBarTitle, @required this.shopParameterHolder})
      : super(key: key);
  final String appBarTitle;
  final ShopParameterHolder shopParameterHolder;
  @override
  _ShopListViewState createState() => _ShopListViewState();
}

class _ShopListViewState extends State<ShopListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ShopProvider _shopProvider;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _shopProvider.nextShopListByKey(widget.shopParameterHolder);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  // ShopListRepository repo1;
  ShopRepository repo1;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    // repo1 = Provider.of<ShopListRepository>(context);
    repo1 = Provider.of<ShopRepository>(context);

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

    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<ShopProvider>(
      appBarTitle: Utils.getString(context, widget.appBarTitle) ?? '',
      initProvider: () {
        return ShopProvider(
          repo: repo1,
        );
      },
      onProviderReady: (ShopProvider provider) {
        provider.loadShopListByKey(widget.shopParameterHolder);
        _shopProvider = provider;
      },
      builder: (BuildContext context, ShopProvider provider, Widget child) {
        if (provider.shop != null &&
            provider.shop.data != null &&
            provider.shop.data.isNotEmpty) {
          return WillPopScope(
            onWillPop: _requestPop,
            child: Stack(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        top: PsDimens.space8,
                        bottom: PsDimens.space8),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final int count = provider.shop.data.length;
                                  return ShopListItem(
                                    animationController: animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    shop: provider.shop.data[index],
                                    onTap: () {
                                      provider.replaceShop(
                                          provider.shop.data[index].id,
                                          provider.shop.data[index].name);
                                      Navigator.pushNamed(
                                          context, RoutePaths.home,
                                          arguments: ShopDataIntentHolder(
                                              shopId:
                                                  provider.shop.data[index].id,
                                              shopName: provider
                                                  .shop.data[index].name));
                                    },
                                  );
                                },
                                childCount: provider.shop.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider
                            .resetShopList(widget.shopParameterHolder);
                      },
                    )),
                PSProgressIndicator(provider.shop.status)
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
