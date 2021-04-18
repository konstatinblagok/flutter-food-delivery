import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/transaction_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    this.animationController,
    this.animation,
    this.onTap,
    @required this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    if (transaction != null && transaction.transCode != null) {
      return AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    color: PsColors.backgroundColor,
                    margin: const EdgeInsets.only(top: PsDimens.space8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _TransactionNoWidget(
                          transaction: transaction,
                          scaffoldKey: scaffoldKey,
                        ),
                        const Divider(
                          height: PsDimens.space1,
                        ),
                        _TransactionTextWidget(
                          transaction: transaction,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key key,
    @required this.transaction,
    @required this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      'Transaction No : ${transaction.transCode}' ?? '-',
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.subtitle,
    );

    final Widget _iconWidget = Icon(
      Icons.offline_pin,
      size: 24,
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space4,
          top: PsDimens.space4,
          bottom: PsDimens.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _iconWidget,
              const SizedBox(
                width: PsDimens.space8,
              ),
              _textWidget,
            ],
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            iconSize: 24,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: transaction.transCode));
              scaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).iconTheme.color,
                content: Tooltip(
                  message: Utils.getString(context, 'transaction_detail__copy'),
                  child: Text(
                    Utils.getString(context, 'transaction_detail__copied_data'),
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: PsColors.mainColor),
                  ),
                  showDuration: const Duration(seconds: 5),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionTextWidget extends StatelessWidget {
  const _TransactionTextWidget({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.only(
      left: PsDimens.space16,
      right: PsDimens.space16,
      top: PsDimens.space8,
    );

    final Widget _totalAmountTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_list__total_amount'),
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.balanceAmount)}' ??
              '-',
          style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.normal, color: PsColors.mainColor),
        )
      ],
    );

    final Widget _shopNameWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_detail__shop'),
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          transaction.shop.name ?? '-',
          style: Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.normal, color: PsColors.mainColor),
        )
      ],
    );

    final Widget _statusTextWidget = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          Utils.getString(context, 'transaction_detail__status'),
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          transaction.transStatusTitle ?? '-',
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(fontWeight: FontWeight.normal),
        )
      ],
    );

    final Widget _viewDetailTextWidget = Text(
      Utils.getString(context, 'transaction_detail__view_details'),
      style: Theme.of(context)
          .textTheme
          .body1
          .copyWith(fontWeight: FontWeight.normal),
      // textAlign: TextAlign.left,
    );
    if (transaction != null && transaction.transCode != null) {
      return Column(
        children: <Widget>[
          Padding(padding: _paddingEdgeInsetWidget, child: _shopNameWidget),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _totalAmountTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: _statusTextWidget,
          ),
          Padding(
            padding: _paddingEdgeInsetWidget,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _viewDetailTextWidget,
              ],
            ),
          ),
          const SizedBox(
            height: PsDimens.space8,
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
