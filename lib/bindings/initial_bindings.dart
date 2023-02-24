import 'package:get/get.dart';
import 'package:study_app/controllers/auth_controller.dart';
import 'package:study_app/controllers/theme_controller.dart';

//implement is used when we have to use some functions only
class InitialBindings implements Bindings {
  //bindings is from getx package
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(AuthController(), permanent: true);
  }
}
