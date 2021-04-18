import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/blog.dart';
import 'package:flutter/material.dart';

class BlogSliderView extends StatefulWidget {
  const BlogSliderView({
    Key key,
    @required this.blogList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<Blog> blogList;

  @override
  _BlogSliderState createState() => _BlogSliderState();
}

class _BlogSliderState extends State<BlogSliderView> {
  String _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.blogList != null && widget.blogList.isNotEmpty)
          CarouselSlider(
            enlargeCenterPage: true,
            // autoPlay: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 5),
            items: widget.blogList.map((Blog blog) {
              return Container(
                decoration: BoxDecoration(
                    color: PsColors.mainLightShadowColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(PsDimens.space4))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  child: blog.defaultPhoto.imgPath != null
                      ? PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: blog.defaultPhoto,
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          onTap: () {
                            widget.onTap(blog);
                          })
                      : Container(),
                ),
              );
            }).toList(),
            onPageChanged: (int i) {
              setState(() {
                _currentId = widget.blogList[i].id;
              });
            },
          )
        else
          Container(),

        // ),
        Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.blogList != null && widget.blogList.isNotEmpty
                  ? widget.blogList.map((Blog blog) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == blog.id
                                    ? PsColors.mainColor
                                    : PsColors.grey));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
