import 'dart:ui';

import 'package:flutter/foundation.dart';

// const bool useDevMode = true;
const bool useDevMode = false;

const bool isDevMode = !kReleaseMode && useDevMode;

const String baseUrl =
    isDevMode ? 'http://localhost:4107/_api/' : 'https://www.website.com/_api/';

const String baseMediaUrl = isDevMode
    ? 'http://localhost:4107/_media/'
    : 'https://www.website.com/_media/';

const String localStore = 'runAppStore';

const String playStoreInfo = 'com.bunkerfit';
const String appStoreInfo = 'appid';

const primaryLocale = Locale('en', 'US');
const secondaryLocale = Locale('hi', 'IN');
