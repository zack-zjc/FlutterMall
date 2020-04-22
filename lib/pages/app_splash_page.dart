import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mall/app/application.dart';
import 'package:mall/pages/base/app_base_page.dart';
import 'package:mall/routers/routers.dart';

///开屏页面
class AppSplashPage extends AppBasePage {
  @override
  void didInitState(BuildContext context) {
    super.didInitState(context);
    Application.getSetting(() {
      Application.navigateTo(context, Routers.home, replace: true);
    });
  }

  @override
  Widget getBody(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "欢迎",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
      ),
    );
  }
}
