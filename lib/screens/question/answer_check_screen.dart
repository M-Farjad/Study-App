import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_app/configs/themes/custom_text_styles.dart';
import 'package:study_app/screens/question/result_screen.dart';
import 'package:study_app/widgets/common/background_decoration.dart';
import 'package:study_app/widgets/common/custom_appbar.dart';
import 'package:study_app/widgets/questions/answer_card.dart';

import '../../controllers/question_paper/questions_controller.dart';
import '../../widgets/content_area.dart';

class AnswerCheckScreen extends GetView<QuestionsController> {
  const AnswerCheckScreen({super.key});
  static const String routeName = '/answercheckscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        titleWidget: Obx(() => Text(
              'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
              style: appBarTS,
            )),
        showActionIcon: true,
        onMenuActionTap: () {
          Get.toNamed(ResultScreen.routeName);
        },
      ),
      body: BackgroundDecoration(
        child: Obx(() => Column(
              children: [
                Expanded(
                  child: ContentArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: [
                        Text(controller.currentQuestion.value!.question),
                        GetBuilder<QuestionsController>(
                            id: 'answer_review_list', // id is used so that the controller will not rebuild at many places
                            builder: (_) {
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    final answer = controller
                                        .currentQuestion.value!.answers[index];
                                    final selectedAns = controller
                                        .currentQuestion.value!.selectedAnswer;
                                    final correctAns = controller
                                        .currentQuestion.value!.correctAnswer;
                                    final String answerText =
                                        '${answer.identifier}. ${answer.answer}';

                                    if (correctAns == selectedAns &&
                                        answer.identifier == selectedAns) {
                                      //correct ans
                                      return CorrectAns(
                                        ans: answerText,
                                      );
                                    } else if (selectedAns == null) {
                                      //not selected ans
                                      return NotAnswered(
                                        ans: answerText,
                                      );
                                    } else if (selectedAns != correctAns &&
                                        answer.identifier == selectedAns) {
                                      //wrong ans
                                      return WrongAns(
                                        ans: answerText,
                                      );
                                    } else if (correctAns ==
                                        answer.identifier) {
                                      //correct ans
                                      return CorrectAns(
                                        ans: answerText,
                                      );
                                    }

                                    return AnswerCard(
                                      answer: answerText,
                                      ontap: () {},
                                      isSelected: false,
                                    );
                                  },
                                  separatorBuilder: (_, index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: controller
                                      .currentQuestion.value!.answers.length);
                            })
                      ]),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
