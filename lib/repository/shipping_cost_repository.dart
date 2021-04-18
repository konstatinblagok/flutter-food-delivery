import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_cost.dart';

import 'Common/ps_repository.dart';

class ShippingCostRepository extends PsRepository {
  ShippingCostRepository({
    @required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = 'id';
  PsApiService _psApiService;

  Future<PsResource<ShippingCost>> postZoneShippingMethod(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ShippingCost> _resource =
        await _psApiService.postZoneShippingMethod(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ShippingCost>> completer =
          Completer<PsResource<ShippingCost>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
