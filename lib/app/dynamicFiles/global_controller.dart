import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../lockedFiles/local_notify.dart';
import '../modules/appUpdate/views/app_update_view.dart';

class GlobalController extends GetxController {
  RxBool globalIsLoadingBasic = true.obs;

  PackageInfo? packageInfo;

  @override
  void onInit() {
    if (!GetPlatform.isWeb && (GetPlatform.isAndroid || GetPlatform.isIOS)) {
      localNotifyInit();
    }

    fetchInitData();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Future checkMyVersion() async {
    packageInfo = await PackageInfo.fromPlatform();

    if (1 == 2) {
      Timer(
        const Duration(seconds: 10),
        () => Get.off(
          () => const AppUpdateView(),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future fetchInitData() async {
    try {
      globalIsLoadingBasic.value = true;
      // fetch the initial data

      globalIsLoadingBasic.value = false;

      checkMyVersion();
    } catch (e) {
      log('$e');
    }
  }
}
