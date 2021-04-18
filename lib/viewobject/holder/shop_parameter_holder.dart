import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_holder.dart';

class ShopParameterHolder extends PsHolder<dynamic> {
  ShopParameterHolder() {
    isFeatured = '0';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
  }

  String isFeatured;
  String orderBy;
  String orderType;

  ShopParameterHolder getNewShopParameterHolder() {
    isFeatured = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  ShopParameterHolder getFeaturedShopParameterHolder() {
    isFeatured = PsConst.ONE;
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  ShopParameterHolder getPopularShopParameterHolder() {
    isFeatured = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  ShopParameterHolder resetParameterHolder() {
    isFeatured = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['is_featured'] = isFeatured;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    isFeatured = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;

    return this;
  }

  @override
  String getParamKey() {
    const String newshop = 'New Shops';
    const String featured = 'Featured Shops';
    const String popularshop = 'Popular Shops';

    String result = '';

    if (isFeatured != '' && isFeatured != '0') {
      result += featured + ':';
    }

    if (newshop != '') {
      result += newshop + ':';
    }

    if (popularshop != '') {
      result += popularshop + ':';
    }

    if (orderBy != '') {
      result += orderBy + ':';
    }

    if (orderType != '') {
      result += orderType;
    }

    return result;
  }
}
