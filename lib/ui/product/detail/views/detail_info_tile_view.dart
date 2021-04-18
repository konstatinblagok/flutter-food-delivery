import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/product/product_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_expansion_tile.dart';
import 'package:fluttermultistoreflutter/ui/product/detail/views/color_list_item_view.dart';
import 'package:fluttermultistoreflutter/ui/product/specification/product_specification_list_item.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/product.dart';

class DetailInfoTileView extends StatelessWidget {
  const DetailInfoTileView({
    Key key,
    @required this.productDetail,
  }) : super(key: key);

  final ProductDetailProvider productDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'detail_info_tile__detail_info'),
        style: Theme.of(context).textTheme.subhead);
    if (productDetail != null &&
        productDetail.productDetail != null &&
        productDetail.productDetail.data != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'detail_info_tile__product_name'),
                    style: Theme.of(context).textTheme.body2,
                  ),
                 
                ],
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

class _ColorsWidget extends StatefulWidget {
  const _ColorsWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  __ColorsWidgetState createState() => __ColorsWidgetState();
}

class __ColorsWidgetState extends State<_ColorsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ProductSpecificationWidget extends StatefulWidget {
  const _ProductSpecificationWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;
  @override
  __ProductSpecificationWidgetState createState() =>
      __ProductSpecificationWidgetState();
}

class __ProductSpecificationWidgetState
    extends State<_ProductSpecificationWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.product.itemSpecList.isNotEmpty &&
        widget.product.itemSpecList[0].id != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: PsDimens.space20,
          ),
          Text(
            Utils.getString(context, 'detail_info_tile__detail_info'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: Theme.of(context).textTheme.body2,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.product.itemSpecList.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductSpecificationListItem(
                productSpecification: widget.product.itemSpecList[index],
              );
            },
          ),
          const SizedBox(
            height: PsDimens.space4,
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
