import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/app_colors..dart';

import '../../configs/themes/UI_parameters.dart';

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final VoidCallback ontap;
  const AnswerCard(
      {super.key,
      required this.answer,
      this.isSelected = false,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      borderRadius: UIParameters.cardBorderRadius,
      child: Ink(
        child: Text(
          answer,
          style: TextStyle(color: isSelected ? onSurfaceTextColor : null),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: UIParameters.cardBorderRadius,
          color:
              isSelected ? answerSelectedCOlor() : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? answerSelectedCOlor() : answerBorderColor(),
          ),
        ),
      ),
    );
  }
}
