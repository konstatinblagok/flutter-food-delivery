import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/db/shipping_country_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shipping_country_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class ShippingCountryRepository extends PsRepository {
  ShippingCountryRepository(
      {@required PsApiService psApiService,
      @required ShippingCountryDao shippingCountryDao}) {
    _psApiService = psApiService;
    _shippingCountryDao = shippingCountryDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShippingCountryDao _shippingCountryDao;

  Future<dynamic> insert(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.insert(primaryKey, shippingCountry);
  }

  Future<dynamic> update(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.update(shippingCountry);
  }

  Future<dynamic> delete(ShippingCountry shippingCountry) async {
    return _shippingCountryDao.delete(shippingCountry);
  }

  Future<dynamic> getAllShippingCountryList(
      StreamController<PsResource<List<ShippingCountry>>>
          shippingCountryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCountryParameterHolder holder,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder();
    shippingCountryListStream.sink
        .add(await _shippingCountryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShippingCountry>> _resource =
          await _psApiService.getCountryList(limit, offset, holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _shippingCountryDao.deleteWithFinder(finder);
        }
        await _shippingCountryDao.insertAll(primaryKey, _resource.data);
        shippingCountryListStream.sink
            .add(await _shippingCountryDao.getAll(finder: finder));
      } else {
        shippingCountryListStream.sink
            .add(await _shippingCountryDao.getAll(finder: finder));
      }
    }
  }

  Future<dynamic> getNextPageShippingCountryList(
      StreamController<PsResource<List<ShippingCountry>>>
          shippingCountryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCountryParameterHolder holder,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder();
    shippingCountryListStream.sink
        .add(await _shippingCountryDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShippingCountry>> _resource =
          await _psApiService.getCountryList(limit, offset, holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        await _shippingCountryDao.insertAll(primaryKey, _resource.data);
      }
      shippingCountryListStream.sink.add(await _shippingCountryDao.getAll());
    }
  }
}
