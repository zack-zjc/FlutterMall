import 'package:flutter/material.dart';
import 'package:mall/utils/preference.dart';
import 'package:mall/viewmodel/base_view_model.dart';
import 'package:provider/provider.dart';

class ThemeUtil {
  ///设置用户主题Model是否黑暗模式等
  static void setThemeModel(BuildContext context, ThemeMode model) {
    Provider.of<ThemeViewModel>(context, listen: false).setUserThemeModel(context, model);
  }

  ///设置系统主题Model是否黑暗模式等
  static void setSystemThemeModel(BuildContext context) {
    Provider.of<ThemeViewModel>(context, listen: false).updateSystemModel(context);
  }
}

//全局主题的viewModel
class ThemeViewModel extends BaseViewModel {
  //用户设置是否黑暗模式
  ThemeMode userSetMode = _getUserSetModel();

  ///更新系统模式
  void updateSystemModel(BuildContext context) {
    if (userSetMode == ThemeMode.system){
      notifyListeners();
    }
  }

  ///设置当前应用的模式
  void setUserThemeModel(BuildContext context, ThemeMode model) {
    if (model != userSetMode) {
      _saveUserThemeModel(model);
      userSetMode = model;
      notifyListeners();
    }
  }

  ///获取主题样式
  ThemeData getAppTheme(bool dark) {
    return ThemeData(
        //自定义主色调白色
        primaryColor: dark ? Colors.blue : Colors.white,
        //自定义window背景透明
        backgroundColor: Colors.transparent,
        //自定义界面背景
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        //自定义appbar样式
        appBarTheme: _getCustomAppBarTheme(),
        //自定义文字样式
        textTheme: TextTheme(
          //自定义文字样式
          title: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
          subtitle: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
          display1: TextStyle(fontSize: 10.0, color: Colors.white),
          display2: TextStyle(fontSize: 12.0, color: Colors.white),
          display3: TextStyle(fontSize: 15.0, color: Colors.white),
          display4: TextStyle(fontSize: 18.0, color: Colors.white),
        ));
  }

  ///获取自定义appBar的样式
  AppBarTheme _getCustomAppBarTheme() {
    return AppBarTheme(
        //appbar背景颜色
        color: Colors.white,
        textTheme: TextTheme(
            //标题样式
            title: TextStyle(fontSize: 20.0, color: Colors.black),
            //子标题右上角文字操作样式
            subtitle: TextStyle(fontSize: 16.0, color: Colors.black)),
        //右上角icon操作样式
        iconTheme: IconThemeData(
          color: Colors.black,
          size: kToolbarHeight,
        ));
  }
}

///存储用户设置模式
void _saveUserThemeModel(ThemeMode model) {
  if (model == ThemeMode.system) {
    PreferenceUtil.saveInt("userThemeMode", 0);
  } else if (model == ThemeMode.light) {
    PreferenceUtil.saveInt("userThemeMode", 1);
  } else {
    PreferenceUtil.saveInt("userThemeMode", 2);
  }
}

///获取用户是否设置模式
ThemeMode _getUserSetModel() {
  var modelIndex = PreferenceUtil.getInt("userThemeMode");
  if (modelIndex == 0) {
    return ThemeMode.system;
  } else if (modelIndex == 1) {
    return ThemeMode.light;
  }
  return ThemeMode.dark;
}
