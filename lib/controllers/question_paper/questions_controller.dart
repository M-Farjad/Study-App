import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:study_app/controllers/auth_controller.dart';
import 'package:study_app/controllers/question_paper_controller.dart';
import 'package:study_app/screens/home/home_screen.dart';

import '../../models/question_paper_model.dart';
import '../../firebase_ref/loading_status.dart';
import '../../firebase_ref/references.dart';
import '../../screens/question/result_screen.dart';

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

  String get completedTest {
    final answered =
        AllQuestions.where((element) => element.selectedAnswer != null)
            .toList()
            .length;
    return "$answered out of${AllQuestions.length} answered";
  }

  void jumpToQuestion(int index, {bool isGoBack = true}) {
    questionIndex.value = index;
    currentQuestion.value = AllQuestions[index];
    if (isGoBack) {
      Get.back();
    }
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
    _timer = Timer.periodic(
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

  void complete() {
    _timer!.cancel(); //to avoid memory leakage
    Get.offAndToNamed(ResultScreen.routeName);
  }

  void tryAgain() {
    Get.find<QuestionPaperController>().navigateToQuestions(
      paper: questionPaperModel,
      tryAgain: true,
    );
  }

  void NavigateToHome() {
    _timer!.cancel();
    Get.offNamedUntil(HomeScreen.routeName,
        (route) => false); //starts from beginning --> saves memory
  }



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
    // var batch = fireStore.batch();
    // User? _user = Get.find<AuthController>().getUser();
    // if (_user == null) return;
    // batch.set(
    //     userRf
    //         .doc(_user.email)
    //         .collection('myrecent_tests')
    //         .doc(questionPaperModel.id),
    //     {
    //       'points': points,
    //       'correct_answer': '$correctQuestionsCount/${AllQuestions.length}',
    //       'question_id': questionPaperModel.id,
    //       'time': questionPaperModel.timeSeconds - remainSeconds,
    //     });
    // batch.commit();
    NavigateToHome();
  }



}
