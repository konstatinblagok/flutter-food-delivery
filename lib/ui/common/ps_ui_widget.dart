import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_hero.dart';
import 'package:fluttermultistoreflutter/viewobject/default_icon.dart';
import 'package:fluttermultistoreflutter/viewobject/default_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PsNetworkImage extends StatelessWidget {
  const PsNetworkImage(
      {Key key,
      @required this.photoKey,
      @required this.defaultPhoto,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final DefaultPhoto defaultPhoto;

  @override
  Widget build(BuildContext context) {
    if (defaultPhoto.imgPath == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      print(
          'tag : $photoKey${PsConfig.ps_app_image_url}${defaultPhoto.imgPath}');
      return PsHero(
        transitionOnUserGestures: true,
        tag: photoKey,
        child: GestureDetector(
          onTap: onTap,
          child: CachedNetworkImage(
            placeholder: (BuildContext context, String url) {
              return CachedNetworkImage(
                width: width,
                height: height,
                fit: boxfit,
                placeholder: (BuildContext context, String url) {
                  return Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  );
                },
                imageUrl:
                    '${PsConfig.ps_app_image_thumbs_url}${defaultPhoto.imgPath}',
              );
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: '${PsConfig.ps_app_image_url}${defaultPhoto.imgPath}',
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        ),
      );
    }
  }
}

class PsNetworkImageWithUrl extends StatelessWidget {
  const PsNetworkImageWithUrl(
      {Key key,
      @required this.photoKey,
      @required this.imagePath,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath == '') {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      if (photoKey == '') {
        return GestureDetector(
          onTap: onTap,
          child: CachedNetworkImage(
            placeholder: (BuildContext context, String url) {
              return CachedNetworkImage(
                width: width,
                height: height,
                fit: boxfit,
                placeholder: (BuildContext context, String url) {
                  return Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  );
                },
                imageUrl: '${PsConfig.ps_app_image_thumbs_url}$imagePath',
              );
            },
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: '${PsConfig.ps_app_image_url}$imagePath',
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: onTap,
          child: CachedNetworkImage(
            placeholder: (BuildContext context, String url) =>
                CachedNetworkImage(
              width: width,
              height: height,
              fit: boxfit,
              placeholder: (BuildContext context, String url) {
                return Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                );
              },
              imageUrl: '${PsConfig.ps_app_image_thumbs_url}$imagePath',
            ),
            width: width,
            height: height,
            fit: boxfit,
            imageUrl: '${PsConfig.ps_app_image_url}$imagePath',
            errorWidget: (BuildContext context, String url, Object error) =>
                Image.asset(
              'assets/images/placeholder_image.png',
              width: width,
              height: height,
              fit: boxfit,
            ),
          ),
        );
      }
    }
  }
}

class PsFileImage extends StatelessWidget {
  const PsFileImage(
      {Key key,
      @required this.photoKey,
      @required this.file,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final File file;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'assets/images/placeholder_image.png',
            width: width,
            height: height,
            fit: boxfit,
          ));
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: Image(
              image: FileImage(file),
            ));
      } else {
        return GestureDetector(
            onTap: onTap,
            child: Image(
              image: FileImage(file),
            ));
      }
    }
  }
}

class PsNetworkCircleImage extends StatelessWidget {
  const PsNetworkCircleImage(
      {Key key,
      @required this.photoKey,
      this.imagePath,
      this.asset,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final String imagePath;
  final String asset;

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath == '') {
      if (asset == null || asset == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                )));
      } else {
        print('I Key : $photoKey$asset');
        print('');
        return GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: '$photoKey$asset',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(asset,
                    width: width, height: height, fit: boxfit),
              ),
            ));
      }
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                placeholder: (BuildContext context, String url) {
                  return CachedNetworkImage(
                    width: width,
                    height: height,
                    fit: boxfit,
                    placeholder: (BuildContext context, String url) {
                      return Image.asset(
                        'assets/images/placeholder_image.png',
                        width: width,
                        height: height,
                        fit: boxfit,
                      );
                    },
                    imageUrl: '${PsConfig.ps_app_image_thumbs_url}$imagePath',
                  );
                },
                width: width,
                height: height,
                fit: boxfit,
                imageUrl: '${PsConfig.ps_app_image_url}$imagePath',
                errorWidget: (BuildContext context, String url, Object error) =>
                    Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                ),
              ),
            ));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: '$photoKey$imagePath',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CachedNetworkImage(
                  placeholder: (BuildContext context, String url) =>
                      CachedNetworkImage(
                    width: width,
                    height: height,
                    fit: boxfit,
                    placeholder: (BuildContext context, String url) {
                      return Image.asset(
                        'assets/images/placeholder_image.png',
                        width: width,
                        height: height,
                        fit: boxfit,
                      );
                    },
                    imageUrl: '${PsConfig.ps_app_image_thumbs_url}$imagePath',
                  ),
                  width: width,
                  height: height,
                  fit: boxfit,
                  imageUrl: '${PsConfig.ps_app_image_url}$imagePath',
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  ),
                ),
              )),
        );
      }
    }
  }
}

class PsFileCircleImage extends StatelessWidget {
  const PsFileCircleImage(
      {Key key,
      @required this.photoKey,
      this.file,
      this.asset,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final File file;
  final String asset;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      if (asset == null || asset == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Container(
                    width: width, height: height, child: Icon(Icons.image))));
      } else {
        print('I Key : $photoKey$asset');
        print('');
        return GestureDetector(
            onTap: onTap,
            child: Hero(
              tag: '$photoKey$asset',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image.asset(asset,
                    width: width, height: height, fit: boxfit),
              ),
            ));
      }
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: Image(
                  image: FileImage(file),
                )));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag: file,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10000.0),
                  child: Image(image: FileImage(file)))),
        );
      }
    }
  }
}

class PSProgressIndicator extends StatefulWidget {
  const PSProgressIndicator(this._status);
  final PsStatus _status;

  @override
  _PSProgressIndicator createState() => _PSProgressIndicator();
}

class _PSProgressIndicator extends State<PSProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: widget._status == PsStatus.PROGRESS_LOADING ? 1.0 : 0.0,
          child: const LinearProgressIndicator(),
        ),
      ),
    );
  }
}

class PsNetworkCircleIconImage extends StatelessWidget {
  const PsNetworkCircleIconImage(
      {Key key,
      @required this.photoKey,
      @required this.defaultIcon,
      this.width,
      this.height,
      this.onTap,
      this.boxfit = BoxFit.cover})
      : super(key: key);

  final double width;
  final double height;
  final Function onTap;
  final String photoKey;
  final BoxFit boxfit;
  final DefaultIcon defaultIcon;

  @override
  Widget build(BuildContext context) {
    if (defaultIcon.imgPath == '') {
      return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: Image.asset(
                'assets/images/placeholder_image.png',
                width: width,
                height: height,
                fit: boxfit,
              )));
    } else {
      if (photoKey == '') {
        return GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CachedNetworkImage(
                placeholder: (BuildContext context, String url) =>
                    CachedNetworkImage(
                  width: width,
                  height: height,
                  fit: boxfit,
                  placeholder: (BuildContext context, String url) {
                    return Image.asset(
                      'assets/images/placeholder_image.png',
                      width: width,
                      height: height,
                      fit: boxfit,
                    );
                  },
                  imageUrl:
                      '${PsConfig.ps_app_image_thumbs_url}${defaultIcon.imgPath}',
                ),
                width: width,
                height: height,
                fit: boxfit,
                imageUrl: '${PsConfig.ps_app_image_url}${defaultIcon.imgPath}',
                errorWidget: (BuildContext context, String url, Object error) =>
                    Image.asset(
                  'assets/images/placeholder_image.png',
                  width: width,
                  height: height,
                  fit: boxfit,
                ),
              ),
            ));
      } else {
        return GestureDetector(
          onTap: onTap,
          child: Hero(
              tag:
                  '$photoKey${PsConfig.ps_app_image_url}${defaultIcon.imgPath}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CachedNetworkImage(
                  placeholder: (BuildContext context, String url) =>
                      CachedNetworkImage(
                    width: width,
                    height: height,
                    fit: boxfit,
                    placeholder: (BuildContext context, String url) {
                      return Image.asset(
                        'assets/images/placeholder_image.png',
                        width: width,
                        height: height,
                        fit: boxfit,
                      );
                    },
                    imageUrl:
                        '${PsConfig.ps_app_image_thumbs_url}${defaultIcon.imgPath}',
                  ),
                  width: width,
                  height: height,
                  fit: boxfit,
                  imageUrl:
                      '${PsConfig.ps_app_image_url}${defaultIcon.imgPath}',
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Image.asset(
                    'assets/images/placeholder_image.png',
                    width: width,
                    height: height,
                    fit: boxfit,
                  ),
                ),
              )),
        );
      }
    }
  }
}
