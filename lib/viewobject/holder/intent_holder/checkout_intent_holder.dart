import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:flutter/cupertino.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    @required this.basketList,
    @required this.publishKey,
    // @required this.totalPrice,
  });
  final List<Basket> basketList;
  final String publishKey;
  // final String totalPrice;
}
