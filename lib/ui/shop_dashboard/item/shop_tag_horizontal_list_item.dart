import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';

class ShopTagHorizontalListItem extends StatelessWidget {
  const ShopTagHorizontalListItem({
    Key key,
    @required this.shopTag,
    this.onTap,
  }) : super(key: key);

  final ShopTag shopTag;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: PsColors.transparent,
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space4, vertical: PsDimens.space4),
          child: Container(
            width: PsDimens.space84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PsNetworkCircleIconImage(
                  photoKey: '',
                  defaultIcon: shopTag.defaultIcon,
                  width: PsDimens.space64,
                  height: PsDimens.space64,
                  boxfit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Text(
                  shopTag.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }
}
