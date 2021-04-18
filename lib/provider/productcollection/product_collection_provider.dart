import 'dart:async';

import 'package:fluttermultistoreflutter/repository/product_collection_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/product_collection_header.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';

class ProductCollectionProvider extends PsProvider {
  ProductCollectionProvider(
      {@required ProductCollectionRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ProductCollection Provider: $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productCollectionListStream =
        StreamController<PsResource<List<ProductCollectionHeader>>>.broadcast();
    subscription =
        productCollectionListStream.stream.listen((dynamic resource) {
      //Utils.psPrint("ProductCollectionHeader Provider : ");

      updateOffset(resource.data.length);

      _productCollectionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    productCollectionStream =
        StreamController<PsResource<ProductCollectionHeader>>.broadcast();
    subscriptionById =
        productCollectionStream.stream.listen((dynamic resource) {
      _productCollection = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ProductCollectionRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<ProductCollectionHeader>> _productCollectionList =
      PsResource<List<ProductCollectionHeader>>(
          PsStatus.NOACTION, '', <ProductCollectionHeader>[]);

  PsResource<ProductCollectionHeader> _productCollection =
      PsResource<ProductCollectionHeader>(PsStatus.NOACTION, '', null);

  PsResource<List<ProductCollectionHeader>> get productCollectionList =>
      _productCollectionList;

  PsResource<ProductCollectionHeader> get productCollection =>
      _productCollection;

  StreamSubscription<PsResource<List<ProductCollectionHeader>>> subscription;
  StreamController<PsResource<List<ProductCollectionHeader>>>
      productCollectionListStream;

  StreamSubscription<PsResource<ProductCollectionHeader>> subscriptionById;
  StreamController<PsResource<ProductCollectionHeader>> productCollectionStream;
  @override
  void dispose() {
    subscription.cancel();
    subscriptionById.cancel();
    isDispose = true;
    print('Product Collection Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductCollectionList(
    String shopId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getProductCollectionList(
        productCollectionListStream,
        isConnectedToInternet,
        shopId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProductCollectionList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageProductCollectionList(
          productCollectionListStream,
          isConnectedToInternet,
          shopId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductCollectionList(
    String shopId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getProductCollectionList(
        productCollectionListStream,
        isConnectedToInternet,
        shopId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
