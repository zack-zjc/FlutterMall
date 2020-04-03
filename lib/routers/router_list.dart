import 'package:flutter/material.dart';
import 'package:mall/pages/app_splash_page.dart';
import 'package:mall/routers/routers.dart';

import '../homePage.dart';

class RouterList {
  ///注册的路由
  static final Map<String, Widget Function(BuildContext context, Map<String, List<String>> params)> routerList = {
    Routers.home: (context, params) => MyHomePage(),
    Routers.splash: (context, params) => AppSplashPage(),
  };
}
