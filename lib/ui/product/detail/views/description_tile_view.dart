import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';
import 'package:flutter/material.dart';

class DescriptionTileView extends StatelessWidget {
  const DescriptionTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'description_tile__product_description'),
        style: Theme.of(context).textTheme.subhead);
    if (productDetail != null && productDetail.description != null) {
      return Container(
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Text(
                productDetail.description ?? '',
                style: Theme.of(context).textTheme.body1.copyWith(
                      height: 1.3,
                      letterSpacing: 0.5,
                    ),
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}
