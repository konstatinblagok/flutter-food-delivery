import 'dart:async';

import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/repository/sub_category_repository.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/sub_category.dart';

class SubCategoryProvider extends PsProvider {
  SubCategoryProvider(
      {@required SubCategoryRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('SubCategory Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    subCategoryListStream =
        StreamController<PsResource<List<SubCategory>>>.broadcast();
    subscription = subCategoryListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _subCategoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  StreamController<PsResource<List<SubCategory>>> subCategoryListStream;
  SubCategoryRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<SubCategory>> _subCategoryList =
      PsResource<List<SubCategory>>(PsStatus.NOACTION, '', <SubCategory>[]);

  PsResource<List<SubCategory>> get subCategoryList => _subCategoryList;
  StreamSubscription<PsResource<List<SubCategory>>> subscription;

  String categoryId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSubCategoryList(String categoryId, String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        categoryId,
        shopId);
  }

  Future<dynamic> loadAllSubCategoryList(
      String categoryId, String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllSubCategoryListByCategoryId(subCategoryListStream,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING, categoryId, shopId);
  }

  Future<dynamic> nextSubCategoryList(String categoryId, String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageSubCategoryList(
          subCategoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          categoryId,
          shopId);
    }
  }

  Future<void> resetSubCategoryList(String categoryId, String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo.getSubCategoryListByCategoryId(
        subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        categoryId,
        shopId);

    isLoading = false;
  }
}
