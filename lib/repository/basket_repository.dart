import 'dart:async';
import 'package:fluttermultistoreflutter/db/basket_dao.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:sembast/sembast.dart';

import 'Common/ps_repository.dart';

class BasketRepository extends PsRepository {
  BasketRepository({@required BasketDao basketDao}) {
    _basketDao = basketDao;
  }

  String primaryKey = 'id';
  BasketDao _basketDao;

  Future<dynamic> insert(Basket basket) async {
    return _basketDao.insert(primaryKey, basket);
  }

  Future<dynamic> update(Basket basket) async {
    return _basketDao.update(basket);
  }

  Future<dynamic> delete(Basket basket) async {
    return _basketDao.delete(basket);
  }

  Future<dynamic> getAllBasketList(
      StreamController<PsResource<List<Basket>>> basketListStream,
      String shopId,
      PsStatus status) async {
    final Finder finder = Finder(filter: Filter.equals('shop_id', shopId));
    final dynamic subscription = _basketDao.getAllWithSubscription(
        finder: finder,
        status: PsStatus.SUCCESS,
        onDataUpdated: (List<Basket> productList) {
          if (status != null && status != PsStatus.NOACTION) {
            print(status);
            print('>>> Repository : $shopId');
            // print('Shop Id List Count ${productList.length}');
            // for (Basket product in productList) {
            //   print('shop id ${product.shopId}');
            // }
            basketListStream.sink
                .add(PsResource<List<Basket>>(status, '', productList));
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> addAllBasket(
      StreamController<PsResource<List<Basket>>> basketListStream,
      PsStatus status,
      Basket product) async {
    await _basketDao.insert(primaryKey, product);
    final Finder finder =
        Finder(filter: Filter.equals('shop_id', product.shopId));
    basketListStream.sink
        .add(await _basketDao.getAll(status: status, finder: finder));
  }

  Future<dynamic> updateBasket(
      StreamController<PsResource<List<Basket>>> basketListStream,
      Basket product) async {
    await _basketDao.update(product);
    final Finder finder =
        Finder(filter: Filter.equals('shop_id', product.shopId));
    basketListStream.sink
        .add(await _basketDao.getAll(status: PsStatus.SUCCESS, finder: finder));
  }

  Future<dynamic> deleteBasketByProduct(
      StreamController<PsResource<List<Basket>>> basketListStream,
      Basket product,
      PsStatus status) async {
    await _basketDao.delete(product);
    final Finder finder =
        Finder(filter: Filter.equals('shop_id', product.shopId));
    basketListStream.sink
        .add(await _basketDao.getAll(status: PsStatus.SUCCESS, finder: finder));
    // final dynamic subscription = _basketDao.getAllWithSubscription(
    //     finder: finder,
    //     status: PsStatus.SUCCESS,
    //     onDataUpdated: (List<Basket> productList) {
    //       if (status != null && status != PsStatus.NOACTION) {
    //         print(status);
    //         basketListStream.sink
    //             .add(PsResource<List<Basket>>(status, '', productList));
    //       } else {
    //         print('No Action');
    //       }
    //     });
    // return subscription;
  }

  Future<dynamic> deleteWholeBasketList(
      StreamController<PsResource<List<Basket>>> basketListStream) async {
    await _basketDao.deleteAll();
  }
}
