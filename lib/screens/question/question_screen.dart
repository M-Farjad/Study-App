import 'package:flutter/material.dart';
import '../../controllers/question_paper/questions_controller.dart';
import '../../widgets/common/background_decoration.dart';
import 'package:get/get.dart';

class QuestionScreen extends GetView<QuestionsController> {
  const QuestionScreen({super.key});
  static const String routeName = "/questionsscreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
