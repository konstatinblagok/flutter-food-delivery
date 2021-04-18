import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_list_by_tagid_provider.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/shop_list_by_tagid/shoplist_by_tagid_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_data_intent_holer.dart';
import 'package:provider/provider.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';

class ShopListByTagIdView extends StatefulWidget {
  const ShopListByTagIdView(
      {Key key, @required this.tagId, @required this.appBarTitle})
      : super(key: key);
  final String tagId;
  final String appBarTitle;
  @override
  _ShopListByTagIdViewState createState() => _ShopListByTagIdViewState();
}

class _ShopListByTagIdViewState extends State<ShopListByTagIdView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  ShopListByTagIdProvider _shopListByTagIdProvider;
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _shopListByTagIdProvider.nextShopListById(widget.tagId);
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

  // ShopListByTagIdRepository repo1;
  ShopRepository repo1;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    data = EasyLocalizationProvider.of(context).data;
    // repo1 = Provider.of<ShopListByTagIdRepository>(context);
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
    return PsWidgetWithAppBar<ShopListByTagIdProvider>(
      appBarTitle: Utils.getString(context, widget.appBarTitle) ?? '',
      initProvider: () {
        return ShopListByTagIdProvider(
          repo: repo1,
        );
      },
      onProviderReady: (ShopListByTagIdProvider provider) {
        provider.loadShopListByTagId(widget.tagId);
        _shopListByTagIdProvider = provider;
      },
      builder: (BuildContext context, ShopListByTagIdProvider provider,
          Widget child) {
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
                                if (provider.shopListByTagId != null &&
                                    provider.shopListByTagId.data != null &&
                                    provider.shopListByTagId.data.isNotEmpty) {
                                  final int count =
                                      provider.shopListByTagId.data.length;
                                  return ShopListByTagIdItem(
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
                                    shop: provider.shopListByTagId.data[index],
                                    onTap: () {
                                      provider.replaceShop(
                                          provider
                                              .shopListByTagId.data[index].id,
                                          provider.shopListByTagId.data[index]
                                              .name);
                                      Navigator.pushNamed(
                                          context, RoutePaths.home,
                                          arguments: ShopDataIntentHolder(
                                              shopId: provider.shopListByTagId
                                                  .data[index].id,
                                              shopName: provider.shopListByTagId
                                                  .data[index].name));
                                    },
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.shopListByTagId.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () {
                      return provider.resetShopListById(widget.tagId);
                    },
                  )),
              PSProgressIndicator(provider.shopListByTagId.status)
            ],
          ),
        );
      },
    );
  }
}
