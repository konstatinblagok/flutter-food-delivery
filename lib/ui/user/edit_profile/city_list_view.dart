import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/provider/shipping_city/shipping_city_provider.dart';
import 'package:fluttermultistoreflutter/repository/shipping_city_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/user/edit_profile/city_list_item_view.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CityListView extends StatefulWidget {
  const CityListView({@required this.countryId});

  final String countryId;
  @override
  State<StatefulWidget> createState() {
    return _CityListViewState();
  }
}

class _CityListViewState extends State<CityListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ShippingCityProvider shippingCityProvider;
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
        shippingCityProvider.nextShippingCityList(
            psValueHolder.shopId, psValueHolder.shopId);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ShippingCityRepository repo1;
  PsValueHolder psValueHolder;

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

    repo1 = Provider.of<ShippingCityRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<ShippingCityProvider>(
            appBarTitle:
                Utils.getString(context, 'city_list__app_bar_name') ?? '',
            initProvider: () {
              return ShippingCityProvider(
                  repo: repo1, psValueHolder: psValueHolder);
            },
            onProviderReady: (ShippingCityProvider provider) {
              provider.loadShippingCityList(
                  psValueHolder.shopId, widget.countryId);
              shippingCityProvider = provider;
              return shippingCityProvider;
            },
            builder: (BuildContext context, ShippingCityProvider provider,
                Widget child) {
              return Stack(children: <Widget>[
                Container(
                    child: RefreshIndicator(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.shippingCityList.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (provider.shippingCityList.status ==
                            PsStatus.BLOCK_LOADING) {
                          return Shimmer.fromColors(
                              baseColor: PsColors.grey,
                              highlightColor: PsColors.white,
                              child: Column(children: const <Widget>[
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                                PsFrameUIForLoading(),
                              ]));
                        } else {
                          final int count =
                              provider.shippingCityList.data.length;
                          return FadeTransition(
                              opacity: animation,
                              child: CityListItem(
                                animationController: animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                city: provider.shippingCityList.data[index],
                                onTap: () {
                                  Navigator.pop(context,
                                      provider.shippingCityList.data[index]);
                                  print(provider
                                      .shippingCityList.data[index].name);
                                },
                              ));
                        }
                      }),
                  onRefresh: () {
                    return provider.resetShippingCityList(
                        psValueHolder.shopId, psValueHolder.shopId);
                  },
                )),
                PSProgressIndicator(provider.shippingCityList.status)
              ]);
            }));
  }
}
