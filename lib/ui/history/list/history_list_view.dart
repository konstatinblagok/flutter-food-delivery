import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/history/history_provider.dart';
import 'package:fluttermultistoreflutter/repository/history_repsitory.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/history/item/history_list_item.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView>
    with SingleTickerProviderStateMixin {
  HistoryRepository historyRepo;
  dynamic data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
    data = EasyLocalizationProvider.of(context).data;
    historyRepo = Provider.of<HistoryRepository>(context);
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<HistoryProvider>(
            create: (BuildContext context) {
          final HistoryProvider provider = HistoryProvider(
            repo: historyRepo,
          );
          provider.loadHistoryList();
          return provider;
        }, child: Consumer<HistoryProvider>(
          builder:
              (BuildContext context, HistoryProvider provider, Widget child) {
            if (provider.historyList != null &&
                provider.historyList.data != null) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  // Visibility(
                  //   visible: PsConst.SHOW_ADMOB &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.FULL_BANNER,
                  //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
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
                      margin: const EdgeInsets.only(bottom: PsDimens.space10),
                      child: CustomScrollView(slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final int count =
                                  provider.historyList.data.length;
                              return HistoryListItem(
                                animationController: widget.animationController,
                                animation:
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                    parent: widget.animationController,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn),
                                  ),
                                ),
                                history: provider.historyList.data.reversed
                                    .toList()[index],
                                onTap: () {
                                  final Product product = provider
                                      .historyList.data.reversed
                                      .toList()[index];
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    product: product,
                                    heroTagImage: provider.hashCode.toString() +
                                        product.id +
                                        PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle: provider.hashCode.toString() +
                                        product.id +
                                        PsConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        provider.hashCode.toString() +
                                            product.id +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        provider.hashCode.toString() +
                                            product.id +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                  );

                                  Navigator.pushNamed(
                                      context, RoutePaths.productDetail,
                                      arguments: holder);
                                },
                              );
                            },
                            childCount: provider.historyList.data.length,
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        )));
  }
}
