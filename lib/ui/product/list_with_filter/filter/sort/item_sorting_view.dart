import 'package:admob_flutter/admob_flutter.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/product/search_product_provider.dart';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemSortingView extends StatefulWidget {
  const ItemSortingView({@required this.productParameterHolder});

  final ProductParameterHolder productParameterHolder;

  @override
  _ItemSortingViewState createState() => _ItemSortingViewState();
}

class _ItemSortingViewState extends State<ItemSortingView> {
  ProductRepository repo1;
  SearchProductProvider _searchProductProvider;

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
    repo1 = Provider.of<ProductRepository>(context);

    return PsWidgetWithAppBar<SearchProductProvider>(
      appBarTitle: Utils.getString(context, 'search__sort') ?? '',
      initProvider: () {
        return SearchProductProvider(repo: repo1);
      },
      onProviderReady: (SearchProductProvider provider) {
        _searchProductProvider = provider;
        _searchProductProvider.productParameterHolder =
            widget.productParameterHolder;
      },
      builder:
          (BuildContext context, SearchProductProvider provider, Widget child) {
        return Column(
          children: <Widget>[
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baesline_access_time_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__latest'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                              PsConst.FILTERING__ADDED_DATE
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by latest product');
                _searchProductProvider.productParameterHolder.orderBy =
                    PsConst.FILTERING__ADDED_DATE;
                _searchProductProvider.productParameterHolder.orderType =
                    PsConst.FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_graph_black_24.png',
                  titleText: Utils.getString(context, 'item_filter__popular'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                              PsConst.FILTERING__TRENDING
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by popular product');
                _searchProductProvider.productParameterHolder.orderBy =
                    PsConst.FILTERING_TRENDING;
                _searchProductProvider.productParameterHolder.orderType =
                    PsConst.FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_down_black_24.png',
                  titleText:
                      Utils.getString(context, 'item_filter__lowest_price'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                                  PsConst.FILTERING_PRICE &&
                              _searchProductProvider
                                      .productParameterHolder.orderType ==
                                  PsConst.FILTERING__ASC
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by lowest price');
                _searchProductProvider.productParameterHolder.orderBy =
                    PsConst.FILTERING_PRICE;
                _searchProductProvider.productParameterHolder.orderType =
                    PsConst.FILTERING__ASC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            GestureDetector(
              child: SortingView(
                  image: 'assets/images/baseline_price_up_black_24.png',
                  titleText:
                      Utils.getString(context, 'item_filter__highest_price'),
                  checkImage:
                      _searchProductProvider.productParameterHolder.orderBy ==
                                  PsConst.FILTERING_PRICE &&
                              _searchProductProvider
                                      .productParameterHolder.orderType ==
                                  PsConst.FILTERING__DESC
                          ? 'assets/images/baseline_check_green_24.png'
                          : ''),
              onTap: () {
                print('sort by highest price ');
                _searchProductProvider.productParameterHolder.orderBy =
                    PsConst.FILTERING_PRICE;
                _searchProductProvider.productParameterHolder.orderType =
                    PsConst.FILTERING__DESC;

                Navigator.pop(
                    context, _searchProductProvider.productParameterHolder);
              },
            ),
            const Divider(
              height: PsDimens.space1,
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            const PsAdMobBannerWidget(
              admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
            // Visibility(
            //   visible:
            //       PsConst.SHOW_ADMOB && isSuccessfullyLoaded && isConnectedToInternet,
            //   child: AdmobBanner(
            //     adUnitId: Utils.getBannerAdUnitId(),
            //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
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
          ],
        );
      },
    );
  }
}

class SortingView extends StatefulWidget {
  const SortingView(
      {@required this.image,
      @required this.titleText,
      @required this.checkImage});

  final String titleText;
  final String image;
  final String checkImage;

  @override
  State<StatefulWidget> createState() => _SortingViewState();
}

class _SortingViewState extends State<SortingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: PsDimens.space60,
      margin: const EdgeInsets.only(top: PsDimens.space4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(PsDimens.space16),
                child: Image.asset(
                  widget.image,
                  color: Theme.of(context).iconTheme.color,
                  width: PsDimens.space24,
                  height: PsDimens.space24,
                ),
              ),
              const SizedBox(
                width: PsDimens.space10,
              ),
              Text(widget.titleText,
                  style: Theme.of(context).textTheme.subtitle),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: PsDimens.space20, left: PsDimens.space20),
            child: Image.asset(
              widget.checkImage,
              width: PsDimens.space20,
              height: PsDimens.space20,
            ),
          ),
        ],
      ),
    );
  }
}
