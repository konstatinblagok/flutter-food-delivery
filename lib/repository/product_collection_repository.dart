import 'dart:async';
import 'package:fluttermultistoreflutter/db/product_collection_header_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/repository/Common/ps_repository.dart';

class ProductCollectionRepository extends PsRepository {
  ProductCollectionRepository(
      {@required PsApiService psApiService,
      @required ProductCollectionDao productCollectionDao}) {
    _psApiService = psApiService;
    _productCollectionDao = productCollectionDao;

  }

  PsApiService _psApiService;
  ProductCollectionDao _productCollectionDao;
  final String _primaryKey = 'id';

  void sinkProductListStream(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      PsResource<List<ProductCollectionHeader>> dataList) {
    if (dataList != null) {
      productCollectionListStream.sink.add(dataList);
    }
  }

  void sinkProductStream(
      StreamController<PsResource<ProductCollectionHeader>>
          productCollectionStream,
      PsResource<ProductCollectionHeader> data) {
    if (data != null) {
      productCollectionStream.sink.add(data);
    }
  }

  Future<dynamic> insert(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.insert(_primaryKey, productCollectionHeader);
  }

  Future<dynamic> update(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.update(productCollectionHeader);
  }

  Future<dynamic> delete(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.delete(productCollectionHeader);
  }

  Future<dynamic> getProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));

    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(finder: finder, status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _psApiService.getProductCollectionList(shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _productCollectionDao.deleteWithFinder(finder);
        await _productCollectionDao.insertAll(_primaryKey, _resource.data);
        sinkProductListStream(productCollectionListStream,
            await _productCollectionDao.getAll(finder: finder));
      }
    }
  }

  Future<dynamic> getNextPageProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      String shopId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(finder: finder, status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _psApiService.getProductCollectionList(shopId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _productCollectionDao
            .insertAll(_primaryKey, _resource.data)
            .then((dynamic data) async {
          sinkProductListStream(productCollectionListStream,
              await _productCollectionDao.getAll(finder: finder));
        });
      } else {
        sinkProductListStream(productCollectionListStream,
            await _productCollectionDao.getAll(finder: finder));
      }
    }
  }

  // Future<dynamic> productListByCollectionId(
  //     StreamController<PsResource<ProductCollectionHeader>>
  //         productCollectionStream,
  //     bool isConnectedToInternet,
  //     String collectionId,
  //     int limit,
  //     int offset,
  //     PsStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final Finder finder =
  //       Finder(filter: Filter.equals(_primaryKey, collectionId));
  //   sinkProductStream(productCollectionStream,
  //       await _productCollectionDao.getOne(finder: finder, status: status));

  //   if (isConnectedToInternet) {
  //     final PsResource<ProductCollectionHeader> _resource = await _psApiService
  //         .getProductListByCollectionId(collectionId, limit, offset);

  //     if (_resource.status == PsStatus.SUCCESS) {
  //       await _productCollectionDao.deleteAll();
  //       await _productCollectionDao.insert(_primaryKey, _resource.data);
  //       sinkProductStream(productCollectionStream,
  //           await _productCollectionDao.getOne(finder: finder));
  //     }
  //   }
  // }

  // Future<dynamic> nextPageProductListByCollectionId(
  //     StreamController<PsResource<ProductCollectionHeader>>
  //         productCollectionStream,
  //     bool isConnectedToInternet,
  //     String collectionId,
  //     int limit,
  //     int offset,
  //     PsStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final Finder finder =
  //       Finder(filter: Filter.equals(_primaryKey, collectionId));

  //   sinkProductStream(productCollectionStream,
  //       await _productCollectionDao.getOne(finder: finder, status: status));

  //   if (isConnectedToInternet) {
  //     final PsResource<ProductCollectionHeader> _resource = await _psApiService
  //         .getProductListByCollectionId(collectionId, limit, offset);

  //     if (_resource.status == PsStatus.SUCCESS) {
  //       await _productCollectionDao.insert(_primaryKey, _resource.data);
  //     }
  //     sinkProductStream(productCollectionStream,
  //         await _productCollectionDao.getOne(finder: finder));
  //   }
  // }
}
