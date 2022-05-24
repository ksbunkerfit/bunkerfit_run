import 'dart:async';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class WrapPageWithUnfocusSafeArea extends StatelessWidget {
  const WrapPageWithUnfocusSafeArea({
    Key? key,
    required this.context,
    this.exitApp = false,
    required this.child,
  }) : super(key: key);

  final BuildContext context;
  final bool exitApp;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: exitApp
            ? DoubleBack(
                onFirstBackPress: (context) {
                  ScaffoldMessenger.of(context as BuildContext).showSnackBar(
                    const SnackBar(content: Text('Press back again to exit')),
                  );
                },
                child: child,
              )
            : child,
      ),
    );
  }
}

void myMaterialBanner(Map receivedData, {String msgType = "success"}) {
  final context = Get.context!;

  IconData useIcon = MaterialCommunityIcons.cloud_check_outline;
  Color useTextColor = Colors.black;
  Color useBackground = Colors.yellow;
  Color useDismiss = Colors.blue;
  if (msgType == "error") {
    useIcon = MaterialIcons.error_outline;
    useTextColor = Colors.white;
    useBackground = Colors.red;
    useDismiss = Colors.yellow;
  } else if (msgType == "warning") {
    useIcon = Ionicons.warning_outline;
    useTextColor = Colors.black;
    useBackground = Colors.orange;
    useDismiss = Colors.black;
  }

  Timer(
    const Duration(milliseconds: 500),
    () => ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsetsDirectional.only(start: 10.0),
        content: Text(
          receivedData["message"].toString(),
          style: TextStyle(
            color: useTextColor,
          ),
        ),
        leading: Icon(useIcon),
        backgroundColor: useBackground,
        actions: [
          TextButton(
            child: Text(
              'Dismiss',
              style: TextStyle(
                color: useDismiss,
              ),
            ),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
        ],
        onVisible: () => Timer(
          const Duration(seconds: 1),
          () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        ),
      ),
    ),
  );
}
