import 'dart:async';
import 'package:fluttermultistoreflutter/repository/shipping_city_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/api_status.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shipping_city_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';

class ShippingCityProvider extends PsProvider {
  ShippingCityProvider(
      {@required ShippingCityRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    //isDispose = false;
    print('City Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shippingCityListStream =
        StreamController<PsResource<List<ShippingCity>>>.broadcast();
    subscription = shippingCityListStream.stream
        .listen((PsResource<List<ShippingCity>> resource) {
      updateOffset(resource.data.length);

      _shippingCityList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ShippingCity>>> shippingCityListStream;
  ShippingCityRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ShippingCity>> _shippingCityList =
      PsResource<List<ShippingCity>>(PsStatus.NOACTION, '', <ShippingCity>[]);

  PsResource<List<ShippingCity>> get shippingCityList => _shippingCityList;
  StreamSubscription<PsResource<List<ShippingCity>>> subscription;

  final PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('City Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingCityList(String shopId, String countryId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getAllShippingCityList(
        shippingCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShippingCityList(String shopId, String countryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShippingCityList(
          shippingCityListStream,
          isConnectedToInternet,
          limit,
          offset,
          ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShippingCityList(String shopId, String countryId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingCityList(
        shippingCityListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCityParameterHolder(shopId: shopId, countryId: countryId),
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
