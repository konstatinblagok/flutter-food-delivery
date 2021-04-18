import 'package:admob_flutter/admob_flutter.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_admob_banner_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_dropdown_base_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/common/language.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/constant/route_paths.dart';
import 'package:fluttermultistoreflutter/provider/language/language_provider.dart';
import 'package:fluttermultistoreflutter/repository/language_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';

class LanguageSettingView extends StatefulWidget {
  const LanguageSettingView(
      {Key key,
      @required this.animationController,
      @required this.languageIsChanged})
      : super(key: key);
  final AnimationController animationController;
  final Function languageIsChanged;
  @override
  _LanguageSettingViewState createState() => _LanguageSettingViewState();
}

class _LanguageSettingViewState extends State<LanguageSettingView> {
  String currentLang = '';
  LanguageRepository repo1;

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
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();

    if (!isConnectedToInternet && PsConst.SHOW_ADMOB) {
      print('loading ads....');
      checkConnection();
    }
    final dynamic data = EasyLocalizationProvider.of(context).data;
    final LanguageRepository repo1 = Provider.of<LanguageRepository>(context);
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: EasyLocalizationProvider(
                data: data,
                child: ChangeNotifierProvider<LanguageProvider>(
                  create: (BuildContext context) {
                    final LanguageProvider provider =
                        LanguageProvider(repo: repo1);
                    provider.getLanguageList();
                    return provider;
                  },
                  child: Consumer<LanguageProvider>(builder:
                      (BuildContext context, LanguageProvider provider,
                          Widget child) {
                    return SingleChildScrollView(
                        child: Container(
                      padding: const EdgeInsets.all(PsDimens.space8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          PsDropdownBaseWidget(
                              title: Utils.getString(
                                  context, 'language_selection__select'),
                              selectedText: provider.getLanguage().name,
                              onTap: () async {
                                final dynamic result =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.languageList);
                                if (result != null && result is Language) {
                                  await data.changeLocale(result.toLocale());
                                  await provider.addLanguage(result);

                                  widget.languageIsChanged();
                                }
                                Utils.psPrint(result.toString());
                              }),
                          const PsAdMobBannerWidget(
                            admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                          ),
                          // Visibility(
                          //   visible: PsConst.SHOW_ADMOB &&
                          //       isSuccessfullyLoaded &&
                          //       isConnectedToInternet,
                          //   child: AdmobBanner(
                          //     adUnitId: Utils.getBannerAdUnitId(),
                          //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                          //     listener: (AdmobAdEvent event,
                          //         Map<String, dynamic> map) {
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
                    ));
                  }),
                ),
              ),
            ),
          );
        });
  }
}
