import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shppingmall/app/application.dart';
import 'package:shppingmall/routers/routers.dart';

///开屏页面
class AppSplashPage extends StatefulWidget {
  @override
  _AppSplashPageState createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  void initState() {
    Application.getSetting(() {
      Application.navigateTo(context, Routers.home, replace: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "欢迎",
            style: TextStyle(color: Colors.black, fontSize: 25.0),
          ),
        ),
      ),
    );
  }
}
