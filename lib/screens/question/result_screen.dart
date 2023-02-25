import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/ui_parameters.dart';
import 'package:study_app/screens/question/answer_check_screen.dart';
import 'package:study_app/widgets/common/background_decoration.dart';
import 'package:study_app/widgets/common/custom_appbar.dart';
import 'package:study_app/widgets/common/main_button.dart';
import 'package:study_app/widgets/content_area.dart';
import 'package:study_app/widgets/questions/answer_card.dart';

import '../../configs/themes/custom_text_styles.dart';
import '../../controllers/question_paper/questions_controller.dart';
import '../../controllers/question_paper/question_controller_extension.dart';
import '../../widgets/questions/question_number_card.dart';

class ResultScreen extends GetView<QuestionsController> {
  const ResultScreen({super.key});
  static const String routeName = '/resultscreen';
  @override
  Widget build(BuildContext context) {
    Color _textColor =
        Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundDecoration(
          child: Column(
        children: [
          CustomAppBar(
            leading: const SizedBox(
              height: 80,
            ),
            title: controller.correctAnsweredQuestions,
          ),
          Expanded(
            child: ContentArea(
              child: Column(children: [
                SvgPicture.asset('assets/images/bulb.svg'),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 25),
                  child: Text(
                    'Congratulations',
                    style: headerText.copyWith(color: _textColor),
                  ),
                ),
                Text(
                  'You have ${controller.points} points ',
                  style: TextStyle(color: _textColor),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Tap below the question number to  view the correct answers',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: controller.AllQuestions.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Get.width ~/ 75,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                      itemBuilder: (_, index) {
                        final _question = controller.AllQuestions[index];
                        AnswerStatus _status = AnswerStatus.notasnswered;
                        final _selectedAnswer = _question.selectedAnswer;
                        final _correctAnswer = _question.correctAnswer;
                        if (_selectedAnswer == _correctAnswer) {
                          _status = AnswerStatus.correct;
                        } else if (_selectedAnswer == null) {
                          _status = AnswerStatus.wrong;
                        } else {
                          _status = AnswerStatus.wrong;
                        }
                        return QuestionNumberCard(
                          index: index,
                          status: _status,
                          onTap: () {
                            controller.jumpToQuestion(index, isGoBack: false);
                            Get.toNamed(AnswerCheckScreen.routeName);
                          },
                        );
                      }),
                )
              ]),
            ),
          ),
          ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: UIParameters.mobileScreenPadding,
                child: Row(children: [
                  Expanded(
                      child: MainButton(
                    onTap: () => controller.tryAgain(),
                    color: Colors.blueGrey,
                    title: "Try Again",
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: MainButton(
                    onTap: () {
                      controller.saveTestResults();
                    },
                    // color: Get.isDarkMode?:,
                    title: "Go Home ",
                  ))
                ]),
              ))
        ],
      )),
    );
  }
}
