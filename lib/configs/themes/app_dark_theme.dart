import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/sub_theme_data_mixin.dart';

const Color primaryColorDark = Color(0xFF2e3c62);
const Color primaryLightColorDark = Color(0xFF99ace1);
const Color mainTextColorDark = Colors.white;


class DarkTheme with SubThemeData {
  // with is used instead of extends for mixin class
  ThemeData buildDarkTheme() {
    final ThemeData systemLightTheme = ThemeData.dark(); 
    return systemLightTheme.copyWith(
        //copy with is used to use default settings
        iconTheme: getIconTheme(),
        textTheme: getTextThemes()
            .apply(bodyColor: mainTextColorDark, displayColor: mainTextColorDark  ));
  }
}
