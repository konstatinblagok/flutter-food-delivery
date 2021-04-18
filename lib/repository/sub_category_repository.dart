import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:fluttermultistoreflutter/db/sub_category_dao.dart';
import 'package:fluttermultistoreflutter/repository/Common/ps_repository.dart';
import 'package:fluttermultistoreflutter/viewobject/sub_category.dart';

class SubCategoryRepository extends PsRepository {
  SubCategoryRepository(
      {@required PsApiService psApiService,
      @required SubCategoryDao subCategoryDao}) {
    _psApiService = psApiService;
    _subCategoryDao = subCategoryDao;
  }

  PsApiService _psApiService;
  SubCategoryDao _subCategoryDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(SubCategory subCategory) async {
    return _subCategoryDao.insert(_primaryKey, subCategory);
  }

  Future<dynamic> update(SubCategory subCategory) async {
    return _subCategoryDao.update(subCategory);
  }

  Future<dynamic> delete(SubCategory subCategory) async {
    return _subCategoryDao.delete(subCategory);
  }

  Future<dynamic> getSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      String shopId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(limit, offset, categoryId, shopId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getAllSubCategoryListByCategoryId(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      PsStatus status,
      String categoryId,
      String shopId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals('cat_id', categoryId));

    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource =
        await _psApiService.getAllSubCategoryList(categoryId, shopId);

    if (_resource.status == PsStatus.SUCCESS) {
      await _subCategoryDao.insertAll(_primaryKey, _resource.data);
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }

  Future<dynamic> getNextPageSubCategoryList(
      StreamController<PsResource<List<SubCategory>>> subCategoryListStream,
      bool isConnectedToIntenet,
      int limit,
      int offset,
      PsStatus status,
      String categoryId,
      String shopId,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder();
    subCategoryListStream.sink
        .add(await _subCategoryDao.getAll(finder: finder, status: status));

    final PsResource<List<SubCategory>> _resource = await _psApiService
        .getSubCategoryList(limit, offset, categoryId, shopId);

    if (_resource.status == PsStatus.SUCCESS) {
      _subCategoryDao
          .insertAll(_primaryKey, _resource.data)
          .then((dynamic data) async {
        subCategoryListStream.sink
            .add(await _subCategoryDao.getAll(finder: finder));
      });
    } else {
      subCategoryListStream.sink
          .add(await _subCategoryDao.getAll(finder: finder));
    }
  }
}
