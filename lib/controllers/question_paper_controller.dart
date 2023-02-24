import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:study_app/controllers/auth_controller.dart';
import 'package:study_app/firebase_ref/references.dart';
import 'package:study_app/models/question_paper_model.dart';
import 'package:study_app/services/firebase_storage_services.dart';
import 'package:study_app/widgets/dialogs/dialog_widget.dart';

import '../screens/question/question_screen.dart';

class QuestionPaperController extends GetxController {
  final allPaperImages = <String>[].obs; //obs for reactive
  final allPapers = <QuestionPaperModel>[].obs;
  @override
  void onReady() {
    getAllPapers();
    super.onReady();
  }

  Future<void> getAllPapers() async {
    List<String> imgName = ["biology", "physics", "maths", "chemistry"];
    try {
      //query snapshot is the obj of cloud firestore
      QuerySnapshot<Map<String, dynamic>> data =
          await questionPaperRF.get(); //.get to get the data from the firebase

      final allPaperList = data.docs.map((paper) {
        return QuestionPaperModel.fromSnapshot(paper);
      }).toList();
      allPapers.assignAll(allPaperList);

      for (var paper in imgName) {
        final imgUrl = await Get.find<FirebaseStorageService>().getImage(paper);
        paper = imgUrl!;
      }
      allPapers.assignAll(
          allPaperList); // no duplication it will replace any changes
    } catch (e) {}
  }

  void navigateToQuestions(
      {required QuestionPaperModel paper, bool tryAgain = false}) {
    //   AuthController _authController = Get.find();
    //   if (_authController.isLoggedIn()) {
    //     if (tryAgain) {
    //       //
    //       Get.back(); //if try again remove the ui fromthe  stack
    //       //get.of named
    //     } else {
    //       Get.toNamed(QuestionScreen.routeName, arguments: paper);
    //     }
    //   } else {
    //     print('title is ${paper.title}');
    //     _authController.showLoginAlertDialogue();
    //   }
    Get.toNamed(QuestionScreen.routeName, arguments: paper);
  }
}
