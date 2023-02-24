import 'package:get/get.dart';
import 'package:study_app/models/question_paper_model.dart';

class QuestionsController extends GetxController {
  @override
  void onReady() {
    final _questionPaper = Get.arguments as QuestionPaperModel;
    print(_questionPaper.title);
    super.onReady();
  }
}
