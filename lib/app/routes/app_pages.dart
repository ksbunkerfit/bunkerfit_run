import 'package:get/get.dart';

import '../modules/appUpdate/views/app_update_view.dart';
import '../modules/homePage/views/home_page_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tracking/views/tracking_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.APP_UPDATE,
      page: () => const AppUpdateView(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => const HomePageView(),
    ),
    GetPage(
      name: _Paths.TRACKING,
      page: () => const TrackingView(),
    ),
  ];
}
