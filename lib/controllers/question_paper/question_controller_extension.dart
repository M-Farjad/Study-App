import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../firebase_ref/references.dart';
import '../auth_controller.dart';
import 'questions_controller.dart';

extension QuestionControllerExtension on QuestionsController {
  int get correctQuestionsCount => AllQuestions.where(
          (element) => element.selectedAnswer == element.correctAnswer)
      .toList()
      .length;

  String get correctAnsweredQuestions {
    return '$correctQuestionsCount out of ${AllQuestions.length} are correct';
  }

  String get points {
    var points = (correctQuestionsCount / AllQuestions.length) *
        100 *
        (questionPaperModel.timeSeconds - remainSeconds) /
        questionPaperModel.timeSeconds *
        100;
    return points.toStringAsFixed(2);
  }

  Future<void> saveTestResults() async {
    var batch = fireStore.batch();
    User? _user = Get.find<AuthController>().getUser();
    if (_user == null) return;
    batch.set(
        userRf
            .doc(_user.email)
            .collection('myrecent_tests')
            .doc(questionPaperModel.id),
        {
          'points': points,
          'correct_answer': '$correctQuestionsCount/${AllQuestions.length}',
          'question_id': questionPaperModel.id,
          'time': questionPaperModel.timeSeconds - remainSeconds,
        });
    batch.commit();
    NavigateToHome();
  }
}
