import 'package:flutter/cupertino.dart';

class AppIcons {
  //single tone -> has only one instance throughout the app
//those properties it should point to should not be changeable
  AppIcons._(); // constructor is private , so you can't create the instance
  static const fontFam = 'AppIcons';
  static const IconData trophyOutline = IconData(0xe808, fontFamily: fontFam);
  static const IconData menuLeft = IconData(0xe805, fontFamily: fontFam);
  static const IconData peace = IconData(0xe806, fontFamily: fontFam);
}
