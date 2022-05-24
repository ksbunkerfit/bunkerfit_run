import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lockedFiles/common_utils.dart';

class ThemeService {
  bool isDarkMode = getMyStorage('isDarkMode') as bool;

  ThemeMode getThemeMode() {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void changeThemeMode() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    setMyStorage('isDarkMode', !isDarkMode);
  }
}
// ThemeService().changeThemeMode();
