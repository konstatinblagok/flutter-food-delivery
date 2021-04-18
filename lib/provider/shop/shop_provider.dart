import 'dart:async';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shop_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shop.dart';

class ShopProvider extends PsProvider {
  ShopProvider({@required ShopRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ShopProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shopListStream = StreamController<PsResource<List<Shop>>>.broadcast();
    subscription =
        shopListStream.stream.listen((PsResource<List<Shop>> resource) {
      _shop = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ShopRepository _repo;

  PsResource<List<Shop>> _shop =
      PsResource<List<Shop>>(PsStatus.NOACTION, '', null);

  PsResource<List<Shop>> get shop => _shop;
  StreamSubscription<PsResource<List<Shop>>> subscription;
  StreamController<PsResource<List<Shop>>> shopListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Shop Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopListByKey(
      ShopParameterHolder shopParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    await _repo.getShopList(shopListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
  }

  Future<dynamic> nextShopListByKey(
      ShopParameterHolder shopParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageShopList(shopListStream, isConnectedToInternet,
          limit, offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
    }
  }

  Future<void> resetShopList(ShopParameterHolder shopParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    updateOffset(0);

    isLoading = true;
    await _repo.getShopList(shopListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING, shopParameterHolder);
  }
}
