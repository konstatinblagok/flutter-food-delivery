import 'dart:async';
import 'package:fluttermultistoreflutter/db/shop_category_dao.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_category.dart';

import 'Common/ps_repository.dart';

class ShopCategoryRepository extends PsRepository {
  ShopCategoryRepository(
      {@required PsApiService psApiService,
      @required ShopCategoryDao shopCategoryDao}) {
    _psApiService = psApiService;
    _shopCategoryDao = shopCategoryDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  ShopCategoryDao _shopCategoryDao;

  Future<dynamic> insert(ShopCategory shopCategory) async {
    return _shopCategoryDao.insert(primaryKey, shopCategory);
  }

  Future<dynamic> update(ShopCategory shopCategory) async {
    return _shopCategoryDao.update(shopCategory);
  }

  Future<dynamic> delete(ShopCategory shopCategory) async {
    return _shopCategoryDao.delete(shopCategory);
  }

  Future<dynamic> getShopCategoryList(
      StreamController<PsResource<List<ShopCategory>>> shopCategoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopCategoryListStream.sink
        .add(await _shopCategoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShopCategory>> _resource =
          await _psApiService.getShopCategoryList(limit, offset, '1');

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopCategoryDao.deleteAll();
        await _shopCategoryDao.insertAll(primaryKey, _resource.data);
        shopCategoryListStream.sink.add(await _shopCategoryDao.getAll());
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }

  Future<dynamic> getNextPageShopCategoryList(
      StreamController<PsResource<List<ShopCategory>>> shopCategoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    shopCategoryListStream.sink
        .add(await _shopCategoryDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ShopCategory>> _resource =
          await _psApiService.getShopCategoryList(limit, offset, '1');

      if (_resource.status == PsStatus.SUCCESS) {
        await _shopCategoryDao.insertAll(primaryKey, _resource.data);
      }
      shopCategoryListStream.sink.add(await _shopCategoryDao.getAll());
    }
  }
}
