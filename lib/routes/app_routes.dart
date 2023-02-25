import 'package:study_app/controllers/question_paper/questions_controller.dart';
import 'package:study_app/controllers/question_paper_controller.dart';
import 'package:study_app/controllers/zoom_drawer_controller.dart';
import 'package:study_app/screens/home/home_screen.dart';
import 'package:study_app/screens/introduction/introduction.dart';

import '../screens/login/login_screen.dart';
import '../screens/question/question_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: QuestionScreen.routeName,
          page: () => QuestionScreen(),
          binding: BindingsBuilder(
            () {
              Get.put(QuestionsController());
            },
          ),
        ),
        GetPage(name: "/", page: () => const SplashScreen()),
        GetPage(name: "/intro", page: () => const IntroductionScreen()),
        GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
        GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            binding: BindingsBuilder(() {
              // we have to use questionpapercontroller after
              Get.put(QuestionPaperController());
              //to use the zoom drawer controller
              Get.put(MyZoomDrawerController());
            })),
      ];
}
