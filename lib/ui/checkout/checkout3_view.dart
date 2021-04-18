import 'dart:io';

import 'package:braintree_payment/braintree_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_cost/shipping_cost_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_method/shipping_method_provider.dart';
import 'package:fluttermultistoreflutter/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultistoreflutter/provider/token/token_provider.dart';
import 'package:fluttermultistoreflutter/provider/transaction/transaction_header_provider.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/loading_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_textfield_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/checkout_status_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/transaction_header.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Checkout3View extends StatefulWidget {
  const Checkout3View(this.updateCheckout3ViewState, this.basketList);

  final Function updateCheckout3ViewState;

  final List<Basket> basketList;

  @override
  _Checkout3ViewState createState() {
    final _Checkout3ViewState _state = _Checkout3ViewState();
    updateCheckout3ViewState(_state);
    return _state;
  }
}

class _Checkout3ViewState extends State<Checkout3View> {
  bool isCheckBoxSelect = false;
  bool isCashClicked = false;
  bool isPaypalClicked = false;
  bool isStripeClicked = false;
  bool isBankClicked = false;

  PsValueHolder valueHolder;
  ShippingMethodProvider shippingMethodProvider;
  CouponDiscountProvider couponDiscountProvider;
  ShippingCostProvider shippingCostProvider;
  BasketProvider basketProvider;
  final TextEditingController memoController = TextEditingController();

  void checkStatus() {
    print('Checking Status ... $isCheckBoxSelect');
  }

  dynamic callBankNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    ShippingMethodProvider shippingMethodProvider,
  ) async {
    if (await Utils.checkInternetConnectivity()) {
      if (userLoginProvider.user != null &&
          userLoginProvider.user.data != null) {
        final ProgressDialog progressDialog = loadingDialog(
          context,
        );
        progressDialog.show();
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider.postTransactionSubmit(
                userLoginProvider.user.data,
                widget.basketList,
                '',
                couponDiscountProvider.couponDiscount.toString(),
                basketProvider.checkoutCalculationHelper.taxFormattedString,
                basketProvider
                    .checkoutCalculationHelper.totalDiscountFormattedString,
                basketProvider
                    .checkoutCalculationHelper.subTotalPriceFormattedString,
                basketProvider
                    .checkoutCalculationHelper.shippingTaxFormattedString,
                basketProvider
                    .checkoutCalculationHelper.totalPriceFormattedString,
                basketProvider.checkoutCalculationHelper
                    .totalOriginalPriceFormattedString,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ONE,
                basketProvider
                    .checkoutCalculationHelper.shippingCostFormattedString,
                (shippingMethodProvider.selectedShippingName == null)
                    ? shippingMethodProvider.defaultShippingName
                    : shippingMethodProvider.selectedShippingName,
                memoController.text);

        if (_apiStatus.data != null) {
          progressDialog.hide();

          await basketProvider.deleteWholeBasketList();
          Navigator.pop(context, true);
          await Navigator.pushReplacementNamed(
              context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data,
                userProvider: userLoginProvider,
              ));
        } else {
          progressDialog.hide();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic callCardNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    ShippingMethodProvider shippingMethodProvider,
  ) async {
    if (await Utils.checkInternetConnectivity()) {
      if (userLoginProvider.user != null &&
          userLoginProvider.user.data != null) {
        final ProgressDialog progressDialog = loadingDialog(
          context,
        );

        progressDialog.show();
        print(basketProvider
            .checkoutCalculationHelper.subTotalPriceFormattedString);
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider.postTransactionSubmit(
                userLoginProvider.user.data,
                widget.basketList,
                '',
                couponDiscountProvider.couponDiscount.toString(),
                basketProvider.checkoutCalculationHelper.taxFormattedString,
                basketProvider
                    .checkoutCalculationHelper.totalDiscountFormattedString,
                basketProvider
                    .checkoutCalculationHelper.subTotalPriceFormattedString,
                basketProvider
                    .checkoutCalculationHelper.shippingTaxFormattedString,
                basketProvider
                    .checkoutCalculationHelper.totalPriceFormattedString,
                basketProvider.checkoutCalculationHelper
                    .totalOriginalPriceFormattedString,
                PsConst.ONE,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                basketProvider
                    .checkoutCalculationHelper.shippingCostFormattedString,
                (shippingMethodProvider.selectedShippingName == null)
                    ? shippingMethodProvider.defaultShippingName
                    : shippingMethodProvider.selectedShippingName,
                memoController.text);

        if (_apiStatus.data != null) {
          progressDialog.hide();

          await basketProvider.deleteWholeBasketList();
          Navigator.pop(context, true);

          await Navigator.pushReplacementNamed(
              context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data,
                userProvider: userLoginProvider,
              ));
        } else {
          progressDialog.hide();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic payNow(
      String clientNonce,
      UserProvider userProvider,
      TransactionHeaderProvider transactionSubmitProvider,
      CouponDiscountProvider couponDiscountProvider,
      ShippingMethodProvider shippingMethodProvider,
      ShippingCostProvider shippingCostProvider,
      PsValueHolder psValueHolder,
      BasketProvider basketProvider) async {
    if (psValueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider.selectedPrice == '0.0'
                  ? shippingMethodProvider.defaultShippingPrice
                  : shippingMethodProvider.selectedPrice ?? '0.0');
    } else if (psValueHolder.zoneShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting:
              shippingCostProvider.shippingCost.data.shippingZone.shippingCost);
    }

    final BraintreePayment braintreePayment = BraintreePayment();
    final dynamic data = await braintreePayment.showDropIn(
        nonce: clientNonce,
        amount:
            basketProvider.checkoutCalculationHelper.totalPriceFormattedString,
        enableGooglePay: true);
    print('${Utils.getString(context, 'checkout__payment_response')} $data');

    final ProgressDialog progressDialog = loadingDialog(
      context,
    );

    if (await Utils.checkInternetConnectivity()) {
      if (data != null && data != 'error' && data != 'cancelled') {
        print(data);

        progressDialog.show();

        if (userProvider.user != null && userProvider.user.data != null) {
          final PsResource<TransactionHeader> _apiStatus =
              await transactionSubmitProvider.postTransactionSubmit(
                  userProvider.user.data,
                  widget.basketList,
                  Platform.isIOS ? data : data['paymentNonce'],
                  couponDiscountProvider.couponDiscount.toString(),
                  basketProvider.checkoutCalculationHelper.taxFormattedString,
                  basketProvider
                      .checkoutCalculationHelper.totalDiscountFormattedString,
                  basketProvider
                      .checkoutCalculationHelper.subTotalPriceFormattedString,
                  basketProvider
                      .checkoutCalculationHelper.shippingTaxFormattedString,
                  basketProvider
                      .checkoutCalculationHelper.totalPriceFormattedString,
                  basketProvider.checkoutCalculationHelper
                      .totalOriginalPriceFormattedString,
                  PsConst.ZERO,
                  PsConst.ONE,
                  PsConst.ZERO,
                  PsConst.ZERO,
                  basketProvider
                      .checkoutCalculationHelper.shippingCostFormattedString,
                  (shippingMethodProvider.selectedShippingName == null)
                      ? shippingMethodProvider.defaultShippingName
                      : shippingMethodProvider.selectedShippingName,
                  memoController.text);

          if (_apiStatus.data != null) {
            progressDialog.hide();

            if (_apiStatus.status == PsStatus.SUCCESS) {
              await basketProvider.deleteWholeBasketList();
              Navigator.pop(context, true);
              await Navigator.pushReplacementNamed(
                  context, RoutePaths.checkoutSuccess,
                  arguments: CheckoutStatusIntentHolder(
                    transactionHeader: _apiStatus.data,
                    userProvider: userProvider,
                  ));
            } else {
              progressDialog.hide();

              return showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          } else {
            progressDialog.hide();

            return showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: _apiStatus.message,
                  );
                });
          }
        }
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    return Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
        TransactionHeaderProvider transactionHeaderProvider, Widget child) {
      return Consumer<BasketProvider>(builder:
          (BuildContext context, BasketProvider basketProvider, Widget child) {
        return Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider userProvider, Widget child) {
          return Consumer<TokenProvider>(builder: (BuildContext context,
              TokenProvider tokenProvider, Widget child) {
            if (tokenProvider.tokenData != null &&
                tokenProvider.tokenData.data != null &&
                tokenProvider.tokenData.data.message != null) {
              couponDiscountProvider = Provider.of<CouponDiscountProvider>(
                  context,
                  listen: false); // Listen : False is important.
              shippingCostProvider = Provider.of<ShippingCostProvider>(context,
                  listen: false); // Listen : False is important.
              shippingMethodProvider = Provider.of<ShippingMethodProvider>(
                  context,
                  listen: false); // Listen : False is important.
              basketProvider = Provider.of<BasketProvider>(context,
                  listen: false); // Listen : False is important.

              return SingleChildScrollView(
                child: Container(
                  color: PsColors.backgroundColor,
                  padding: const EdgeInsets.only(
                    left: PsDimens.space12,
                    right: PsDimens.space12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space16, right: PsDimens.space16),
                        child: Text(
                          Utils.getString(context, 'checkout3__payment_method'),
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                      const SizedBox(
                        height: PsDimens.space16,
                      ),
                      const Divider(
                        height: 2,
                      ),
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      Consumer<ShopInfoProvider>(builder: (BuildContext context,
                          ShopInfoProvider shopInfoProvider, Widget child) {
                        if (shopInfoProvider.shopInfo.data == null) {
                          return Container();
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Visibility(
                                visible:
                                    shopInfoProvider.shopInfo.data.codEnabled ==
                                        '1',
                                child: Container(
                                  width: PsDimens.space140,
                                  height: PsDimens.space140,
                                  padding:
                                      const EdgeInsets.all(PsDimens.space8),
                                  child: InkWell(
                                    onTap: () {
                                      if (!isCashClicked) {
                                        isCashClicked = true;
                                        isPaypalClicked = false;
                                        isStripeClicked = false;
                                        isBankClicked = false;
                                      }

                                      setState(() {});
                                    },
                                    child: checkIsCashSelected(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: shopInfoProvider
                                        .shopInfo.data.paypalEnabled ==
                                    '1',
                                child: Container(
                                  width: PsDimens.space140,
                                  height: PsDimens.space140,
                                  padding:
                                      const EdgeInsets.all(PsDimens.space8),
                                  child: InkWell(
                                    onTap: () {
                                      if (!isPaypalClicked) {
                                        isCashClicked = false;
                                        isPaypalClicked = true;
                                        isStripeClicked = false;
                                        isBankClicked = false;
                                      }

                                      setState(() {});
                                    },
                                    child: checkIsPaypalSelected(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: shopInfoProvider
                                        .shopInfo.data.stripeEnabled ==
                                    '1',
                                child: Container(
                                  width: PsDimens.space140,
                                  height: PsDimens.space140,
                                  padding:
                                      const EdgeInsets.all(PsDimens.space8),
                                  child: InkWell(
                                    onTap: () async {
                                      if (!isStripeClicked) {
                                        isCashClicked = false;
                                        isPaypalClicked = false;
                                        isStripeClicked = true;
                                        isBankClicked = false;
                                      }

                                      setState(() {});
                                    },
                                    child: checkIsStripeSelected(),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: shopInfoProvider
                                        .shopInfo.data.banktransferEnabled ==
                                    '1',
                                child: Container(
                                  width: PsDimens.space140,
                                  height: PsDimens.space140,
                                  padding:
                                      const EdgeInsets.all(PsDimens.space8),
                                  child: InkWell(
                                    onTap: () {
                                      if (!isBankClicked) {
                                        isCashClicked = false;
                                        isPaypalClicked = false;
                                        isStripeClicked = false;
                                        isBankClicked = true;
                                      }

                                      setState(() {});
                                    },
                                    child: checkIsBankSelected(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: PsDimens.space12,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space16, right: PsDimens.space16),
                        child: showOrHideCashText(),
                      ),
                      const SizedBox(
                        height: PsDimens.space8,
                      ),
                      PsTextFieldWidget(
                          titleText:
                              Utils.getString(context, 'checkout3__memo'),
                          height: PsDimens.space80,
                          textAboutMe: true,
                          hintText: Utils.getString(context, 'checkout3__memo'),
                          keyboardType: TextInputType.multiline,
                          textEditingController: memoController),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            activeColor: PsColors.mainColor,
                            value: isCheckBoxSelect,
                            onChanged: (bool value) {
                              setState(() {
                                updateCheckBox();
                              });
                            },
                          ),
                          Expanded(
                            child: InkWell(
                              child: Text(
                                Utils.getString(
                                    context, 'checkout3__agree_policy'),
                                style: Theme.of(context).textTheme.body1,
                                maxLines: 2,
                              ),
                              onTap: () {
                                setState(() {
                                  updateCheckBox();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: PsDimens.space60,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
        });
      });
    });
  }

  void updateCheckBox() {
    if (isCheckBoxSelect) {
      isCheckBoxSelect = false;
    } else {
      isCheckBoxSelect = true;
    }
  }

  Widget checkIsCashSelected() {
    if (!isCashClicked) {
      // isClicked = true;
      return changeCashCardToWhite();
    } else {
      return changeCashCardToOrange();
    }
  }

  Widget changeCashCardToWhite() {
    return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(width: 50, height: 50, child: Icon(Ionicons.md_cash)),
              Container(
                margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                ),
                child: Text(Utils.getString(context, 'checkout3__cod'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget changeCashCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(
                  Ionicons.md_cash,
                  color: PsColors.white,
                )),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__cod'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsPaypalSelected() {
    if (!isPaypalClicked) {
      // isClicked = true;
      return changePaypalCardToWhite();
    } else {
      return changePaypalCardToOrange();
    }
  }

  Widget changePaypalCardToOrange() {
    return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.mainColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                  width: 50,
                  height: 50,
                  child: Icon(Foundation.paypal, color: PsColors.white)),
              Container(
                margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                ),
                child: Text(Utils.getString(context, 'checkout3__paypal'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(height: 1.3, color: PsColors.white)),
              ),
            ],
          ),
        ));
  }

  Widget changePaypalCardToWhite() {
    return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(width: 50, height: 50, child: Icon(Foundation.paypal)),
              Container(
                margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                ),
                child: Text(Utils.getString(context, 'checkout3__paypal'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget checkIsStripeSelected() {
    if (!isStripeClicked) {
      // isClicked = true;
      return changeStripeCardToWhite();
    } else {
      return changeStripeCardToOrange();
    }
  }

  Widget changeStripeCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeStripeCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsBankSelected() {
    if (!isBankClicked) {
      return changeBankCardToWhite();
    } else {
      return changeBankCardToOrange();
    }
  }

  Widget changeBankCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeBankCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget showOrHideCashText() {
    if (isCashClicked) {
      return Text(Utils.getString(context, 'checkout3__cod_message'),
          style: Theme.of(context).textTheme.body1);
    } else {
      return null;
    }
  }
}
