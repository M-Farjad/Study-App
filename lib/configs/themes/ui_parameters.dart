import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double _mobileScreenPadding = 25.0;
const double _cardBorderRadius = 10.0;

double get mobileScreenPadding => _mobileScreenPadding;
double get cardBorderRadius => _cardBorderRadius;

class UIParameters {
  static bool isDarkMode() {
    // return Theme.of(context).brightness == Brightness.dark;
    return Get.isDarkMode ? true : false;
  }

  static EdgeInsets get mobileScreenPadding =>
      const EdgeInsets.all(_mobileScreenPadding);
  static BorderRadius get cardBorderRadius =>
      BorderRadius.circular(_cardBorderRadius);
}
