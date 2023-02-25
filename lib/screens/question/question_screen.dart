import 'package:flutter/material.dart';
import 'package:study_app/configs/themes/custom_text_styles.dart';
import 'package:study_app/firebase_ref/loading_status.dart';
import 'package:study_app/widgets/common/question_screenholder.dart';
import 'package:study_app/widgets/content_area.dart';
import '../../configs/themes/UI_parameters.dart';
import '../../configs/themes/app_colors..dart';
import '../../controllers/question_paper/questions_controller.dart';
import '../../widgets/common/background_decoration.dart';
import 'package:get/get.dart';

import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/main_button.dart';
import '../../widgets/questions/answer_card.dart';

class QuestionScreen extends GetView<QuestionsController> {
  QuestionScreen({super.key});
  static const String routeName = "/questionsscreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(color: onSurfaceTextColor, width: 2),
              ),
            ),
            child: Obx(() => Text('${controller.time.value}')),
          ),
          showActionIcon: true,
          titleWidget: Obx(
            () => Text(
              'Q. ${(controller.questionIndex.value + 1).toString().padLeft(2, '0')}',
              style: appBarTS,
            ),
          )),
      body: BackgroundDecoration(
        child: Obx(
          () => Column(
            children: [
              if (controller.loadingStatus.value == LoadingStatus.loading)
                const Expanded(
                  child: ContentArea(child: QuestionScreenHolder()),
                ),
              if (controller.loadingStatus.value == LoadingStatus.completed)
                Expanded(
                  child: ContentArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          Text(
                            controller.currentQuestion.value!.question,
                            style: questionText,
                          ),
                          GetBuilder<QuestionsController>(
                              id: 'answers_list',
                              builder: (context) {
                                return ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(top: 25),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final answer = controller.currentQuestion
                                          .value!.answers[index];
                                      return AnswerCard(
                                        answer:
                                            '${answer.identifier}.${answer.answer}',
                                        ontap: () {
                                          controller.SelectedAnswer(
                                              answer.identifier);
                                        },
                                        isSelected: answer.identifier ==
                                            controller.currentQuestion.value!
                                                .selectedAnswer,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(
                                              height: 10,
                                            ),
                                    itemCount: controller
                                        .currentQuestion.value!.answers.length);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ColoredBox(
                child: Padding(
                  padding: UIParameters.mobileScreenPadding,
                  child: Row(
                    children: [
                      Visibility(
                        visible: controller.isFirstQuestion,
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: MainButton(
                            onTap: () {
                              controller.prevQuestion();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Get.isDarkMode
                                  ? onSurfaceTextColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Visibility(
                            visible: controller.loadingStatus.value ==
                                LoadingStatus.completed,
                            child: MainButton(
                              onTap: () {
                                controller.isLastQuestion
                                    ? Container()
                                    : controller.nextQuestion();
                              },
                              title: controller.isLastQuestion
                                  ? 'Complete'
                                  : 'Next',
                            )),
                      )
                    ],
                  ),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
