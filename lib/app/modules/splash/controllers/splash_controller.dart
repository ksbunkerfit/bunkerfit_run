import 'dart:async';

import 'package:get/get.dart';

import '../../../dynamicFiles/project_constants.dart';
import '../../homePage/views/home_page_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    Timer(
      const Duration(seconds: isDevMode ? 1 : 3),
      () {
        Get.off(
          () => const HomePageView(),
          transition: Transition.rightToLeftWithFade,
          duration: const Duration(seconds: 1),
        );
      },
    );

    super.onReady();
  }

  @override
  void onClose() {}
}
