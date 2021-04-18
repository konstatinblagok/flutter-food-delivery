import 'dart:async';

import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/shop/shop_provider.dart';
import 'package:fluttermultistoreflutter/repository/shop_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/blog.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/intent_holder/shop_data_intent_holer.dart';
import 'package:fluttermultistoreflutter/viewobject/shop.dart';
import 'package:provider/provider.dart';

class BlogView extends StatefulWidget {
  const BlogView({Key key, @required this.blog, @required this.heroTagImage})
      : super(key: key);

  final Blog blog;
  final String heroTagImage;

  @override
  _BlogViewState createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isReadyToShowAppBarIcons = false;
  ShopRepository shopRepository;
  @override
  Widget build(BuildContext context) {
    shopRepository = Provider.of<ShopRepository>(context);

    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }

    return ChangeNotifierProvider<ShopProvider>(
        create: (BuildContext context) {
          final ShopProvider provider = ShopProvider(repo: shopRepository);
          return provider;
        },
        child: Scaffold(
            body: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              brightness: Utils.getBrightnessForAppBar(context),
              expandedHeight: PsDimens.space300,
              floating: true,
              pinned: true,
              snap: false,
              elevation: 0,
              leading: PsBackButtonWithCircleBgWidget(
                  isReadyToShow: isReadyToShowAppBarIcons),
              backgroundColor: PsColors.mainColor,
              flexibleSpace: FlexibleSpaceBar(
                background: PsNetworkImage(
                  photoKey: widget.heroTagImage,
                  height: PsDimens.space300,
                  width: double.infinity,
                  defaultPhoto: widget.blog.defaultPhoto,
                  boxfit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TextWidget(
                blog: widget.blog,
              ),
            ),
            SliverToBoxAdapter(
                child: ImageAndTextWidget(
              data: widget.blog.shop,
            ))
          ],
        )));
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConst.SHOW_ADMOB) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConst.SHOW_ADMOB) {
      print('loading ads....');
      checkConnection();
    }
    return Container(
      color: PsColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(PsDimens.space12),
            child: Text(
              widget.blog.name,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space12,
                right: PsDimens.space12,
                bottom: PsDimens.space12),
            child: Text(
              widget.blog.description,
              style: Theme.of(context).textTheme.body1.copyWith(height: 1.5),
            ),
          ),
          const PsAdMobBannerWidget(),
          // Visibility(
          //   visible:
          //       PsConst.SHOW_ADMOB && isSuccessfullyLoaded && isConnectedToInternet,
          //   child: AdmobBanner(
          //     adUnitId: Utils.getBannerAdUnitId(),
          //     adSize: AdmobBannerSize.FULL_BANNER,
          //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
          //       print('BannerAd event is $event');
          //       if (event == AdmobAdEvent.loaded) {
          //         isSuccessfullyLoaded = true;
          //       } else {
          //         isSuccessfullyLoaded = false;
          //         setState(() {});
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Shop data;
  @override
  Widget build(BuildContext context) {
    final ShopProvider shopProvider = Provider.of<ShopProvider>(context);
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      width: 100,
      height: 100,
      boxfit: BoxFit.cover,
      onTap: () {
        shopProvider.replaceShop(data.id, data.name);
        Navigator.pushNamed(context, RoutePaths.home,
            arguments:
                ShopDataIntentHolder(shopId: data.id, shopName: data.name));
      },
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      child: InkWell(
        onTap: () {
          shopProvider.replaceShop(data.id, data.name);
          Navigator.pushNamed(context, RoutePaths.home,
              arguments:
                  ShopDataIntentHolder(shopId: data.id, shopName: data.name));
        },
        child: Row(
          children: <Widget>[
            _imageWidget,
            const SizedBox(
              width: PsDimens.space12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          color: PsColors.mainColor,
                        ),
                  ),
                  _spacingWidget,
                  Text(
                    data.aboutPhone1,
                    style: Theme.of(context).textTheme.body1.copyWith(),
                  ),
                  _spacingWidget,
                  Row(
                    children: <Widget>[
                      Container(
                          child: Icon(
                        Icons.email,
                      )),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Text(data.email,
                          style: Theme.of(context).textTheme.body1.copyWith()),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
