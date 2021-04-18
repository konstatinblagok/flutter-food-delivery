import 'dart:async';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/repository/shipping_method_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_method.dart';

class ShippingMethodProvider extends PsProvider {
  ShippingMethodProvider(
      {@required ShippingMethodRepository repo,
      this.psValueHolder,
      this.defaultShippingId,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShippingMethod Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    shippingMethodListStream =
        StreamController<PsResource<List<ShippingMethod>>>.broadcast();
    subscription = shippingMethodListStream.stream
        .listen((PsResource<List<ShippingMethod>> resource) {
      updateOffset(resource.data.length);

      _shippingMethodList = resource;

      if (psValueHolder.standardShippingEnable == PsConst.ONE &&
          psValueHolder.zoneShippingEnable == PsConst.ZERO &&
          psValueHolder.noShippingEnable == PsConst.ZERO) {
        for (ShippingMethod shippingMethod in _shippingMethodList.data) {
          if (shippingMethod.id == defaultShippingId) {
            defaultShippingPrice = shippingMethod.price;
            defaultShippingName = shippingMethod.name;
          }
        }
      } else {
        //if not select shipping , set 0
        defaultShippingPrice = '0.00';
        defaultShippingName = '';
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ShippingMethod selectedShippingMethod;
  String selectedPrice = '0.00';
  String selectedShippingName;
  String defaultShippingId;
  String defaultShippingPrice = '0.00';
  String defaultShippingName;

  ShippingMethodRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ShippingMethod>> _shippingMethodList =
      PsResource<List<ShippingMethod>>(
          PsStatus.NOACTION, '', <ShippingMethod>[]);

  PsResource<List<ShippingMethod>> get shippingMethodList =>
      _shippingMethodList;
  StreamSubscription<PsResource<List<ShippingMethod>>> subscription;
  StreamController<PsResource<List<ShippingMethod>>> shippingMethodListStream;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    shippingMethodListStream.close();
    isDispose = true;
    print('ShippingMethod Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingMethodList(String shopId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllShippingMethod(
        shippingMethodListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        shopId);
  }

  Future<void> resetShippingMethodList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingMethod(
        shippingMethodListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        shopId);

    isLoading = false;
  }
}
