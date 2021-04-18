import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/shipping_method/shipping_method_provider.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_method.dart';

class ShippingMethodItemView extends StatelessWidget {
  const ShippingMethodItemView({
    Key key,
    @required this.shippingMethod,
    @required this.shippingMethodProvider,
    this.onShippingMethodTap(),
  }) : super(key: key);

  final Function onShippingMethodTap;
  final ShippingMethod shippingMethod;
  final ShippingMethodProvider shippingMethodProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onShippingMethodTap,
      child: Container(
          margin: const EdgeInsets.only(left: 5),
          child: checkIsSelected(shippingMethod, context)),
    );
  }

  Widget checkIsSelected(ShippingMethod shippingMethod, BuildContext context) {
    if (shippingMethodProvider.selectedShippingMethod == null &&
        shippingMethodProvider.psValueHolder.shippingId == shippingMethod.id) {
      return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.mainColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    '${shippingMethod.currencySymbol}${shippingMethod.price}',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: PsColors.white)),
              ),
              const SizedBox(
                height: PsDimens.space20,
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: PsColors.white)),
                ),
              ),
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString(context, 'checkout2__days'),
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: PsColors.white)),
              ),
            ],
          ),
        ),
      );
    } else if (shippingMethodProvider.selectedShippingMethod != null &&
        shippingMethod != null &&
        shippingMethodProvider.selectedShippingMethod.id == shippingMethod.id &&
        shippingMethodProvider.selectedShippingMethod.id.isNotEmpty) {
      return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.mainColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    '${shippingMethod.currencySymbol}${shippingMethod.price}',
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: PsColors.white)),
              ),
              const SizedBox(
                height: PsDimens.space20,
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: PsColors.white)),
                ),
              ),
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString(context, 'checkout2__days'),
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: PsColors.white)),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    '${shippingMethod.currencySymbol}${shippingMethod.price}',
                    style: Theme.of(context).textTheme.headline),
              ),
              const SizedBox(
                height: PsDimens.space20,
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(shippingMethod.name,
                      style: Theme.of(context).textTheme.body1),
                ),
              ),
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                child: Text(
                    '${shippingMethod.days}  ' +
                        Utils.getString(context, 'checkout2__days'),
                    style: Theme.of(context).textTheme.subhead),
              ),
            ],
          ),
        ),
      );
    }
  }
}
