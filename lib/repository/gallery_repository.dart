import 'dart:async';
import 'package:fluttermultistoreflutter/db/gallery_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/default_photo.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/api/ps_api_service.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class GalleryRepository extends PsRepository {
  GalleryRepository(
      {@required PsApiService psApiService, @required GalleryDao galleryDao}) {
    _psApiService = psApiService;
    _galleryDao = galleryDao;
  }

  String primaryKey = 'id';
  String imgParentId = 'img_parent_id';
  PsApiService _psApiService;
  GalleryDao _galleryDao;

  Future<dynamic> insert(DefaultPhoto image) async {
    return _galleryDao.insert(primaryKey, image);
  }

  Future<dynamic> update(DefaultPhoto image) async {
    return _galleryDao.update(image);
  }

  Future<dynamic> delete(DefaultPhoto image) async {
    return _galleryDao.delete(image);
  }

  Future<dynamic> getAllImageList(
      StreamController<PsResource<List<DefaultPhoto>>> galleryListStream,
      bool isConnectedToInternet,
      String parentImgId,
      // String imageType,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    galleryListStream.sink.add(await _galleryDao.getAll(
        finder: Finder(filter: Filter.equals(imgParentId, parentImgId)),
        status: status));

    if (isConnectedToInternet) {
      final PsResource<List<DefaultPhoto>> _resource =
          await _psApiService.getImageList(
              parentImgId,
              // imageType,
              limit,
              offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _galleryDao.deleteWithFinder(
            Finder(filter: Filter.equals(imgParentId, parentImgId)));
        await _galleryDao.insertAll(primaryKey, _resource.data);
        galleryListStream.sink.add(await _galleryDao.getAll(
            finder: Finder(filter: Filter.equals(imgParentId, parentImgId))));
        //finder: Finder(sortOrders: [SortOrder(primaryKey, false)])));
      }
    }
  }
}
