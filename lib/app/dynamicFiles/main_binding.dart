import 'package:get/get.dart';

import '../modules/appUpdate/controllers/app_update_controller.dart';
import '../modules/homePage/controllers/home_page_controller.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/tracking/controllers/tracking_controller.dart';

import 'global_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      GlobalController(),
      permanent: true,
    );

    Get.lazyPut<AppUpdateController>(
      () => AppUpdateController(),
      fenix: true,
    );
    Get.lazyPut<SplashController>(
      () => SplashController(),
      fenix: true,
    );
    Get.lazyPut<HomePageController>(
      () => HomePageController(),
      fenix: true,
    );
    Get.lazyPut<TrackingController>(
      () => TrackingController(),
      fenix: true,
    );
  }
}
