import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'dart:ui' as ui;
import 'dart:math' show asin, cos, sqrt;

import '../../../lockedFiles/common_models.dart';
import '../../../dataModels/geo_stats.dart';
import '../../../lockedFiles/common_utils.dart';
import '../../homePage/controllers/home_page_controller.dart';

class TrackingController extends GetxController {
  RunningData? runningData;
  GoogleMapController? _controller;
  Location _location = Location();

  StreamSubscription<LocationData>? locationSubscription;
  LocationData? _currentPosition;
  LatLng initialcameraposition = LatLng(0.5937, 0.9629);

  RxMap<PolylineId, Polyline> polylines = Map<PolylineId, Polyline>().obs;
  RxList<LatLng> polylineCoordinatesList =
      List<LatLng>.empty(growable: true).obs;
  RxSet<Marker> markers = Set<Marker>().obs;

  RxDouble totalDistance = 0.0.obs;
  double lastDistance = 0;
  double pace = 0;
  double calorisvalue = 0;
  RxBool setaliteEnable = false.obs;
  RxBool startTrack = false.obs;
  String? timeValue = "";
  RxBool isBack = true.obs;

  double? avaragePace;
  double? finaldistance;
  double? finalspeed;

  double weight = 50;

  double currentSpeed = 0.0;
  int totalLowIntenseTime = 0;
  int totalModerateIntenseTime = 0;
  int totalHighIntenseTime = 0;

  late StopWatchTimer stopWatchTimer;
  bool kmSelected = true;

  RxBool isStartSet = false.obs;
  var methodChannel = MethodChannel("com.example.messages");
  Timer? _timer;

  RxList<GeoStats> tab1Data = List<GeoStats>.empty(growable: true).obs;

  final HomePageController homePageControllerHelper =
      Get.find<HomePageController>();

  @override
  void onInit() {
    runningData = RunningData();
    stopWatchTimer = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onChangeRawSecond: (value) {
          if (currentSpeed >= 1) {
            if (currentSpeed < 2.34) {
              totalLowIntenseTime += 1;
              log("Intensity ::::==> Low");
            } else if (currentSpeed < 4.56) {
              totalModerateIntenseTime += 1;
              log("Intensity ::::==> Moderate");
            } else {
              totalHighIntenseTime += 1;
              log("Intensity ::::==> High");
            }
          }
        },
        onChange: (value) {});

    methodChannel.setMethodCallHandler(_methodCallHandler);

    super.onInit();
  }

  @override
  Future onReady() async {
    startTrack.value = homePageControllerHelper.isAlreadyRunning.value;
    if (startTrack.value) {
      statusService();

      DateTime dt1 = DateTime.parse(getMyStorage("geoStart"));
      DateTime dt2 = DateTime.parse(DateTime.now().toString());

      Duration diff = dt2.difference(dt1);

      stopWatchTimer.setPresetSecondTime(diff.inSeconds);
      Timer(
        const Duration(milliseconds: 200),
        () => stopWatchTimer.onExecute.add(StopWatchExecute.start),
      );
    }

    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) _timer!.cancel();
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    String method = call.method;

    print(
        "---------------------------------------------------------------->$method");
    if (method == 'fetchLatestGeo') {
      final map = call.arguments;

      print(
          "----======================================================>>>$map");

      // toast('This is a $map');

      int prevData = tab1Data.length;
      tab1Data.clear();
      tab1Data.addAll(geoStatsFromJson(map["geoCoordinates"].toString()));

      // startTrack.value = tab1Data.length > 0;

      if (startTrack.value &&
          prevData != tab1Data.length &&
          tab1Data.length > 0) {
        print("--=---=-----====>>${tab1Data.length}");

        polylineCoordinatesList.clear();
        tab1Data.forEach((element) {
          polylineCoordinatesList.add(LatLng(element.a, element.b));
        });

        LatLng currentLocation =
            polylineCoordinatesList[polylineCoordinatesList.length - 1];

        if (!isStartSet.value) {
          LatLng startLocation = polylineCoordinatesList[0];

          runningData!.sLat = startLocation.latitude.toString();
          runningData!.sLong = startLocation.longitude.toString();
          LatLng startPinPosition = LatLng(double.parse(runningData!.sLat!),
              double.parse(runningData!.sLong!));

          final Uint8List markerIcon = await getBytesFromAsset(
              'assets/images/ic_map_pin_purple.png', 50);
          final Marker marker = Marker(
              icon: BitmapDescriptor.fromBytes(markerIcon),
              markerId: MarkerId('1'),
              position: startPinPosition);
          markers.add(marker);

          _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
            //code to run on every 5 seconds
            print(
                "================================================================>>>TTTimer2");
            statusService();
          });
          isStartSet.value = true;
        }

        /* lastDistance = calculateDistance(
            polylineCoordinatesList.last.latitude,
            polylineCoordinatesList.last.longitude,
            currentLocation.latitude,
            currentLocation.longitude);*/

        double conditionDistance;
        if (polylineCoordinatesList.length <= 2 && GetPlatform.isIOS) {
          conditionDistance = 0.03;
        } else {
          conditionDistance = 0.01;
        }

        /*  if (lastDistance >= conditionDistance) {
          totalDistance.value += calculateDistance(
              polylineCoordinatesList.last.latitude,
              polylineCoordinatesList.last.longitude,
              currentLocation.latitude,
              currentLocation.longitude); */

        /*  polylineCoordinatesList.add(
              LatLng(currentLocation.latitude!, currentLocation.longitude!)); */

        addPolyLine();

        _controller?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLocation,
              zoom: 20,
            ),
          ),
        );
        /* } else {
          log("Less Than 0.1: $lastDistance");
          return;
        } */
      }
    }
  }

  Future<void> startService() async {
    print(
        "================================================================01>>>");
    methodChannel.invokeMethod("startService");

    print(
        "================================================================>>>TTTimer1");

    setMyStorage("geoStart", DateTime.now().toString());

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      //code to run on every 5 seconds
      print(
          "================================================================>>>TTTimer2");
      statusService();
    });
  }

  Future<void> stopService() async {
    print(
        "================================================================02>>>");
    await methodChannel.invokeMethod("stopService");
  }

  Future<void> statusService() async {
    print(
        "================================================================03>>>");
    await methodChannel.invokeMethod("statusService");
  }

  // -----map===

  void onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    locationSubscription = _location.onLocationChanged.listen((l) {
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 20),
        ),
      );
      locationSubscription!.cancel();
    });
  }

  Future<void> animateToCenterofMap() async {
    LatLngBounds boundsFromLatLngList(List<LatLng> list) {
      assert(list.isNotEmpty);
      double? x0;
      double? x1;
      double? y0;
      double? y1;
      for (LatLng latLng in list) {
        if (x0 == null) {
          x0 = x1 = latLng.latitude;
          y0 = y1 = latLng.longitude;
        } else {
          if (latLng.latitude > x1!) x1 = latLng.latitude;
          if (latLng.latitude < x0) x0 = latLng.latitude;
          if (latLng.longitude > y1!) y1 = latLng.longitude;
          if (latLng.longitude < y0!) y0 = latLng.longitude;
        }
      }
      return LatLngBounds(
          northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
    }

    jsonEncode(polylineCoordinatesList);
    LatLngBounds latLngBounds = boundsFromLatLngList(polylineCoordinatesList);
    _controller!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  Future<void> calculationsForAllValues() async {
    avaragePace = 0;
    finaldistance = 0;
    finalspeed = 0;
    finaldistance = double.parse(totalDistance.value.toStringAsFixed(2));
    finalspeed = double.parse(avaragePace!.toStringAsFixed(2));
    // runningData!.date = DateFormat.yMMMd().format(DateTime.now()).toString();
    int hr = int.parse(timeValue!.split(":")[0]);
    int min = int.parse(timeValue!.split(":")[1]);
    int sec = int.parse(timeValue!.split(":")[2]);
    int totalTimeInSec = (hr * 3600) + (min * 60) + (sec);
    avaragePace = totalTimeInSec / (finaldistance! * 60);

    runningData!.duration = totalTimeInSec;
    runningData!.speed = double.parse(avaragePace!.toStringAsFixed(2));
    runningData!.distance = finaldistance;
    runningData!.cal = double.parse(calorisvalue.toStringAsFixed(2));
    runningData!.lowIntenseTime = totalLowIntenseTime;
    runningData!.moderateIntenseTime = totalModerateIntenseTime;
    runningData!.highIntenseTime = totalHighIntenseTime;
  }

  getLoc() async {
    _location.changeSettings(
      accuracy: LocationAccuracy.high,
    );

    /* geoLocator.Geolocator.getPositionStream(
      locationSettings: geoLocator.LocationSettings(
          accuracy: geoLocator.LocationAccuracy.medium),
    ).listen((position) {
      if (polylineCoordinatesList.length >= 2) {
        var speedInMps = position.speed;
        var speedKmpm = speedInMps * 0.06;
        currentSpeed = speedKmpm * 60;
        pace = 1 / speedKmpm;
      }
    }); */

    _currentPosition = await _location.getLocation();
    initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

    // setMyStorage('ogLatitude', _currentPosition!.latitude!);
    // setMyStorage('ogLongitude', _currentPosition!.longitude!);

    if (polylineCoordinatesList.isEmpty) {
      polylineCoordinatesList.add(
          LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));

      runningData!.sLat = _currentPosition!.latitude!.toString();
      runningData!.sLong = _currentPosition!.longitude!.toString();
      LatLng startPinPosition = LatLng(
          double.parse(runningData!.sLat!), double.parse(runningData!.sLong!));

      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/ic_map_pin_purple.png', 50);
      final Marker marker = Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: MarkerId('1'),
          position: startPinPosition);
      markers.add(marker);

      isStartSet.value = true;
    }

    startService();

    /* locationSubscription = _location.onLocationChanged
        .listen((LocationData currentLocation) async {
      log("${currentLocation.latitude} : ${currentLocation.longitude}");
    }); */
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine() {
    log("add red polyline");
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinatesList,
      width: 4,
    );
    polylines[id] = polyline;
  }
}
