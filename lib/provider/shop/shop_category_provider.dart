import 'dart:async';
import 'package:fluttermultistoreflutter/repository/shop_category_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_category.dart';

class ShopCategoryProvider extends PsProvider {
  ShopCategoryProvider({@required ShopCategoryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShopCategory Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    shopCategoryListStream =
        StreamController<PsResource<List<ShopCategory>>>.broadcast();
    subscription = shopCategoryListStream.stream
        .listen((PsResource<List<ShopCategory>> resource) {
      updateOffset(resource.data.length);

      _shopCategoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ShopCategoryRepository _repo;

  PsResource<List<ShopCategory>> _shopCategoryList =
      PsResource<List<ShopCategory>>(PsStatus.NOACTION, '', <ShopCategory>[]);

  PsResource<List<ShopCategory>> get shopCategoryList => _shopCategoryList;
  StreamSubscription<PsResource<List<ShopCategory>>> subscription;
  StreamController<PsResource<List<ShopCategory>>> shopCategoryListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    shopCategoryListStream.close();
    isDispose = true;
    print('ShopCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopCategoryList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getShopCategoryList(shopCategoryListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShopCategoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShopCategoryList(shopCategoryListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShopCategoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getShopCategoryList(shopCategoryListStream,
        isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
