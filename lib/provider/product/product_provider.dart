import 'dart:async';
import 'package:fluttermultistoreflutter/repository/product_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/download_product.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';

class ProductDetailProvider extends PsProvider {
  ProductDetailProvider(
      {@required ProductRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ProductDetailProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productDetailStream = StreamController<PsResource<Product>>.broadcast();
    subscription =
        productDetailStream.stream.listen((PsResource<Product> resource) {
      _product = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        if (_product != null) {
          notifyListeners();
        }
      }
    });
  }

  ProductRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<Product> _product =
      PsResource<Product>(PsStatus.NOACTION, '', null);

  PsResource<Product> get productDetail => _product;
  StreamSubscription<PsResource<Product>> subscription;
  StreamController<PsResource<Product>> productDetailStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Product Detail Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProduct(
      String productId, String loginUserId, String shopId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductDetail(productDetailStream, productId, loginUserId,
        shopId, isConnectedToInternet, PsStatus.BLOCK_LOADING);
  }

  void updateProduct(Product product) {
    _product.data = product;
  }

  Future<dynamic> loadProductForFav(
    String productId,
    String loginUserId,
    String shopId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getProductDetailForFav(productDetailStream, productId,
        loginUserId, shopId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextProduct(
    String productId,
    String loginUserId,
    String shopId,
  ) async {
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      await _repo.getProductDetail(productDetailStream, productId, loginUserId,
          shopId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetProductDetail(
    String productId,
    String loginUserId,
    String shopId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getProductDetail(productDetailStream, productId, loginUserId,
        shopId, isConnectedToInternet, PsStatus.BLOCK_LOADING);

    isLoading = false;
  }

  PsResource<List<DownloadProduct>> _downloadProduct =
      PsResource<List<DownloadProduct>>(PsStatus.NOACTION, '', null);
  PsResource<List<DownloadProduct>> get user => _downloadProduct;

  Future<dynamic> postDownloadProductList(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _downloadProduct = await _repo.postDownloadProductList(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _downloadProduct;
  }
}
