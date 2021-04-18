import 'dart:io';
import 'package:fluttermultistoreflutter/api/common/ps_resource.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_cost/shipping_cost_provider.dart';
import 'package:fluttermultistoreflutter/provider/shipping_method/shipping_method_provider.dart';
import 'package:fluttermultistoreflutter/provider/transaction/transaction_header_provider.dart';
import 'package:fluttermultistoreflutter/provider/user/user_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/error_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/loading_dialog.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/warning_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_credit_card_form.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/checkout_status_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/transaction_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CreditCardView extends StatefulWidget {
  const CreditCardView(
      {Key key,
      @required this.basketList,
      @required this.couponDiscount,
      @required this.psValueHolder,
      @required this.transactionSubmitProvider,
      @required this.userLoginProvider,
      @required this.basketProvider,
      @required this.shippingMethodProvider,
      @required this.shippingCostProvider,
      @required this.memoText,
      @required this.publishKey})
      : super(key: key);

  final List<Basket> basketList;
  final String couponDiscount;
  final PsValueHolder psValueHolder;
  final TransactionHeaderProvider transactionSubmitProvider;
  final UserProvider userLoginProvider;
  final BasketProvider basketProvider;
  final ShippingMethodProvider shippingMethodProvider;
  final ShippingCostProvider shippingCostProvider;
  final String memoText;
  final String publishKey;

  @override
  State<StatefulWidget> createState() {
    return CreditCardViewState();
  }
}

dynamic callTransactionSubmitApi(
    BuildContext context,
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    ShippingMethodProvider shippingMethodProvider,
    List<Basket> basketList,
    ProgressDialog progressDialog,
    String token,
    String couponDiscount,
    String memoText) async {
  if (await Utils.checkInternetConnectivity()) {
    if (userLoginProvider.user != null && userLoginProvider.user.data != null) {
      final PsResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider.postTransactionSubmit(
              userLoginProvider.user.data,
              basketList,
              Platform.isIOS ? token : token,
              couponDiscount.toString(),
              basketProvider.checkoutCalculationHelper.taxFormattedString,
              basketProvider
                  .checkoutCalculationHelper.totalDiscountFormattedString,
              basketProvider
                  .checkoutCalculationHelper.subTotalPriceFormattedString,
              basketProvider
                  .checkoutCalculationHelper.shippingTaxFormattedString,
              basketProvider
                  .checkoutCalculationHelper.totalPriceFormattedString,
              basketProvider
                  .checkoutCalculationHelper.totalOriginalPriceFormattedString,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ONE,
              PsConst.ZERO,
              basketProvider
                  .checkoutCalculationHelper.shippingCostFormattedString,
              (shippingMethodProvider.selectedShippingName == null)
                  ? shippingMethodProvider.defaultShippingName
                  : shippingMethodProvider.selectedShippingName,
              memoText);

      if (_apiStatus.data != null) {
        progressDialog.hide();

        if (_apiStatus.status == PsStatus.SUCCESS) {
          await basketProvider.deleteWholeBasketList();
          //
          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data,
                userProvider: userLoginProvider,
              ));
          Navigator.pop(context, true);
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

CreditCard callCard(String cardNumber, String expiryDate, String cardHolderName,
    String cvvCode) {
  final List<String> monthAndYear = expiryDate.split('/');
  return CreditCard(
      number: cardNumber,
      expMonth: int.parse(monthAndYear[0]),
      expYear: int.parse(monthAndYear[1]),
      name: cardHolderName,
      cvc: cvvCode);
}

class CreditCardViewState extends State<CreditCardView> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: widget.publishKey,
        merchantId: 'Test',
        androidPayMode: 'test'));
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(context, text),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic stripeNow(String token) async {
      if (widget.psValueHolder.standardShippingEnable == PsConst.ONE) {
        widget.basketProvider.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: widget.couponDiscount,
            psValueHolder: widget.psValueHolder,
            shippingPriceStringFormatting:
                widget.shippingMethodProvider.selectedPrice == '0.0'
                    ? widget.shippingMethodProvider.defaultShippingPrice
                    : widget.shippingMethodProvider.selectedPrice ?? '0.0');
      } else if (widget.psValueHolder.zoneShippingEnable == PsConst.ONE) {
        widget.basketProvider.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: widget.couponDiscount,
            psValueHolder: widget.psValueHolder,
            shippingPriceStringFormatting: widget.shippingCostProvider
                .shippingCost.data.shippingZone.shippingCost);
      }
      final ProgressDialog progressDialog = loadingDialog(
        context,
      );

      progressDialog.show();

      callTransactionSubmitApi(
          context,
          widget.basketProvider,
          widget.userLoginProvider,
          widget.transactionSubmitProvider,
          widget.shippingMethodProvider,
          widget.basketList,
          progressDialog,
          token,
          widget.couponDiscount,
          widget.memoText);
    }

    return PsWidgetWithAppBarWithNoProvider(
      appBarTitle: 'Credit Card',
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  animationDuration: PsConfig.animation_duration,
                ),
                PsCreditCardForm(
                  onCreditCardModelChange: onCreditCardModelChange,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space32, right: PsDimens.space32),
                    child: PSButtonWidget(
                      hasShadow: true,
                      width: double.infinity,
                      titleText: Utils.getString(context, 'credit_card__pay'),
                      onPressed: () async {
                        if (cardNumber.isEmpty) {
                          callWarningDialog(
                              context,
                              Utils.getString(
                                  context, 'warning_dialog__input_number'));
                        } else if (expiryDate.isEmpty) {
                          callWarningDialog(
                              context,
                              Utils.getString(
                                  context, 'warning_dialog__input_date'));
                        } else if (cardHolderName.isEmpty) {
                          callWarningDialog(
                              context,
                              Utils.getString(context,
                                  'warning_dialog__input_holder_name'));
                        } else if (cvvCode.isEmpty) {
                          callWarningDialog(
                              context,
                              Utils.getString(
                                  context, 'warning_dialog__input_cvv'));
                        } else {
                          StripePayment.createTokenWithCard(
                            callCard(cardNumber, expiryDate, cardHolderName,
                                cvvCode),
                          ).then((Token token) async {
                            await stripeNow(token.tokenId);
                          }).catchError(setError);
                        }
                      },
                    )),
                const SizedBox(height: PsDimens.space40)
              ],
            )),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
