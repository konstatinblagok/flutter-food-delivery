import 'dart:async';
import 'dart:io';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fluttermultistoreflutter/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttermultistoreflutter/config/ps_theme_data.dart';
import 'package:fluttermultistoreflutter/provider/common/ps_theme_provider.dart';
import 'package:fluttermultistoreflutter/provider/ps_provider_dependencies.dart';
import 'package:fluttermultistoreflutter/repository/ps_theme_repository.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:fluttermultistoreflutter/config/router.dart' as router;
import 'config/ps_config.dart';
import 'constant/ps_constants.dart';
import 'db/common/ps_shared_preferences.dart';


Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }
  runApp(EasyLocalization(child: PSApp()));
}

Future<dynamic> initAds() async {
  if (PsConst.SHOW_ADMOB && await Utils.checkInternetConnectivity()) {
    // FirebaseAdMob.instance.initialize(appId: utilsGetAdAppId());
  }
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  bool _isLanguageLoaded = false;

  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();

    _isLanguageLoaded = false;
  }

  Future<ThemeData> getSharePerference(
      EasyLocalizationProvider provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      //SharedPreferences sh = await
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        //independentProviders.add(Provider.value(value: psSharedPreferences));
        //providerList = [...providers];
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  Future<dynamic> getCurrentLang(EasyLocalizationProvider provider) async {
    if (!_isLanguageLoaded) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      provider.data.changeLocale(locale: Locale(
          prefs.getString(PsConst.LANGUAGE__LANGUAGE_CODE_KEY) ??
              PsConfig.defaultLanguage.languageCode,
          prefs.getString(PsConst.LANGUAGE__COUNTRY_CODE_KEY) ??
              PsConfig.defaultLanguage.countryCode));
      _isLanguageLoaded = true;
    }
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in PsConfig.psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    // init Color
    PsColors.loadColor(context);

    final EasyLocalizationProvider provider2 =
        EasyLocalizationProvider.of(context);
    final dynamic data = provider2.data;

    getCurrentLang(provider2);
    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return EasyLocalizationProvider(
                  data: data,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Panacea-Soft',
                    theme: theme,
                    initialRoute: '/',
                    onGenerateRoute: router.generateRoute,

                    // initialRoute: RoutePaths.shopDashboard,
                    // onGenerateRoute: Router.generateRoute,
                    localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      //app-specific localization
                      EasyLocalizationDelegate(
                          locale: data.locale ??
                              Locale(PsConfig.defaultLanguage.languageCode,
                                  PsConfig.defaultLanguage.countryCode),
                          path: 'assets/langs'),
                    ],
                    supportedLocales: getSupportedLanguages(),
                    //ps_language_list,
                    locale: data.locale ??
                        Locale(PsConfig.defaultLanguage.languageCode,
                            PsConfig.defaultLanguage.countryCode),
                  ));
            }));
  }
}
