import 'dart:async';
import 'package:fluttermultistoreflutter/db/shop_info_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'Common/ps_repository.dart';

class ShopInfoRepository extends PsRepository {
  ShopInfoRepository(
      {@required PsApiService psApiService,
      @required ShopInfoDao shopInfoDao}) {
    _psApiService = psApiService;
    _shopInfoDao = shopInfoDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShopInfoDao _shopInfoDao;

  Future<dynamic> insert(ShopInfo shopInfo) async {
    return _shopInfoDao.insert(primaryKey, shopInfo);
  }

  Future<dynamic> update(ShopInfo shopInfo) async {
    return _shopInfoDao.update(shopInfo);
  }

  Future<dynamic> delete(ShopInfo shopInfo) async {
    return _shopInfoDao.delete(shopInfo);
  }

  Future<dynamic> getShopInfo(
      String shopId,
      StreamController<PsResource<ShopInfo>> shopInfoListStream,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopInfoListStream.sink.add(await _shopInfoDao.getOne(status: status));

    if (isConnectedToInternet) {
      final PsResource<ShopInfo> _resource =
          await _psApiService.getShopInfo(shopId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopInfoDao.deleteAll();
        await _shopInfoDao.insert(primaryKey, _resource.data);
        shopInfoListStream.sink.add(await _shopInfoDao.getOne());
      }
    }
  }
}
