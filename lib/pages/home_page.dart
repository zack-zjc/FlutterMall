import 'package:flutter/material.dart';
import 'package:mall/pages/base/app_base_page.dart';
import 'package:mall/viewmodel/impl/theme_view_model.dart';

class MyHomePage extends AppBasePage {
  @override
  Widget getBody(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: GestureDetector(
        onTap: () {
          ThemeUtil.setThemeModel(context, ThemeMode.light);
        },
        child: Center(
          child: Text("测试"),
        ),
      ),
    );
  }
}
