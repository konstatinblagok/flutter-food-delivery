import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/shop.dart';

class ShopHorizontalListItem extends StatelessWidget {
  const ShopHorizontalListItem({
    Key key,
    @required this.shop,
    this.onTap,
  }) : super(key: key);

  final Shop shop;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 0.3,
          child: ClipPath(
            child: Container(
              width: PsDimens.space300,
              height: PsDimens.space180,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: shop.defaultPhoto,
                          width: double.infinity,
                          boxfit: BoxFit.cover,
                          onTap: () {
                            Utils.psPrint(shop.defaultPhoto.imgParentId);
                            onTap();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: PsDimens.space12,
                            top: PsDimens.space12,
                            right: PsDimens.space12,
                            bottom: PsDimens.space12),
                        child: Text(
                          shop.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.subhead,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        height: PsDimens.space56,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: PsDimens.space12,
                              right: PsDimens.space12,
                              bottom: PsDimens.space12),
                          child: Text(shop.description,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.body1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
          ),
        ));
  }
}
