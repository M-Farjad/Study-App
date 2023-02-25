import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/app_colors..dart';

import '../../configs/themes/UI_parameters.dart';

enum AnswerStatus { correct, answered, notasnswered, wrong }

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

class CorrectAns extends StatelessWidget {
  const CorrectAns({super.key, required this.ans});
  final String ans;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: UIParameters.cardBorderRadius,
          color: correctAnswerColor.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        ans,
        style:
            TextStyle(color: correctAnswerColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class WrongAns extends StatelessWidget {
  const WrongAns({super.key, required this.ans});
  final String ans;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: UIParameters.cardBorderRadius,
          color: wrongAnswerColor.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        ans,
        style: TextStyle(color: wrongAnswerColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotAnswered extends StatelessWidget {
  const NotAnswered({super.key, required this.ans});
  final String ans;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          borderRadius: UIParameters.cardBorderRadius,
          color: notAnsweredColor.withOpacity(0.1)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text(
        ans,
        style: TextStyle(color: notAnsweredColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
