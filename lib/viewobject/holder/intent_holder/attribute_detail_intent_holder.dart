import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/viewobject/attribute_detail.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';

class AttributeDetailIntentHolder {
  const AttributeDetailIntentHolder({
    @required this.product,
    @required this.attributeDetail,
  });
  final Product product;
  final List<AttributeDetail> attributeDetail;
}
