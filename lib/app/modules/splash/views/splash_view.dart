import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../dynamicFiles/project_strings.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final justHelper = Get.find<SplashController>();

    setStatusBarColor(Colors.white);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png').center(),
        ],
      ),
      persistentFooterButtons: [
        Container(
          height: 50,
          width: size.width,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Strong Body & Mind', style: secondaryTextStyle()),
              Text(
                projectName,
                style: boldTextStyle(size: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
