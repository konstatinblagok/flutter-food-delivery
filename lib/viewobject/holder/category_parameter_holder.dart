import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    shopId = '';
  }

  String orderBy;
  String shopId;

  CategoryParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;
    shopId = '';

    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    shopId = '';
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;
    map['shop_id'] = shopId;

    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    shopId = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy + ':';
    }

    if (shopId != '') {
      result += shopId + ':';
    }

    return result;
  }
}
