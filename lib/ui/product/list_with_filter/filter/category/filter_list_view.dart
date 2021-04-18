import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/provider/category/category_provider.dart';
import 'package:fluttermultistoreflutter/repository/category_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  CategoryRepository categoryRepository;
  PsValueHolder psValueHolder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String> subCategory) {
    Navigator.pop(context, subCategory);
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
    categoryRepository = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    return PsWidgetWithAppBar<CategoryProvider>(
        appBarTitle: Utils.getString(context, 'search__category') ?? '',
        initProvider: () {
          return CategoryProvider(
              repo: categoryRepository, psValueHolder: psValueHolder);
        },
        onProviderReady: (CategoryProvider provider) {
          provider.latestCategoryParameterHolder.shopId =
              provider.psValueHolder.shopId;
          provider.loadAllCategoryList(provider.latestCategoryParameterHolder);
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                color: PsColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.CATEGORY_ID] = '';
              dataHolder[PsConst.SUB_CATEGORY_ID] = '';
              onSubCategoryClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, CategoryProvider provider, Widget child) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(),
              // Visibility(
              //   visible:
              //       PsConst.SHOW_ADMOB && isSuccessfullyLoaded && isConnectedToInternet,
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
              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: provider.categoryList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.categoryList.data != null ||
                          provider.categoryList.data.isEmpty) {
                        return FilterExpantionTileView(
                            selectedData: widget.selectedData,
                            category: provider.categoryList.data[index],
                            onSubCategoryClick: onSubCategoryClick);
                      } else {
                        return null;
                      }
                    }),
              )
            ],
          );
        });
  }
}
