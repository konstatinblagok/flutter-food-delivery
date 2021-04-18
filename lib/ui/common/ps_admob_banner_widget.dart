import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';

class PsAdMobBannerWidget extends StatefulWidget {
  const PsAdMobBannerWidget({this.admobBannerSize});

  final AdmobBannerSize admobBannerSize;

  @override
  _PsAdMobBannerWidgetState createState() => _PsAdMobBannerWidgetState();
}

class _PsAdMobBannerWidgetState extends State<PsAdMobBannerWidget> {
  bool isShouldLoadAdMobBanner = true;
  bool isConnectedToInternet = false;
  int currentRetry = 0;
  int retryLimit = 1;

  Widget _admobBannerWidget = Container();

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    if (isShouldLoadAdMobBanner && isConnectedToInternet) {
      print('**** creating admob banner!!!');
      _admobBannerWidget = Visibility(
        visible: PsConfig.showAdMob &&
            isShouldLoadAdMobBanner &&
            isConnectedToInternet,
        child: AdmobBanner(
          adUnitId: Utils.getBannerAdUnitId(),
          adSize: widget.admobBannerSize ?? AdmobBannerSize.FULL_BANNER,
          listener: (AdmobAdEvent event, Map<String, dynamic> map) {
            print('BannerAd event is $event');
            if (event == AdmobAdEvent.loaded) {
              isShouldLoadAdMobBanner = false;
            } else {
              if (currentRetry < retryLimit) {
                isShouldLoadAdMobBanner = false;
                currentRetry++;
                _admobBannerWidget = Container();
                setState(() {});
              }
            }
          },
        ),
      );
      isShouldLoadAdMobBanner = false;
    }

    return _admobBannerWidget;
  }
}
