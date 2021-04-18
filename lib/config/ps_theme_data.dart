import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'ps_colors.dart';
import 'ps_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    PsColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: PsColors.mainColor,
      primaryColorDark: PsColors.mainDarkColor,
      primaryColorLight: PsColors.mainLightColor,
      textTheme: TextTheme(
        display4: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        display3: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        display2: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        display1: TextStyle(
          color: PsColors.textPrimaryColor,
          fontFamily: PsConfig.ps_default_font_family,
        ),
        headline: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        title: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        subhead: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontSize: PsDimens.space18,
            fontWeight: FontWeight.bold),
        body2: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        body1: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontSize: 15),
        caption: TextStyle(
            color: PsColors.textPrimaryLightColor,
            fontFamily: PsConfig.ps_default_font_family),
        button: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        subtitle: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontSize: PsDimens.space16,
            fontWeight: FontWeight.bold),
        overline: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
      ),
      iconTheme: IconThemeData(color: PsColors.iconColor),
      appBarTheme: AppBarTheme(color: PsColors.coreBackgroundColor),
    );
  } else {
    PsColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: PsColors.mainColor,
        primaryColorDark: PsColors.mainDarkColor,
        primaryColorLight: PsColors.mainLightColor,
        textTheme: TextTheme(
          display4: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          display3: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          display2: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          display1: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          headline: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          title: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          subhead: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontSize: PsDimens.space18,
              fontWeight: FontWeight.bold),
          body2: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          body1: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontSize: 15),
          caption: TextStyle(
              color: PsColors.textPrimaryLightColor,
              fontFamily: PsConfig.ps_default_font_family),
          button: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          subtitle: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontSize: PsDimens.space16,
              fontWeight: FontWeight.bold),
          overline: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
        ),
        iconTheme: IconThemeData(color: PsColors.iconColor),
        appBarTheme: AppBarTheme(color: PsColors.coreBackgroundColor));
  }
}
