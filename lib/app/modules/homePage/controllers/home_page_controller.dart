import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import '../../../lockedFiles/common_models.dart';
import '../../../lockedFiles/common_widgets.dart';
import '../../tracking/views/tracking_view.dart';

class HomePageController extends GetxController {
  List<RunningData> recentActivitiesData = [];
  Location _location = Location();

  var methodChannel = MethodChannel("com.example.messages");
  RxBool isAlreadyRunning = false.obs;
  RxString geoStats = "".obs;

  @override
  void onInit() {
    methodChannel.setMethodCallHandler(_methodCallHandler);

    super.onInit();
  }

  @override
  void onReady() {
    isDataAvailable();
    super.onReady();
  }

  @override
  void onClose() {}

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    String method = call.method;

    print(
        "---------------------------------------------------------------->$method");
    if (method == 'isDataAvailable') {
      final map = call.arguments;

      print(
          "----======================================================>>>$map");

      geoStats.value = map["geoStats"].toString();
      isAlreadyRunning.value = geoStats.value == "start";
      if (isAlreadyRunning.value) {
        Get.to(() => const TrackingView());
      }
    }
  }

  Future<void> isDataAvailable() async {
    print(
        "================================================================03>>>");
    await methodChannel.invokeMethod("isDataAvailable");
  }

  Future<void> permissionCheck() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        myMaterialBanner({"message": "location service not enabled"},
            msgType: "error");
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        myMaterialBanner(
            {"message": "location permission denied, please retry"},
            msgType: "error");
        return;
      }
    }

    await _location.enableBackgroundMode();
    Get.to(() => const TrackingView());
  }
}
