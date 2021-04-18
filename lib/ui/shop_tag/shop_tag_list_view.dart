import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_tag_provider.dart';
import 'package:fluttermultistoreflutter/ui/shop_tag/shop_tag_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_tag_intent_holder.dart';

class ShopTagListView extends StatefulWidget {
  const ShopTagListView({this.shopTagProvider});
  final ShopTagProvider shopTagProvider;
  @override
  _ShopTagListViewState createState() {
    return _ShopTagListViewState();
  }
}

class _ShopTagListViewState extends State<ShopTagListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
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
        widget.shopTagProvider.nextShopTagList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
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
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            brightness: Utils.getBrightnessForAppBar(context),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: PsColors.mainColorWithWhite),
            title: Text(
              Utils.getString(context, 'shop_tag__app_bar_name'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.mainColorWithWhite),
            ),
            elevation: 0,
          ),
          body: Stack(children: <Widget>[
            Container(
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
                              if (widget.shopTagProvider.shopTagList.data !=
                                      null ||
                                  widget.shopTagProvider.shopTagList.data
                                      .isNotEmpty) {
                                final int count = widget
                                    .shopTagProvider.shopTagList.data.length;
                                return ShopTagListItem(
                                  animationController: animationController,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  shopTag: widget
                                      .shopTagProvider.shopTagList.data[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, RoutePaths.shopListByTagId,
                                        arguments: ShopTagIntentHolder(
                                          appBarTitle: widget.shopTagProvider
                                              .shopTagList.data[index].name,
                                          tagId: widget.shopTagProvider
                                              .shopTagList.data[index].id,
                                        ));
                                  },
                                );
                              } else {
                                return null;
                              }
                              // }
                            },
                            childCount:
                                widget.shopTagProvider.shopTagList.data.length,
                          ),
                        ),
                      ]),
                  onRefresh: () {
                    return widget.shopTagProvider.resetShopTagList();
                  },
                )),
            PSProgressIndicator(widget.shopTagProvider.shopTagList.status)
          ]),
        ));
  }
}
