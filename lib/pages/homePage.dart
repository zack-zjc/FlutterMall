import 'package:mall/pages/base/AppBasePage.dart';
import 'package:mall/viewmodel/impl/theme_view_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBasePage(
      bodyWidget: Container(
        color: Theme.of(context).primaryColor,
        child: GestureDetector(
          onTap: () {
            ThemeUtil.setThemeModel(context, ThemeMode.light);
          },
          child: Center(
            child: Text("测试"),
          ),
        ),
      ),
      title: "哈哈",
    );
  }
}
