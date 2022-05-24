import 'package:bunkerfit_run/app/lockedFiles/local_notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/dynamicFiles/main_binding.dart';
import 'app/dynamicFiles/project_constants.dart';
import 'app/dynamicFiles/project_strings.dart';

import 'app/lockedFiles/common_utils.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_service.dart';
import 'app/theme/translation_meta.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!GetPlatform.isWeb && (GetPlatform.isAndroid || GetPlatform.isIOS)) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  await GetStorage.init(localStore);
  await setupDefaultStorage();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: projectName,
      initialBinding: MainBinding(),
      initialRoute: AppPages.INITIAL,
      unknownRoute: GetPage(name: '/splash', page: () => const SplashView()),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      themeMode: ThemeService().getThemeMode(),
      translations: TranslationMeta(),
      locale: primaryLocale,
      fallbackLocale: primaryLocale,
      getPages: AppPages.routes,
    ),
  );
}
