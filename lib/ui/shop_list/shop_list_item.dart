import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopListItem extends StatelessWidget {
  const ShopListItem(
      {Key key,
      @required this.shop,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Shop shop;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
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
                          margin: const EdgeInsets.all(PsDimens.space8),
                          child: ShopListItemWidget(shop: shop)))));
        });
  }
}

class ShopListItemWidget extends StatelessWidget {
  const ShopListItemWidget({
    Key key,
    @required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(PsDimens.space4),
          child: PsNetworkImage(
            height: PsDimens.space200,
            width: double.infinity,
            photoKey: '',
            defaultPhoto: shop.defaultPhoto,
            boxfit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: PsDimens.space8,
              right: PsDimens.space8,
              top: PsDimens.space12),
          child: Text(
            shop.name,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: PsDimens.space4,
              bottom: PsDimens.space12,
              left: PsDimens.space8,
              right: PsDimens.space8),
          child: Text(
            shop.description,
            maxLines: 4,
            style: Theme.of(context).textTheme.body1.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
