import 'dart:async';
import 'package:fluttermultistoreflutter/db/shipping_method_dao.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_method.dart';

import 'Common/ps_repository.dart';

class ShippingMethodRepository extends PsRepository {
  ShippingMethodRepository(
      {@required PsApiService psApiService,
      @required ShippingMethodDao shippingMethodDao}) {
    _psApiService = psApiService;
    _shippingMethodDao = shippingMethodDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShippingMethodDao _shippingMethodDao;

  Future<dynamic> insert(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.insert(primaryKey, shippingMethod);
  }

  Future<dynamic> update(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.update(shippingMethod);
  }

  Future<dynamic> delete(ShippingMethod shippingMethod) async {
    return _shippingMethodDao.delete(shippingMethod);
  }

  Future<dynamic> getAllShippingMethod(
      StreamController<PsResource<List<ShippingMethod>>> shippingMethodStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      String shopId,
      {bool isLoadFromServer = true}) async {
    shippingMethodStream.sink
        .add(await _shippingMethodDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShippingMethod>> _resource =
          await _psApiService.getShippingMethod(shopId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shippingMethodDao.deleteAll();
        await _shippingMethodDao.insertAll(primaryKey, _resource.data);
        shippingMethodStream.sink.add(await _shippingMethodDao.getAll());
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }
}
