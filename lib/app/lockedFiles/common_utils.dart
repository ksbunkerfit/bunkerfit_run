import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../dynamicFiles/project_constants.dart';

void setMyStorage(String keyName, dynamic keyValue) =>
    GetStorage(localStore).write(keyName, keyValue);

void setMyStorageIfNull(String keyName, dynamic keyValue) =>
    GetStorage(localStore).writeIfNull(keyName, keyValue);

dynamic getMyStorage(String keyName) => GetStorage(localStore).read(keyName);

Future setupDefaultStorage() async {
  setMyStorageIfNull('isDarkMode', false);
}

class EmptyFailureNoInternetView extends StatelessWidget {
  const EmptyFailureNoInternetView({
    required this.image,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                image,
                height: 250,
                width: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
