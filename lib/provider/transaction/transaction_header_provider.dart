import 'dart:async';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/repository/transaction_header_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:fluttermultistoreflutter/viewobject/basket_selected_attribute.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_provider.dart';
import 'package:fluttermultistoreflutter/viewobject/user.dart';

class TransactionHeaderProvider extends PsProvider {
  TransactionHeaderProvider(
      {@required TransactionHeaderRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Transaction Header Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    transactionListStream =
        StreamController<PsResource<List<TransactionHeader>>>.broadcast();
    subscription = transactionListStream.stream
        .listen((PsResource<List<TransactionHeader>> resource) {
      updateOffset(resource.data.length);

      _transactionList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    //
    transactionHeaderStream =
        StreamController<PsResource<TransactionHeader>>.broadcast();
    subscriptionObject = transactionHeaderStream.stream
        .listen((PsResource<TransactionHeader> resource) {
      _transactionSubmit = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  TransactionHeaderRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<TransactionHeader> get transactionHeader => _transactionSubmit;
  PsResource<TransactionHeader> _transactionSubmit =
      PsResource<TransactionHeader>(PsStatus.NOACTION, '', null);
  StreamSubscription<PsResource<TransactionHeader>> subscriptionObject;
  StreamController<PsResource<TransactionHeader>> transactionHeaderStream;

  PsResource<List<TransactionHeader>> _transactionList =
      PsResource<List<TransactionHeader>>(
          PsStatus.NOACTION, '', <TransactionHeader>[]);
  PsResource<List<TransactionHeader>> get transactionList => _transactionList;

  StreamSubscription<PsResource<List<TransactionHeader>>> subscription;
  StreamController<PsResource<List<TransactionHeader>>> transactionListStream;
  @override
  void dispose() {
    subscription.cancel();
    subscriptionObject.cancel();
    isDispose = true;
    print('Transaction Header Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadTransactionList(String userId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo.getAllTransactionList(
        transactionListStream,
        isConnectedToInternet,
        userId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextTransactionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo.getNextPageTransactionList(
          transactionListStream,
          isConnectedToInternet,
          psValueHolder.loginUserId,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetTransactionList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo.getAllTransactionList(
        transactionListStream,
        isConnectedToInternet,
        psValueHolder.loginUserId,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postTransactionSubmit(
      User user,
      List<Basket> basketList,
      String clientNonce,
      String couponDiscount,
      String taxAmount,
      String totalDiscount,
      String subTotalAmount,
      String shippingAmount,
      String balanceAmount,
      String totalItemAmount,
      String isCod,
      String isPaypal,
      String isStripe,
      String isBank,
      String shippingMethodPrice,
      String shippingMethodName,
      String memoText) async {
    final List<String> attributeIdStr = <String>[];
    List<String> attributeNameStr = <String>[];
    final List<String> attributePriceStr = <String>[];
    double totalItemCount = 0.0;
    for (Basket basket in basketList) {
      totalItemCount += double.parse(basket.qty);
    }

    final List<Map<String, dynamic>> detailJson = <Map<String, dynamic>>[];
    for (int i = 0; i < basketList.length; i++) {
      for (BasketSelectedAttribute basketSelectedAttribute
          in basketList[i].basketSelectedAttributeList) {
        attributeIdStr.add(basketSelectedAttribute.headerId);
        attributeNameStr.add(basketSelectedAttribute.name);
        attributePriceStr.add(basketSelectedAttribute.price);
      }
      final DetailMap carJson = DetailMap(
        psValueHolder.shopId,
        basketList[i].productId,
        basketList[i].product.name,
        attributeIdStr.join('#').toString(),
        attributeNameStr.join('#').toString(),
        attributePriceStr.join('#').toString(),
        basketList[i].selectedColorId ?? '',
        basketList[i].selectedColorValue ?? '',
        Utils.getPriceFormat(basketList[i].product.unitPrice),
        Utils.getPriceFormat(basketList[i].basketOriginalPrice),
        basketList[i].qty,
        basketList[i].product.discountAmount,
        basketList[i].product.discountValue,
        basketList[i].product.discountPercent,
        basketList[i].product.currencyShortForm,
        basketList[i].product.currencySymbol,
        basketList[i].product.productUnit,
        basketList[i].product.productMeasurement,
        basketList[i].product.shippingCost,
      );
      attributeNameStr = <String>[];
      detailJson.add(carJson.tojsonData());
    }

    final TransactionSubmitMap newPost = TransactionSubmitMap(
      shopId: psValueHolder.shopId,
      userId: user.userId,
      subTotalAmount: subTotalAmount,
      discountAmount: totalDiscount,
      couponDiscountAmount: couponDiscount ?? '',
      taxAmount: taxAmount,
      shippingAmount: shippingAmount ?? '',
      balanceAmount: balanceAmount,
      totalItemAmount: totalItemAmount,
      contactName: user.userName,
      contactPhone: user.userPhone,
      isCod: isCod == PsConst.ONE ? PsConst.ONE : PsConst.ZERO,
      isPaypal: isPaypal == PsConst.ONE ? PsConst.ONE : PsConst.ZERO,
      isStripe: isStripe == PsConst.ONE ? PsConst.ONE : PsConst.ZERO,
      isBank: isBank == PsConst.ONE ? PsConst.ONE : PsConst.ZERO,
      paymentMethodNonce: clientNonce,
      transStatusId: PsConst.THREE, // 3 = completed
      currencySymbol: basketList[0].product.currencySymbol,
      currencyShortForm: basketList[0].product.currencyShortForm,
      billingFirstName: user.billingFirstName,
      billingLastName: user.billingLastName,
      billingCompany: user.billingCompany,
      billingAddress1: user.billingAddress_1,
      billingAddress2: user.billingAddress_2,
      billingCountry: user.billingCountry,
      billingState: user.billingState,
      billingCity: user.billingCity,
      billingPostalCode: user.billingPostalCode,
      billingEmail: user.billingEmail,
      billingPhone: user.billingPhone,
      shippingFirstName: user.shippingFirstName,
      shippingLastName: user.shippingLastName,
      shippingCompany: user.shippingCompany,
      shippingAddress1: user.shippingAddress_1,
      shippingAddress2: user.shippingAddress_2,
      shippingCountry: user.shippingCountry,
      shippingState: user.shippingState,
      shippingCity: user.shippingCity,
      shippingPostalCode: user.shippingPostalCode,
      shippingEmail: user.shippingEmail,
      shippingPhone: user.shippingPhone,
      shippingTaxPercent: psValueHolder.shippingTaxLabel,
      taxPercent: psValueHolder.overAllTaxLabel,
      shippingMethodAmount: shippingMethodPrice ?? '',
      shippingMethodName: shippingMethodName ?? '',
      memo: memoText ?? '',
      totalItemCount: totalItemCount.toString(),
      isZoneShipping: psValueHolder.zoneShippingEnable,
      details: detailJson,
    );
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _transactionSubmit = await _repo.postTransactionSubmit(
        newPost.toMap(), isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _transactionSubmit;
  }
}

class DetailMap {
  DetailMap(
      this.shopId,
      this.productId,
      this.productName,
      this.productAttributeId,
      this.productAttributeName,
      this.productAttributePrice,
      this.productColorId,
      this.productColorCode,
      this.price,
      this.originalPrice,
      this.qty,
      this.discountAmount,
      this.discountValue,
      this.discountPercent,
      this.currencyShortForm,
      this.currencySymbol,
      this.productUnit,
      this.productMeasurement,
      this.shippingCost);
  String shopId,
      productId,
      productName,
      productAttributeId,
      productAttributeName,
      productAttributePrice,
      productColorId,
      productColorCode,
      price,
      originalPrice,
      discountAmount,
      qty,
      discountValue,
      discountPercent,
      currencyShortForm,
      currencySymbol,
      productUnit,
      productMeasurement,
      shippingCost;

  Map<String, dynamic> tojsonData() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['shop_id'] = productId;
    map['product_id'] = productId;
    map['product_name'] = productName;
    map['product_attribute_id'] = productAttributeId;
    map['product_attribute_name'] = productAttributeName;
    map['product_attribute_price'] = productAttributePrice;
    map['product_color_id'] = productColorId;
    map['product_color_code'] = productColorCode;
    map['unit_price'] = price;
    map['original_price'] = originalPrice;
    map['qty'] = qty;
    map['discount_amount'] = discountAmount;
    map['discount_value'] = discountValue;
    map['discount_percent'] = discountPercent;
    map['currency_short_form'] = currencyShortForm;
    map['currency_symbol'] = currencySymbol;
    map['product_unit'] = productUnit;
    map['product_measurement'] = productMeasurement;
    map['shipping_cost'] = shippingCost;
    return map;
  }
}

class TransactionSubmitMap {
  TransactionSubmitMap(
      {this.userId,
      this.shopId,
      this.subTotalAmount,
      this.discountAmount,
      this.couponDiscountAmount,
      this.taxAmount,
      this.shippingAmount,
      this.balanceAmount,
      this.totalItemAmount,
      this.totalItemCount,
      this.contactName,
      this.contactPhone,
      this.isCod,
      this.isPaypal,
      this.isStripe,
      this.isBank,
      this.paymentMethodNonce,
      this.transStatusId,
      this.currencySymbol,
      this.currencyShortForm,
      this.billingFirstName,
      this.billingLastName,
      this.billingCompany,
      this.billingAddress1,
      this.billingAddress2,
      this.billingCountry,
      this.billingState,
      this.billingCity,
      this.billingPostalCode,
      this.billingEmail,
      this.billingPhone,
      this.shippingFirstName,
      this.shippingLastName,
      this.shippingCompany,
      this.shippingAddress1,
      this.shippingAddress2,
      this.shippingCountry,
      this.shippingState,
      this.shippingCity,
      this.shippingPostalCode,
      this.shippingEmail,
      this.shippingPhone,
      this.shippingTaxPercent,
      this.taxPercent,
      this.shippingMethodAmount,
      this.shippingMethodName,
      this.memo,
      this.isZoneShipping,
      this.details});

  String userId;
  String shopId;
  String subTotalAmount;
  String discountAmount;
  String couponDiscountAmount;
  String taxAmount;
  String shippingAmount;
  String balanceAmount;
  String totalItemAmount;
  String contactName;
  String contactPhone;
  String isCod;
  String isPaypal;
  String isStripe;
  String isBank;
  String paymentMethodNonce;
  String transStatusId;
  String currencySymbol;
  String currencyShortForm;
  String billingFirstName;
  String billingLastName;
  String billingCompany;
  String billingAddress1;
  String billingAddress2;
  String billingCountry;
  String billingState;
  String billingCity;
  String billingPostalCode;
  String billingEmail;
  String billingPhone;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingAddress1;
  String shippingAddress2;
  String shippingCountry;
  String shippingState;
  String shippingCity;
  String shippingPostalCode;
  String shippingEmail;
  String shippingPhone;
  String shippingTaxPercent;
  String taxPercent;
  String shippingMethodAmount;
  String shippingMethodName;
  String memo;
  String totalItemCount;
  String isZoneShipping;
  List<Map<String, dynamic>> details;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['shop_id'] = shopId;
    map['sub_total_amount'] = subTotalAmount;
    map['discount_amount'] = discountAmount;
    map['coupon_discount_amount'] = couponDiscountAmount;
    map['tax_amount'] = taxAmount;
    map['shipping_amount'] = shippingAmount;
    map['balance_amount'] = balanceAmount;
    map['total_item_amount'] = totalItemAmount;
    map['total_item_count'] = totalItemCount;
    map['contact_name'] = contactName;
    map['contact_phone'] = contactPhone;
    map['is_cod'] = isCod;
    map['is_paypal'] = isPaypal;
    map['is_stripe'] = isStripe;
    map['is_bank'] = isBank;
    map['payment_method_nonce'] = paymentMethodNonce;
    map['trans_status_id'] = transStatusId;
    map['currency_symbol'] = currencySymbol;
    map['currency_short_form'] = currencyShortForm;
    map['billing_first_name'] = billingFirstName;
    map['billing_last_name'] = billingLastName;
    map['billing_company'] = billingCompany;
    map['billing_address_1'] = billingAddress1;
    map['billing_address_2'] = billingAddress2;
    map['billing_country'] = billingCountry;
    map['billing_state'] = billingState;
    map['billing_city'] = billingCity;
    map['billing_postal_code'] = billingPostalCode;
    map['billing_email'] = billingEmail;
    map['billing_phone'] = billingPhone;
    map['shipping_first_name'] = shippingFirstName;
    map['shipping_last_name'] = shippingLastName;
    map['shipping_company'] = shippingCountry;
    map['shipping_address_1'] = shippingAddress1;
    map['shipping_address_2'] = shippingAddress2;
    map['shipping_country'] = shippingCountry;
    map['shipping_state'] = shippingState;
    map['shipping_city'] = shippingCity;
    map['shipping_postal_code'] = shippingPostalCode;
    map['shipping_email'] = shippingEmail;
    map['shipping_phone'] = shippingPhone;
    map['shipping_tax_percent'] = shippingTaxPercent;
    map['tax_percent'] = taxPercent;
    map['shipping_method_amount'] = shippingMethodAmount;
    map['shipping_method_name'] = shippingMethodName;
    map['memo'] = memo;
    map['is_zone_shipping'] = isZoneShipping;
    map['details'] = details;

    return map;
  }
}
