import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/sub_theme_data_mixin.dart';

const Color primaryLightColorLight = Color(0xFF3ac3cb);
const Color primaryColorLight = Color(0xFFf85187);
const Color mainTextColor = Color.fromARGB(255, 40, 40, 40);
const Color cardColor = Color.fromARGB(255, 254, 254, 255);

class LightTheme with SubThemeData {
  // with is used instead of extends for mixin class
  ThemeData buildLigtTheme() {
    final ThemeData systemLightTheme = ThemeData.light();
    return systemLightTheme.copyWith(
        primaryColor: primaryColorLight,
        cardColor: cardColor,
        //copy with is used to use default settings
        iconTheme: getIconTheme(),
        textTheme: getTextThemes()
            .apply(bodyColor: mainTextColor, displayColor: mainTextColor));
  }
}
