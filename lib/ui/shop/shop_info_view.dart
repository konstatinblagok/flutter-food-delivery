import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/provider/shop_info/shop_info_provider.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/default_photo.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_button_widget.dart';
class ShopInfoView extends StatefulWidget {
  const ShopInfoView({Key key, this.animationController, this.animation})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ShopInfoViewState createState() => _ShopInfoViewState();
}

class _ShopInfoViewState extends State<ShopInfoView> {
  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    return SliverToBoxAdapter(
      child: Consumer<ShopInfoProvider>(
        builder:
            (BuildContext context, ShopInfoProvider provider, Widget child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              builder: (BuildContext context, Widget child) {
                return FadeTransition(
                    opacity: widget.animation,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 30 * (1.0 - widget.animation.value), 0.0),
                        child: provider.shopInfo != null &&
                                provider.shopInfo.data != null
                            ? _ShopInfoViewWidget(
                                widget: widget, provider: provider)
                            : Container()));
              });
        },
      ),
    );
  }
}

class _ShopInfoViewWidget extends StatefulWidget {
  const _ShopInfoViewWidget({
    Key key,
    @required this.widget,
    @required this.provider,
  }) : super(key: key);

  final ShopInfoView widget;
  final ShopInfoProvider provider;

  @override
  __ShopInfoViewWidgetState createState() => __ShopInfoViewWidgetState();
}

class __ShopInfoViewWidgetState extends State<_ShopInfoViewWidget> {
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
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Column(
          children: <Widget>[
            const PsAdMobBannerWidget(),
            // Visibility(
            //   visible:
            //       PsConst.SHOW_ADMOB && isSuccessfullyLoaded && isConnectedToInternet,
            //   child: AdmobBanner(
            //     adUnitId: Utils.getBannerAdUnitId(),
            //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
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
           
            Container(
              color: PsColors.coreBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                    ImageAndTextWidget(
                    data: widget.provider.shopInfo.data ?? '',
                  ),
                _DescriptionWidget(
                    data: widget.provider.shopInfo.data,
                  ),
                  const SizedBox(
                    height: PsDimens.space32,
                  ),
                  Container(
                      color: PsColors.backgroundColor,
                      padding: const EdgeInsets.only(
                          left: PsDimens.space16, right: PsDimens.space16),
                      child: Text(
                          Utils.getString(context, 'What does it include?'),
                          style: Theme.of(context).textTheme.subhead)),
                  
                  _LinkAndTitle(
                      icon: FontAwesome.check,
                      title: Utils.getString(
                          context, 'Free Milk'),
                      link: ''),
                  _LinkAndTitle(
                      icon: FontAwesome.check,
                      title: Utils.getString(context, 'Free Bread'),
                      link: ''),
                  _LinkAndTitle(
                      icon: FontAwesome.check,
                      title: Utils.getString(context, 'Free Butter'),
                      link: ''),
                  Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
          child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'Purchase Membership'),
            onPressed: () async {
            
            },
          ),
        ),
            
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _LinkAndTitle extends StatelessWidget {
  const _LinkAndTitle({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.link,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                      width: PsDimens.space20,
                      height: PsDimens.space20,
                      child: Icon(
                        icon,
                      )),
                  const SizedBox(
                    width: PsDimens.space12,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.body2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: PsDimens.space32,
                  ),
                  InkWell(
                    child: Text(
                        link == ''
                            ? Utils.getString(context, 'shop_info__dash')
                            : link,
                        style: Theme.of(context).textTheme.body1),
                    onTap: () async {
                      if (await canLaunch(link)) {
                        await launch(link);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _HeaderImageWidget extends StatelessWidget {
  const _HeaderImageWidget({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final DefaultPhoto photo;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PsNetworkImage(
          photoKey: '',
          defaultPhoto: photo ?? '',
          width: double.infinity,
          height: 300,
          boxfit: BoxFit.cover,
          onTap: () {},
        ),
      ],
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    final Widget _imageWidget = PsNetworkImage(
      photoKey: '',
      defaultPhoto: data.defaultPhoto,
      width: 50,
      height: 50,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16),
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
                    "Rs 4000/month Membership",
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          color: PsColors.mainColor,
                        ),
                  ),
                  _spacingWidget,
                
                ],
              ),
            )
          ],
        ));
  }
}

class _PhoneAndContactWidget extends StatelessWidget {
  const _PhoneAndContactWidget({
    Key key,
    @required this.phone,
  }) : super(key: key);

  final ShopInfo phone;
  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space16),
        padding: const EdgeInsets.only(
            left: PsDimens.space16, right: PsDimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _spacingWidget,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: PsDimens.space20,
                    height: PsDimens.space20,
                    child: Icon(
                      Icons.phone_in_talk,
                    )),
                const SizedBox(
                  width: PsDimens.space12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'shop_info__phone'),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    _spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone1,
                        style: Theme.of(context).textTheme.body1.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunch('tel://${phone.aboutPhone1}')) {
                          await launch('tel://${phone.aboutPhone1}');
                        } else {
                          throw 'Could not Call Phone Number 1';
                        }
                      },
                    ),
                    _spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone2,
                        style: Theme.of(context).textTheme.body1.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunch('tel://${phone.aboutPhone2}')) {
                          await launch('tel://${phone.aboutPhone2}');
                        } else {
                          throw 'Could not Call Phone Number 2';
                        }
                      },
                    ),
                    _spacingWidget,
                    InkWell(
                      child: Text(
                        phone.aboutPhone3,
                        style: Theme.of(context).textTheme.body1.copyWith(),
                      ),
                      onTap: () async {
                        if (await canLaunch('tel://${phone.aboutPhone3}')) {
                          await launch('tel://${phone.aboutPhone3}');
                        } else {
                          throw 'Could not Call Phone Number 3';
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            _spacingWidget,
          ],
        ));
  }
}

class _SourceAddressWidget extends StatelessWidget {
  const _SourceAddressWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final ShopInfo data;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(Utils.getString(context, 'shop_info__source_address')),
              ],
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                ),
                _AddressWidget(icon: Icons.location_on, title: data.address1),
                _AddressWidget(icon: Icons.location_on, title: data.address2),
                _AddressWidget(icon: Icons.location_on, title: data.address3),
                const SizedBox(
                  height: PsDimens.space12,
                ),
              ],
            )
          ],
        ));
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space16,
        ),
        if (title != '')
          Row(
            children: <Widget>[
              Container(
                  width: PsDimens.space20,
                  height: PsDimens.space20,
                  child: Icon(
                    icon,
                  )),
              const SizedBox(
                width: PsDimens.space8,
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          )
        else
          Row(
            children: <Widget>[
              Container(
                  width: PsDimens.space20,
                  height: PsDimens.space20,
                  child: Icon(
                    icon,
                  )),
              const SizedBox(
                width: PsDimens.space8,
              ),
              Text(
                '-',
                style: Theme.of(context).textTheme.body1,
              ),
            ],
          )
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key key, this.data}) : super(key: key);

  final ShopInfo data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "For 4000 Rs a month enjoy the privilages of our membership",
                style: Theme.of(context).textTheme.body1.copyWith(height: 1.3),
              ),
            )
          ],
        ));
  }
}
