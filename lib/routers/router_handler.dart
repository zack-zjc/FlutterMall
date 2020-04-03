import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:mall/pages/app_splash_page.dart';

// app的开屏页
var splashHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new AppSplashPage();
  },
);
