import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/db/shipping_city_dao.dart';
import 'package:fluttermultistoreflutter/repository/Common/ps_repository.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/shipping_city_parameter_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_city.dart';
import 'package:sembast/sembast.dart';

class ShippingCityRepository extends PsRepository {
  ShippingCityRepository(
      {@required PsApiService psApiService,
      @required ShippingCityDao shippingCityDao}) {
    _psApiService = psApiService;
    _shippingCityDao = shippingCityDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShippingCityDao _shippingCityDao;

  Future<dynamic> insert(ShippingCity shippingCity) async {
    return _shippingCityDao.insert(primaryKey, shippingCity);
  }

  Future<dynamic> update(ShippingCity shippingCity) async {
    return _shippingCityDao.update(shippingCity);
  }

  Future<dynamic> delete(ShippingCity shippingCity) async {
    return _shippingCityDao.delete(shippingCity);
  }

  Future<dynamic> getAllShippingCityList(
      StreamController<PsResource<List<ShippingCity>>> shippingCityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCityParameterHolder holder,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder();
    shippingCityListStream.sink
        .add(await _shippingCityDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShippingCity>> _resource =
          await _psApiService.getCityList(limit, offset, holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        if (isNeedDelete) {
          await _shippingCityDao.deleteWithFinder(finder);
        }
        await _shippingCityDao.insertAll(primaryKey, _resource.data);
        shippingCityListStream.sink
            .add(await _shippingCityDao.getAll(finder: finder));
      } else {
        shippingCityListStream.sink
            .add(await _shippingCityDao.getAll(finder: finder));
      }
    }
  }

  Future<dynamic> getNextPageShippingCityList(
      StreamController<PsResource<List<ShippingCity>>> shippingCityListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      ShippingCityParameterHolder holder,
      PsStatus status,
      {bool isNeedDelete = true,
      bool isLoadFromServer = true}) async {
    final Finder finder = Finder();
    shippingCityListStream.sink
        .add(await _shippingCityDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShippingCity>> _resource =
          await _psApiService.getCityList(limit, offset, holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        await _shippingCityDao.insertAll(primaryKey, _resource.data);
      }
      shippingCityListStream.sink.add(await _shippingCityDao.getAll());
    }
  }
}
