import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/UI_parameters.dart';

import 'app_colors..dart';

TextStyle cardTitle(context) => TextStyle(
    color: UIParameters.isDarkMode()
        ? Theme.of(context).textTheme.bodyLarge!.color
        : Theme.of(context).primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold);

const detailText = TextStyle(fontSize: 12);
const questionText = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
const headerText = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
const appBarTS = TextStyle(
    fontWeight: FontWeight.bold, fontSize: 16, color: onSurfaceTextColor);
