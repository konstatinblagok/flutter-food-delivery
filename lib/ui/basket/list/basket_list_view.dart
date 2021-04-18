import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/basket/basket_provider.dart';
import 'package:fluttermultistoreflutter/repository/basket_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/dialog/confirm_dialog_view.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/basket.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/checkout_intent_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:provider/provider.dart';
import '../item/basket_list_item.dart';

class BasketListView extends StatefulWidget {
  const BasketListView({
    Key key,
    @required this.animationController,
  }) : super(key: key);

  final AnimationController animationController;
  @override
  _BasketListViewState createState() => _BasketListViewState();
}

class _BasketListViewState extends State<BasketListView>
    with SingleTickerProviderStateMixin {
  BasketRepository basketRepo;
  PsValueHolder valueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConst.SHOW_ADMOB) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConst.SHOW_ADMOB) {
      print('loading ads....');
      checkConnection();
    }
    data = EasyLocalizationProvider.of(context).data;
    basketRepo = Provider.of<BasketRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return EasyLocalizationProvider(
        data: data,
        child: ChangeNotifierProvider<BasketProvider>(
          create: (BuildContext context) {
            final BasketProvider provider =
                BasketProvider(repo: basketRepo, psValueHolder: valueHolder);
            provider.loadBasketList(provider.psValueHolder.shopId);
            return provider;
          },
          child: Consumer<BasketProvider>(builder:
              (BuildContext context, BasketProvider provider, Widget child) {
            if (provider.basketList != null &&
                provider.basketList.data != null) {
              if (provider.basketList.data.isNotEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const PsAdMobBannerWidget(),
                    // Visibility(
                    //   visible: PsConst.SHOW_ADMOB &&
                    //       isSuccessfullyLoaded &&
                    //       isConnectedToInternet,
                    //   child: AdmobBanner(
                    //     adUnitId: Utils.getBannerAdUnitId(),
                    //     adSize: AdmobBannerSize.FULL_BANNER,
                    //     listener:
                    //         (AdmobAdEvent event, Map<String, dynamic> map) {
                    //       print('BannerAd event is $event');
                    //       if (event == AdmobAdEvent.loaded) {
                    //         isSuccessfullyLoaded = true;
                    //       } else {
                    //         isSuccessfullyLoaded = false;
                    //       }
                    //       setState(() {});
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                          child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.basketList.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = provider.basketList.data.length;
                          widget.animationController.forward();
                          return BasketListItemView(
                              animationController: widget.animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: widget.animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              basket: provider.basketList.data[index],
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePaths.productDetail,
                                    arguments: ProductDetailIntentHolder(
                                      id: provider.basketList.data[index].id,
                                      qty: provider.basketList.data[index].qty,
                                      selectedColorId: provider.basketList
                                          .data[index].selectedColorId,
                                      selectedColorValue: provider.basketList
                                          .data[index].selectedColorValue,
                                      basketPrice: provider
                                          .basketList.data[index].basketPrice,
                                      basketSelectedAttributeList: provider
                                          .basketList
                                          .data[index]
                                          .basketSelectedAttributeList,
                                      product: provider
                                          .basketList.data[index].product,
                                      heroTagImage: '',
                                      heroTagTitle: '',
                                      heroTagOriginalPrice: '',
                                      heroTagUnitPrice: '',
                                    ));
                              },
                              onDeleteTap: () {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmDialogView(
                                          description: Utils.getString(context,
                                              'basket_list__confirm_dialog_description'),
                                          leftButtonText: Utils.getString(
                                              context,
                                              'basket_list__comfirm_dialog_cancel_button'),
                                          rightButtonText: Utils.getString(
                                              context,
                                              'basket_list__comfirm_dialog_ok_button'),
                                          onAgreeTap: () async {
                                            Navigator.of(context).pop();
                                            provider.deleteBasketByProduct(
                                                provider
                                                    .basketList.data[index]);
                                          });
                                    });
                              });
                        },
                      )),
                    ),
                    _CheckoutButtonWidget(provider: provider),
                  ],
                );
              } else {
                widget.animationController.forward();
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.animationController,
                        curve: const Interval(0.5 * 1, 1.0,
                            curve: Curves.fastOutSlowIn)));
                return AnimatedBuilder(
                  animation: widget.animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 100 * (1.0 - animation.value), 0.0),
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.only(
                                  bottom: PsDimens.space120),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/empty_basket.png',
                                    height: 150,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space32,
                                  ),
                                  Text(
                                    Utils.getString(context,
                                        'basket_list__empty_cart_title'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(),
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        Utils.getString(context,
                                            'basket_list__empty_cart_description'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(),
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }
            } else {
              return Container();
            }
          }),
        ));
  }
}

class _CheckoutButtonWidget extends StatelessWidget {
  const _CheckoutButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final BasketProvider provider;
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    int qty = 0;

    for (Basket basket in provider.basketList.data) {
      totalPrice += double.parse(basket.basketPrice) * double.parse(basket.qty);

      qty += int.parse(basket.qty);
    }

    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(PsDimens.space8),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          border: Border.all(color: PsColors.mainLightShadowColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(PsDimens.space12),
              topRight: Radius.circular(PsDimens.space12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 7.0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: PsDimens.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${Utils.getString(context, 'checkout__price')} ',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                Expanded(
                  child: Text(
                    '\$ ${Utils.getPriceFormat(totalPrice.toString())}',
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                Text(
                  '$qty  ${Utils.getString(context, 'checkout__items')}',
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
            const SizedBox(height: PsDimens.space8),
            Card(
              elevation: 0,
              color: PsColors.mainColor,
              shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(PsDimens.space8))),
              child: InkWell(
                onTap: () {
                  Utils.navigateOnUserVerificationView(provider, context,
                      () async {
                    await Navigator.pushNamed(
                        context, RoutePaths.checkout_container,
                        arguments: CheckoutIntentHolder(
                            publishKey: provider.psValueHolder.publishKey,
                            basketList: provider.basketList.data));
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        PsColors.mainColor,
                        PsColors.mainDarkColor,
                      ]),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(PsDimens.space12)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: PsColors.mainColorWithBlack.withOpacity(0.6),
                            offset: const Offset(0, 4),
                            blurRadius: 8.0,
                            spreadRadius: 3.0),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.payment, color: PsColors.white),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Text(
                          Utils.getString(
                              context, 'basket_list__checkout_button_name'),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: PsColors.white),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: PsDimens.space8),
          ],
        ));
  }
}
