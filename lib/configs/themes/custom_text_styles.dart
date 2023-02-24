import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/UI_parameters.dart';

TextStyle cardTitle(context) => TextStyle(
    color: UIParameters.isDarkMode()
        ? Theme.of(context).textTheme.bodyLarge!.color
        : Theme.of(context).primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold);

const detailText = TextStyle(fontSize: 12);
const headerText = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
