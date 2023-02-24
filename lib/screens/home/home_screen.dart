import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:study_app/configs/themes/app_colors..dart';
import 'package:study_app/configs/themes/custom_text_styles.dart';
import 'package:study_app/controllers/zoom_drawer_controller.dart';
import 'package:study_app/screens/home/menu_screen.dart';
import 'package:study_app/widgets/app_circle_button.dart';
import 'package:study_app/widgets/content_area.dart';

import '../../configs/themes/UI_parameters.dart';
import 'package:flutter/material.dart';
import 'package:study_app/controllers/question_paper_controller.dart';
import 'package:get/get.dart';
import 'package:study_app/screens/home/question_card.dart';

import '../../controllers/question_paper/app_icons.dart';

class HomeScreen extends GetView<MyZoomDrawerController> {
  //get view intance the class MyZoomDrawerController
  const HomeScreen({super.key});
  static const String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    // Get.put(FirebaseStorageService());
    QuestionPaperController _questionPaperController = Get.find();
    // print('debug: HomeScreen');
    // print('debug: allPapers length ${_questionPaperController.allPapers.length}');
    return Scaffold(
      body: GetBuilder<MyZoomDrawerController>(
        builder: (_) {
          return ZoomDrawer(
            borderRadius: 50.0,
            controller: _.zoomDrawerController,
            showShadow: true,
            angle: 0.0,
            style: DrawerStyle.defaultStyle,
            menuBackgroundColor: Colors.white.withOpacity(0.5),
            slideWidth: MediaQuery.of(context).size.width * 0.6,
            // drawerShadowsBackgroundColor: Colors.red,
            menuScreen: const MenuScreen(),
            mainScreen: Container(
              decoration: BoxDecoration(gradient: mainGradient()),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(mobileScreenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppCircularButton(
                            onTap: controller.toggleDrawer,
                            child: const Icon(
                              AppIcons.menuLeft,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(
                                  AppIcons.peace,
                                ),
                                Text(
                                  "HEllo Friend",
                                  style: detailText.copyWith(
                                    color: onSurfaceTextColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text(
                            "What do you want to learn today?",
                            style: headerText,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ContentArea(
                          addPadding: false,
                          child: Obx(
                            () => ListView.separated(
                                padding: UIParameters.mobileScreenPadding,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // print('debug: Index ${index}');
                                  return QuestionCard(
                                    model: _questionPaperController
                                        .allPapers[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemCount:
                                    _questionPaperController.allPapers.length),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
