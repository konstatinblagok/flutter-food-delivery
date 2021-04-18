import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_cost/shipping_cost_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_method/shipping_method_provider.dart';
import 'package:fluttermultistoreflutter/provider/transaction/transaction_header_provider.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:flutter/cupertino.dart';

class CreditCardIntentHolder {
  const CreditCardIntentHolder(
      {@required this.basketList,
      @required this.couponDiscount,
      @required this.psValueHolder,
      @required this.transactionSubmitProvider,
      @required this.userProvider,
      @required this.basketProvider,
      @required this.shippingMethodProvider,
      @required this.shippingCostProvider,
      @required this.memoText,
      @required this.publishKey});

  final List<Basket> basketList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserProvider userProvider;
  final BasketProvider basketProvider;
  final ShippingMethodProvider shippingMethodProvider;
  final ShippingCostProvider shippingCostProvider;
  final String memoText;
  final String publishKey;
}
