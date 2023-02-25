import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/UI_parameters.dart';
import 'app_dark_theme.dart';
import 'app_light_theme.dart';
import 'package:get/get.dart';

const onSurfaceTextColor = Colors.white;

const mainGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLightColorLight, primaryColorLight]);

const mainGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLightColorDark, primaryColorDark]);

LinearGradient mainGradient() =>
    UIParameters.isDarkMode() ? mainGradientDark : mainGradientLight;

Color customScaffoldColor(BuildContext context) => UIParameters.isDarkMode()
    ? const Color(0xFF2e3c62)
    : const Color.fromARGB(255, 240, 237, 255);
Color answerSelectedCOlor() => UIParameters.isDarkMode()
    ? Theme.of(Get.context!).cardColor.withOpacity(0.5)
    : Theme.of(Get.context!).primaryColor;
Color answerBorderColor() => UIParameters.isDarkMode()
    ? const Color.fromARGB(255, 20, 46, 158)
    : const Color.fromARGB(255, 221, 221, 221);
