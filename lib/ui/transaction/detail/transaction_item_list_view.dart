import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_provider.dart';
import 'package:fluttermultistoreflutter/provider/transaction/transaction_detail_provider.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/repository/tansaction_detail_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/ui/transaction/detail/transaction_item_view.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_data_intent_holer.dart';
import 'package:fluttermultistoreflutter/viewobject/shop.dart';
import 'package:fluttermultistoreflutter/viewobject/transaction_header.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TransactionItemListView extends StatefulWidget {
  const TransactionItemListView({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  _TransactionItemListViewState createState() =>
      _TransactionItemListViewState();
}

class _TransactionItemListViewState extends State<TransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionDetailRepository repo1;
  ShopRepository shopRepository;
  TransactionDetailProvider _transactionDetailProvider;
  AnimationController animationController;
  Animation<double> animation;
  PsValueHolder valueHolder;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionDetailProvider
            .nextTransactionDetailList(widget.transaction);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<TransactionDetailRepository>(context);
    shopRepository = Provider.of<ShopRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: EasyLocalizationProvider(
            data: data,
            child: MultiProvider(
              providers: <SingleChildCloneableWidget>[
                ChangeNotifierProvider<TransactionDetailProvider>(
                  create: (BuildContext context) {
                    final TransactionDetailProvider provider =
                        TransactionDetailProvider(
                            repo: repo1, psValueHolder: valueHolder);
                    provider.loadTransactionDetailList(widget.transaction);
                    _transactionDetailProvider = provider;
                    return provider;
                  },
                ),
                ChangeNotifierProvider<ShopProvider>(
                    create: (BuildContext context) {
                  final ShopProvider provider =
                      ShopProvider(repo: shopRepository);
                  return provider;
                }),
              ],
              child: Consumer<TransactionDetailProvider>(builder:
                  (BuildContext context, TransactionDetailProvider provider,
                      Widget child) {
                return Scaffold(
                  key: scaffoldKey,
                  appBar: AppBar(
                    brightness: Utils.getBrightnessForAppBar(context),
                    iconTheme: Theme.of(context)
                        .iconTheme
                        .copyWith(color: PsColors.mainColorWithWhite),
                    title: Text(
                      Utils.getString(context, 'transaction_detail__title'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PsColors.mainColor),
                    ),
                    elevation: 0,
                  ),
                  body: Stack(children: <Widget>[
                    RefreshIndicator(
                      child: CustomScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: _TransactionNoWidget(
                                  transaction: widget.transaction,
                                  valueHolder: valueHolder,
                                  scaffoldKey: scaffoldKey),
                            ),
                            SliverToBoxAdapter(
                                child: _ItemWidget(
                              transaction: widget.transaction,
                            )),
                            SliverToBoxAdapter(
                              child: _AddressWidget(
                                transaction: widget.transaction,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (provider.transactionDetailList.data !=
                                          null ||
                                      provider.transactionDetailList.data
                                          .isNotEmpty) {
                                    final int count = provider
                                        .transactionDetailList.data.length;
                                    return TransactionItemView(
                                      animationController: animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      transaction: provider
                                          .transactionDetailList.data[index],
                                    );
                                  } else {
                                    return null;
                                  }
                                },
                                childCount:
                                    provider.transactionDetailList.data.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider
                            .resetTransactionDetailList(widget.transaction);
                      },
                    ),
                    PSProgressIndicator(provider.transactionDetailList.status)
                  ]),
                );
              }),
            )));
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    @required this.valueHolder,
    this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(height: PsDimens.space2);
    final Widget _contentCopyIconWidget = IconButton(
      iconSize: PsDimens.space20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: transaction.transCode));
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Tooltip(
            message: Utils.getString(context, 'transaction_detail__copy'),
            child: Text(
              Utils.getString(context, 'transaction_detail__copied_data'),
              style: Theme.of(context).textTheme.title.copyWith(
                    color: PsColors.mainColor,
                  ),
            ),
            showDuration: const Duration(seconds: 5),
          ),
        ));
      },
    );
    return Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Icon(
                          Icons.offline_pin,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Expanded(
                          child: Text(
                              '${Utils.getString(context, 'transaction_detail__trans_no')} : ${transaction.transCode}',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.subhead),
                        ),
                      ],
                    ),
                  ),
                  _contentCopyIconWidget,
                ],
              ),
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText: transaction.totalItemCount,
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_count')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.totalItemAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.discountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.discountAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__discount')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.cuponDiscountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.cuponDiscountAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__coupon_discount')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.subTotalAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.taxAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__tax')}(${valueHolder.overAllTaxLabel} %) :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.shippingMethodAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_cost')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.shippingAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_tax')}(${valueHolder.shippingTaxLabel} %) :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.balanceAmount)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
          ],
        ));
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
    Key key,
    @required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ?? '-',
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Divider(
      height: PsDimens.space2,
      color: PsColors.grey,
    );
    return Card(
        elevation: 0.3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.loyalty,
                  ),
                  const SizedBox(
                    width: PsDimens.space16,
                  ),
                  Expanded(
                    child: Text(
                      Utils.getString(context, 'transaction_detail__shop') ??
                          '-',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                ],
              ),
            ),
            _dividerWidget,
            const SizedBox(
              height: PsDimens.space12,
            ),
            ImageAndTextWidget(
              data: transaction.shop,
            ),
            // const SizedBox(
            //   height: PsDimens.space12,
            // ),
          ],
        ));
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Shop data;
  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      width: 100,
      height: 100,
      boxfit: BoxFit.cover,
      onTap: () {
        shopProvider.replaceShop(data.id, data.name);
        Navigator.pushNamed(context, RoutePaths.home,
            arguments:
                ShopDataIntentHolder(shopId: data.id, shopName: data.name));
      },
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      child: InkWell(
        onTap: () {
          shopProvider.replaceShop(data.id, data.name);
          Navigator.pushNamed(context, RoutePaths.home,
              arguments:
                  ShopDataIntentHolder(shopId: data.id, shopName: data.name));
        },
        child: Row(
          children: <Widget>[
            _imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.name, style: Theme.of(context).textTheme.subhead),
                  _spacingWidget,
                  Text(data.aboutPhone1,
                      style: Theme.of(context).textTheme.body1),
                  _spacingWidget,
                  Text(data.status, style: Theme.of(context).textTheme.body1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(height: PsDimens.space2);

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space12,
    );

    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.all(16.0);
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString(
                        context, 'transaction_detail__shipping_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingPhone,
              title: Utils.getString(context, 'transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingEmail,
              title: Utils.getString(context, 'transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingAddress1,
              title: Utils.getString(context, 'transaction_detail__address'),
            ),
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings_backup_restore,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString(
                        context, 'transaction_detail__billing_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            _TextWidgetForAddress(
              addressInfoText: transaction.billingPhone,
              title: Utils.getString(context, 'transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingEmail,
              title: Utils.getString(context, 'transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingAddress1,
              title: Utils.getString(context, 'transaction_detail__address'),
            ),
            const SizedBox(
              height: PsDimens.space8,
            )
          ],
        ));
  }
}

class _TextWidgetForAddress extends StatelessWidget {
  const _TextWidgetForAddress({
    Key key,
    @required this.addressInfoText,
    this.title,
  }) : super(key: key);

  final String addressInfoText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PsDimens.space8),
      padding: const EdgeInsets.only(
          left: PsDimens.space12, right: PsDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.body1,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16, top: PsDimens.space8),
              child: Text(
                addressInfoText,
                style: Theme.of(context).textTheme.body1,
              ))
        ],
      ),
    );
  }
}
