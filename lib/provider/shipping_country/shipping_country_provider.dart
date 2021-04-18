import 'dart:async';
import 'package:fluttermultistoreflutter/repository/shipping_country_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/api_status.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shipping_country_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';

class ShippingCountryProvider extends PsProvider {
  ShippingCountryProvider(
      {@required ShippingCountryRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    //isDispose = false;
    print('ShippingCountry Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    shippingCountryListStream =
        StreamController<PsResource<List<ShippingCountry>>>.broadcast();
    subscription = shippingCountryListStream.stream
        .listen((PsResource<List<ShippingCountry>> resource) {
      updateOffset(resource.data.length);

      _shippingCountryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  StreamController<PsResource<List<ShippingCountry>>> shippingCountryListStream;
  ShippingCountryRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ShippingCountry>> _shippingCountryList =
      PsResource<List<ShippingCountry>>(
          PsStatus.NOACTION, '', <ShippingCountry>[]);

  PsResource<List<ShippingCountry>> get shippingCountryList =>
      _shippingCountryList;
  StreamSubscription<PsResource<List<ShippingCountry>>> subscription;

  final PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get user => _apiStatus;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('ShippingCountry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShippingCountryList(String shopId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getAllShippingCountryList(
        shippingCountryListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCountryParameterHolder(shopId: shopId),
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShippingCountryList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShippingCountryList(
          shippingCountryListStream,
          isConnectedToInternet,
          limit,
          offset,
          ShippingCountryParameterHolder(shopId: shopId),
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShippingCountryList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllShippingCountryList(
        shippingCountryListStream,
        isConnectedToInternet,
        limit,
        offset,
        ShippingCountryParameterHolder(shopId: shopId),
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
