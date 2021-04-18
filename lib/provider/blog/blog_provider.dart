import 'dart:async';
import 'package:fluttermultistoreflutter/repository/blog_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/blog.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';

class BlogProvider extends PsProvider {
  BlogProvider(
      {@required BlogRepository repo, this.psValueHolder, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Blog Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    blogListStream = StreamController<PsResource<List<Blog>>>.broadcast();
    subscription =
        blogListStream.stream.listen((PsResource<List<Blog>> resource) {
      updateOffset(resource.data.length);

      _blogList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  BlogRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<List<Blog>> _blogList =
      PsResource<List<Blog>>(PsStatus.NOACTION, '', <Blog>[]);

  PsResource<List<Blog>> get blogList => _blogList;
  StreamSubscription<PsResource<List<Blog>>> subscription;
  StreamController<PsResource<List<Blog>>> blogListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    blogListStream.close();
    isDispose = true;
    print('Blog Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadBlogList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllBlogList(blogListStream, isConnectedToInternet, limit,
        offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> loadBlogListWithShopId(String shopId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllBlogListByShopId(blogListStream, isConnectedToInternet,
        shopId, limit, offset, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextBlogList(String shopId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageBlogList(blogListStream, isConnectedToInternet,
          shopId, limit, offset, PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetBlogList(
    String shopId,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllBlogListByShopId(blogListStream, isConnectedToInternet,
        shopId, limit, offset, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }
}
