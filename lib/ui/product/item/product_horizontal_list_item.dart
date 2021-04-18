import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_hero.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';

class ProductHorizontalListItem extends StatelessWidget {
  const ProductHorizontalListItem({
    Key key,
    @required this.product,
    @required this.coreTagKey,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: PsColors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: PsDimens.space4, vertical: PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
            ),
            width: PsDimens.space180,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(PsDimens.space8)),
                        ),
                        child: ClipPath(
                          child: PsNetworkImage(
                            photoKey: '$coreTagKey$PsConst.HERO_TAG__IMAGE',
                            defaultPhoto: product.defaultPhoto,
                            width: PsDimens.space180,
                            height: double.infinity,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto.imgParentId);
                              onTap();
                            },
                          ),
                          clipper: const ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(PsDimens.space8),
                                      topRight:
                                          Radius.circular(PsDimens.space8)))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space12,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4),
                      child: PsHero(
                        tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body2,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space4,
                          right: PsDimens.space8),
                      child: Row(
                        children: <Widget>[
                          PsHero(
                              tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                              flightShuttleBuilder: Utils.flightShuttleBuilder,
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(
                                    '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice)}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subhead
                                        .copyWith(color: PsColors.mainColor)),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: product.isDiscount == PsConst.ONE
                                  ? PsHero(
                                      tag:
                                          '$coreTagKey$PsConst.HERO_TAG__ORIGINAL_PRICE',
                                      flightShuttleBuilder:
                                          Utils.flightShuttleBuilder,
                                      child: Material(
                                          color: PsColors.transparent,
                                          child: Text(
                                              '${product.currencySymbol}${Utils.getPriceFormat(product.originalPrice)}',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                      decoration: TextDecoration
                                                          .lineThrough))))
                                  : Container()),
                        ],
                      ),
                    ),
                  
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: product.isDiscount == PsConst.ONE
                            ? Container(
                                width: PsDimens.space52,
                                height: PsDimens.space24,
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                        'assets/images/baseline_percent_tag_orange_24.png',
                                        matchTextDirection: true,
                                        color: PsColors.mainColor),
                                    Center(
                                      child: Text(
                                        '-${product.discountPercent}%',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body1
                                            .copyWith(color: PsColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()),
                    Padding(
                      padding: const EdgeInsets.all(PsDimens.space4),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: product.isFeatured == PsConst.ONE
                              ? Image.asset(
                                  'assets/images/baseline_feature_circle_24.png',
                                  width: PsDimens.space32,
                                  height: PsDimens.space32,
                                  alignment: Alignment.topLeft,
                                )
                              : Container()),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
