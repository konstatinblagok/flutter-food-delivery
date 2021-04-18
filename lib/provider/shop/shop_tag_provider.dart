import 'dart:async';
import 'package:fluttermultistoreflutter/repository/shop_tag_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';

class ShopTagProvider extends PsProvider {
  ShopTagProvider({@required ShopTagRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('ShopTag Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    shopTagListStream = StreamController<PsResource<List<ShopTag>>>.broadcast();
    subscription =
        shopTagListStream.stream.listen((PsResource<List<ShopTag>> resource) {
      updateOffset(resource.data.length);

      _shopTagList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  ShopTagRepository _repo;

  PsResource<List<ShopTag>> _shopTagList =
      PsResource<List<ShopTag>>(PsStatus.NOACTION, '', <ShopTag>[]);

  PsResource<List<ShopTag>> get shopTagList => _shopTagList;
  StreamSubscription<PsResource<List<ShopTag>>> subscription;
  StreamController<PsResource<List<ShopTag>>> shopTagListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    shopTagListStream.close();
    isDispose = true;
    print('ShopTag Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadShopTagList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getShopTagList(shopTagListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextShopTagList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageShopTagList(shopTagListStream,
          isConnectedToInternet, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetShopTagList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getShopTagList(shopTagListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
