import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:study_app/models/question_paper_model.dart';

import '../../firebase_ref/loading_status.dart';
import '../../firebase_ref/references.dart';

class QuestionsController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  late QuestionPaperModel questionPaperModel;
  final questionIndex = 0.obs;
  bool get isFirstQuestion => questionIndex.value > 0;
  bool get isLastQuestion => questionIndex.value >= AllQuestions.length - 1;
  Rxn<Questions> currentQuestion = Rxn<Questions>();
  //Timer
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;

  final AllQuestions = <Questions>[];
  @override
  void onReady() {
    final _questionPaper = Get.arguments as QuestionPaperModel;
    loadData(_questionPaper);

    print("...onReady...");
    super.onReady();
  }

  Future<void> loadData(QuestionPaperModel questionPaper) async {
    questionPaperModel = questionPaper;
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> questionQuery =
          await questionPaperRF
              .doc(questionPaper.id)
              .collection("questions")
              .get();
      final questions = questionQuery.docs
          .map((snapshot) => Questions.fromSnapshot(snapshot))
          .toList();
      questionPaper.questions = questions;
      for (Questions _question in questionPaper.questions!) {
        final QuerySnapshot<Map<String, dynamic>> answersQuery =
            await questionPaperRF
                .doc(questionPaper.id)
                .collection("questions")
                .doc(_question.id)
                .collection("answers")
                .get();
        final answers = answersQuery.docs
            .map((answers) => Answers.fromSnapshot(answers))
            .toList();
        _question.answers = answers;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (questionPaper.questions != null &&
        questionPaper.questions!.isNotEmpty) {
      AllQuestions.assignAll(questionPaper.questions!);
      currentQuestion.value = questionPaper.questions![0];
      _startTimer(questionPaper.timeSeconds); 
      print("...startTimer...");
      if (kDebugMode) {
        print(questionPaper.questions![0].question);
      }
      loadingStatus.value = LoadingStatus.completed;
    } else {
      loadingStatus.value = LoadingStatus.error;
    }
  }

  void SelectedAnswer(String? answer) {
    currentQuestion.value!.selectedAnswer = answer;
    update(['answers_list']);
  }

  void nextQuestion() {
    if (questionIndex.value >= AllQuestions.length - 1) return;
    questionIndex.value++;
    currentQuestion.value = AllQuestions[questionIndex.value];
  }

  void prevQuestion() {
    if (questionIndex.value <= 0) return;
    questionIndex.value--;
    currentQuestion.value = AllQuestions[questionIndex.value];
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    Timer.periodic(
      duration,
      (Timer timer) {
        if (remainSeconds == 0) {
          timer.cancel();
        } else {
          int minutes = remainSeconds ~/ 60;
          int seconds = remainSeconds % 60;
          time.value = minutes.toString().padLeft(2, "0") +
              ":" +
              seconds.toString().padLeft(2, "0");
          remainSeconds--;
        }
      },
    );
  }
}
