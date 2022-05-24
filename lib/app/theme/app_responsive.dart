import 'package:flutter/material.dart';
import 'package:get/get.dart';

const int miniScreenSize = 340;
const int smallScreenSize = 576;
const int mediumScreenSize = 768;
const int moreThanMediumScreenSize = 960;
const int standardScreenSize = 1140;
const int largeScreenSize = 1400;

class AppResponsiveWidget extends StatelessWidget {
  final Widget? miniScreen;
  final Widget smallScreen;
  final Widget? mediumScreen;
  final Widget? moreThanMediumScreen;
  final Widget standardScreen;
  final Widget? largeScreen;
  final Widget? extraLargeScreen;

  const AppResponsiveWidget({
    Key? key,
    this.miniScreen,
    required this.smallScreen,
    this.mediumScreen,
    this.moreThanMediumScreen,
    required this.standardScreen,
    this.largeScreen,
    this.extraLargeScreen,
  }) : super(key: key);

  static bool isMiniScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth < miniScreenSize;
  }

  static bool isSmallScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= miniScreenSize && nowWidth < smallScreenSize;
  }

  static bool isMediumScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= smallScreenSize && nowWidth < mediumScreenSize;
  }

  static bool isMoreThanMediumScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= mediumScreenSize && nowWidth < moreThanMediumScreenSize;
  }

  static bool isStandardScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= moreThanMediumScreenSize &&
        nowWidth < standardScreenSize;
  }

  static bool isLargeScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= standardScreenSize && nowWidth < largeScreenSize;
  }

  static bool isExtraLargeScreen() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= largeScreenSize;
  }

  static bool isMobile() {
    final nowWidth = (Get.context!).width;
    return nowWidth < mediumScreenSize;
  }

  static bool isTablet() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= mediumScreenSize && nowWidth < moreThanMediumScreenSize;
  }

  static bool isDesktop() {
    final nowWidth = (Get.context!).width;
    return nowWidth >= moreThanMediumScreenSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= largeScreenSize) {
          return extraLargeScreen ?? standardScreen;
        } else if ((constraints.maxWidth < largeScreenSize) &&
            constraints.maxWidth >= standardScreenSize) {
          return largeScreen ?? standardScreen;
        } else if (constraints.maxWidth < standardScreenSize &&
            constraints.maxWidth >= moreThanMediumScreenSize) {
          return standardScreen;
        } else if (constraints.maxWidth < moreThanMediumScreenSize &&
            constraints.maxWidth >= mediumScreenSize) {
          return moreThanMediumScreen ?? smallScreen;
        } else if (constraints.maxWidth < mediumScreenSize &&
            constraints.maxWidth >= smallScreenSize) {
          return mediumScreen ?? smallScreen;
        } else if (constraints.maxWidth < smallScreenSize &&
            constraints.maxWidth >= miniScreenSize) {
          return smallScreen;
        } else {
          return miniScreen ?? smallScreen;
        }
      },
    );
  }
}
