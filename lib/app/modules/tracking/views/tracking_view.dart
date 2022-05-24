import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../lockedFiles/common_constants.dart';
import '../../../lockedFiles/common_widgets.dart';
import '../../../lockedFiles/local_notify.dart';
import '../controllers/tracking_controller.dart';

class TrackingView extends GetView<TrackingController> {
  const TrackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;

    return WrapPageWithUnfocusSafeArea(
      context: context,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text('TrackingView'),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 20),
                width: fullWidth,
                color: color_run,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: StreamBuilder<int>(
                                stream: controller.stopWatchTimer.rawTime,
                                initialData:
                                    controller.stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data;
                                  final displayTime = value != null
                                      ? StopWatchTimer.getDisplayTime(value,
                                          hours: true,
                                          minute: true,
                                          second: true,
                                          milliSecond: false)
                                      : null;
                                  controller.timeValue = displayTime;
                                  return Text(
                                    displayTime ?? "00:00:00",
                                    style: TextStyle(
                                        fontSize: 60,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "min",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    controller.totalDistance.value
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  "km",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: controller.initialcameraposition, zoom: 18),
                    mapType: controller.setaliteEnable.value
                        ? MapType.satellite
                        : MapType.normal,
                    onMapCreated: controller.onMapCreated,
                    buildingsEnabled: false,
                    markers: controller.markers,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomGesturesEnabled: true,
                    polylines: Set<Polyline>.of(controller.polylines.values),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "google_maps_widget_",
            tooltip: "Play & Stop",
            onPressed: () async {
              if (controller.startTrack.value) {
                controller.locationSubscription!.pause();
                controller.stopWatchTimer.onExecute.add(StopWatchExecute.stop);

                controller.startTrack.value = false;

                if (controller.polylineCoordinatesList.length >= 1) {
                  controller.runningData!.eLat = controller
                      .polylineCoordinatesList.last.latitude
                      .toString();
                  controller.runningData!.eLong = controller
                      .polylineCoordinatesList.last.longitude
                      .toString();
                } else {
                  Get.back();
                  return;
                }

                await controller.animateToCenterofMap();

                await controller.calculationsForAllValues().then((value) async {
                  Get.back();
                });
              } else {
                Future.delayed(Duration(milliseconds: 500), () {
                  controller.isBack.value = false;
                  controller.startTrack.value = true;

                  if (controller.locationSubscription != null &&
                      controller.locationSubscription!.isPaused)
                    controller.locationSubscription!.resume();
                  else
                    controller.getLoc();
                  controller.stopWatchTimer.onExecute
                      .add(StopWatchExecute.start);

                  showNotification(
                    title: "Bunkerfit",
                    body: "Running Time",
                    payload: "myNotify",
                  );
                });
              }
            },
            child: Icon(
                controller.startTrack.value
                    ? Icons.stop
                    : Icons.play_arrow_rounded,
                size: 34),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
