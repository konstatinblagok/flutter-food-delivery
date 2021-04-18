import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/db/shop_tag_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';
import 'Common/ps_repository.dart';

class ShopTagRepository extends PsRepository {
  ShopTagRepository(
      {@required PsApiService psApiService, @required ShopTagDao shopTagDao}) {
    _psApiService = psApiService;
    _shopTagDao = shopTagDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShopTagDao _shopTagDao;

  Future<dynamic> insert(ShopTag shopTag) async {
    return _shopTagDao.insert(primaryKey, shopTag);
  }

  Future<dynamic> update(ShopTag shopTag) async {
    return _shopTagDao.update(shopTag);
  }

  Future<dynamic> delete(ShopTag shopTag) async {
    return _shopTagDao.delete(shopTag);
  }

  Future<dynamic> getShopTagList(
      StreamController<PsResource<List<ShopTag>>> shopTagListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopTagListStream.sink.add(await _shopTagDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShopTag>> _resource =
          await _psApiService.getShopTagList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopTagDao.deleteAll();
        await _shopTagDao.insertAll(primaryKey, _resource.data);
        shopTagListStream.sink.add(await _shopTagDao.getAll());
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }

  Future<dynamic> getNextPageShopTagList(
      StreamController<PsResource<List<ShopTag>>> shopTagListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopTagListStream.sink.add(await _shopTagDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShopTag>> _resource =
          await _psApiService.getShopTagList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopTagDao.insertAll(primaryKey, _resource.data);
      }
      shopTagListStream.sink.add(await _shopTagDao.getAll());
    }
  }
}
