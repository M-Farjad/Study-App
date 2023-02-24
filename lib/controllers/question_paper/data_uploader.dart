import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_app/firebase_ref/references.dart';
import 'dart:convert';

import 'package:study_app/models/question_paper_model.dart';

import '../../firebase_ref/loading_status.dart';

// controller will be called only once
class DataUploader extends GetxController {
  @override
  void onReady() {
    uploadData();
    super.onReady();
  }

  final loadingStatus =  LoadingStatus.loading.obs; // now it is observable

  void uploadData() async {
    loadingStatus.value = LoadingStatus.loading ;//0

    final fireStore = FirebaseFirestore.instance;
    //assets will be loaded in the manifestcontent
    final manifestContent = await DefaultAssetBundle.of(Get.context!)
        .loadString("AssetManifest.json");

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // it is reading all content in assets

    //now it will read address of req files only
    final papersInAssets = manifestMap.keys
        .where((path) =>
            path.startsWith("assets/DB/papers") && path.contains('.json'))
        .toList(); //list of file names

    List<QuestionPaperModel> questionPapers = []; //list of json files
    // get the data of the req files
    for (var paper in papersInAssets) {
      String paperContent = await rootBundle.loadString(paper);
      final decode = json.decode(paperContent);
      final questionPaperModel = QuestionPaperModel.fromJson(decode);
      questionPapers
          .add(questionPaperModel);
    }

    var batch = fireStore.batch();
    for (var paper in questionPapers) {
      batch.set(questionPaperRF.doc(paper.id), {
        "title": paper.title,
        "image_url": paper.imageUrl,
        "description": paper.description,
        "time_seconds": paper.timeSeconds,
        "questions_count":
            paper.questions == null ? 0 : paper.questions!.length,
      }); //.doc for object

      for (var questions in paper.questions!) {
        final questionPath =
            questionRF(paperId: paper.id, questionId: questions.id);
        batch.set(questionPath, {
          "question": questions.question,
          "correct_answer": questions.correctAnswer
        });

        for (var answers in questions.answers) {
          batch
              .set(questionPath.collection('answers').doc(answers.identifier), {
            "identifier": answers.identifier,
            "answer": answers.answer,
          });
        }
      }
    }

    await batch.commit(); // commiting in the database
    loadingStatus.value = LoadingStatus.completed ; //1 

  }
}
