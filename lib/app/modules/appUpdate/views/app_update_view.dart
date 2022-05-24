import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../dynamicFiles/global_controller.dart';
import '../../../dynamicFiles/project_constants.dart';
import '../../../lockedFiles/common_utils.dart';
import '../../../lockedFiles/common_widgets.dart';
import '../../../theme/app_responsive.dart';
import '../controllers/app_update_controller.dart';

class AppUpdateView extends GetView<AppUpdateController> {
  const AppUpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalController globalControllerHelper =
        Get.find<GlobalController>();

    final Size size = MediaQuery.of(context).size;
    final ThemeData nowTheme = Theme.of(context);

    setStatusBarColor(nowTheme.primaryColor);

    return WrapPageWithUnfocusSafeArea(
      context: context,
      exitApp: true,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              width: AppResponsiveWidget.isDesktop()
                  ? size.width * 0.60
                  : AppResponsiveWidget.isTablet()
                      ? size.width * 0.90
                      : size.width,
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png'),
                  25.height,
                  const Divider(),
                  15.height,
                  Text(
                    "V 1.0.4",
                    style: boldTextStyle(),
                  ),
                  15.height,
                  AutoSizeText(
                    'To use this app, download the latest version',
                    style: secondaryTextStyle(size: 16),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                  25.height,
                  AppButton(
                    onTap: () {
                      if (GetPlatform.isIOS || GetPlatform.isMacOS) {
                        launchInBrowser(
                          Uri(
                            scheme: 'https',
                            host: 'apps.apple.com',
                            path: 'in/app/$appStoreInfo',
                          ),
                        );
                      } else if (GetPlatform.isAndroid) {
                        launchInBrowser(
                          Uri(
                            scheme: 'https',
                            host: 'play.google.com',
                            path: 'store/apps/details?id=$playStoreInfo',
                          ),
                        );
                      }
                    },
                    color: Colors.blue,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    text: 'Update Now',
                    width: size.width,
                    textStyle: primaryTextStyle(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(15),
                  ),
                  35.height,
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10, right: 10),
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Version',
                  style: boldTextStyle(size: 14, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    globalControllerHelper.packageInfo!.version,
                    style: boldTextStyle(
                      size: 14,
                      color: nowTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
