import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';

class ShopTagListItem extends StatelessWidget {
  const ShopTagListItem(
      {Key key,
      @required this.shopTag,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ShopTag shopTag;
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
                    child: Card(
                        elevation: 0.3,
                        child: Container(
                            child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: PsNetworkImage(
                                        photoKey: '',
                                        defaultPhoto: shopTag.defaultPhoto,
                                        width: PsDimens.space200,
                                        height: double.infinity,
                                        boxfit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: double.infinity,
                                      color: PsColors.black.withAlpha(130),
                                    )
                                  ],
                                )),
                            Text(
                              shopTag.name,
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(
                                      color: PsColors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            Container(
                                child: Positioned(
                              bottom: 10,
                              left: 10,
                              child: PsNetworkCircleIconImage(
                                photoKey: '',
                                defaultIcon: shopTag.defaultIcon,
                                width: PsDimens.space40,
                                height: PsDimens.space40,
                                boxfit: BoxFit.cover,
                                onTap: onTap,
                              ),
                            )),
                          ],
                        ))))),
          );
        });
  }
}

class CustomPolygon extends CustomPainter {
  CustomPolygon(this._topWidth, this._bottomWidth, this._height, this._color);

  final double _topWidth;
  final double _bottomWidth;
  final double _height;
  final Color _color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();

    path.addPolygon(<Offset>[
      Offset.zero,
      Offset(_topWidth, 0),
      Offset(_bottomWidth, _height),
      Offset(0, _height),
    ], true);

    path.arcToPoint(
      const Offset(10, 10),
      radius: const Radius.circular(30),
    );
    final Paint paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPolygon oldDelegate) {
    return false;
  }
}
