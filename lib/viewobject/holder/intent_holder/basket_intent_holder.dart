import 'package:flutter/cupertino.dart';
import 'package:fluttermultistoreflutter/viewobject/basket_selected_attribute.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';

class BasketIntentHolder {
  const BasketIntentHolder(
      {@required this.product,
      this.id,
      this.qty,
      this.selectedColorId,
      this.selectedColorValue,
      this.basketPrice,
      this.basketSelectedAttributeList,
      this.heroTagImage,
      this.heroTagTitle,
      this.heroTagOriginalPrice,
      this.heroTagUnitPrice});
  final String id;
  final String basketPrice;
  final List<BasketSelectedAttribute> basketSelectedAttributeList;
  final String selectedColorId;
  final String selectedColorValue;
  final Product product;
  final String qty;
  final String heroTagImage;
  final String heroTagTitle;
  final String heroTagOriginalPrice;
  final String heroTagUnitPrice;
}
