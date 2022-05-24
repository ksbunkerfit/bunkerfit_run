import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../lockedFiles/common_constants.dart';
import '../../../lockedFiles/common_widgets.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;

    return WrapPageWithUnfocusSafeArea(
      context: context,
      child: Scaffold(
        backgroundColor: common_bg_dark,
        appBar: AppBar(
          title: const Text('BUNKERFIT'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 30,
                        left: fullWidth * 0.05,
                        right: fullWidth * 0.05),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Recent Run Activities",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              itemCount: controller.recentActivitiesData.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RunHistoryDetailScreen(
                                                    recentActivitiesData[
                                                        index]))); */
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: progress_background_color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(13.0),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            child: Image.file(
                                              controller
                                                  .recentActivitiesData[index]
                                                  .getImage()!,
                                              errorBuilder: (
                                                BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace,
                                              ) {
                                                return Image.asset(
                                                  "assets/images/ic_route_map.png",
                                                  height: 90,
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                        .recentActivitiesData[
                                                            index]
                                                        .date!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        controller
                                                            .recentActivitiesData[
                                                                index]
                                                            .distance!
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 21,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                top: 4),
                                                        child: Text(
                                                          "km",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: fullHeight * 0.01),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          controller
                                                              .recentActivitiesData[
                                                                  index]
                                                              .duration!
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                              color: txt_grey),
                                                        ),
                                                        Text(
                                                          controller
                                                                      .recentActivitiesData[
                                                                          index]
                                                                      .speed !=
                                                                  null
                                                              ? controller
                                                                  .recentActivitiesData[
                                                                      index]
                                                                  .speed!
                                                                  .toStringAsFixed(
                                                                      2)
                                                              : "-",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 15,
                                                              color: txt_grey),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .recentActivitiesData[
                                                                      index]
                                                                  .cal!
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 15,
                                                                  color:
                                                                      txt_grey),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          3.0),
                                                              child: Text(
                                                                "KCAL",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        txt_grey),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () => controller.permissionCheck(),
          child: Container(
            height: 75,
            width: 75,
            child: Image.asset(
              "assets/images/ic_person_bottombar.webp",
              height: 45,
              width: 45,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
