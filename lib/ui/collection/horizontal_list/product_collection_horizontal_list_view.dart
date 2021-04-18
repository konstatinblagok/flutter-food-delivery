import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/productcollection/product_collection_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultistoreflutter/ui/product/item/product_horizontal_list_item.dart';
import 'package:fluttermultistoreflutter/viewobject/product_collection_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductCollectionHorizontalListView extends StatelessWidget {
  const ProductCollectionHorizontalListView({
    Key key,
    @required this.product,
    this.onTap,
  }) : super(key: key);

  final ProductCollectionHeader product;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductCollectionProvider>(builder: (BuildContext context,
        ProductCollectionProvider productProvider, Widget child) {
      return Container(
          height: PsDimens.space300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: product.productList.length,
              itemBuilder: (BuildContext context, int index) {
                if (productProvider.productCollectionList.status ==
                    PsStatus.BLOCK_LOADING) {
                  return Shimmer.fromColors(
                      baseColor: PsColors.grey,
                      highlightColor: PsColors.white,
                      child: Row(children: const <Widget>[
                        PsFrameUIForLoading(),
                      ]));
                } else {
                  return ProductHorizontalListItem(
                    coreTagKey: product.hashCode.toString() +
                        product.productList[index].id,
                    product: product.productList[index],
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.productDetail,
                          arguments: product.productList[index]);
                    },
                  );
                }
              }));
    });
  }
}
