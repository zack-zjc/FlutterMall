import 'package:mall/utils/preference.dart';
import 'package:mall/viewmodel/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeUtil {
  ///设置用户主题Model是否黑暗模式等
  static void setThemeModel(BuildContext context, ThemeModel model) {
    Provider.of<ThemeViewModel>(context, listen: false).setUserThemeModel(context, model);
  }

  ///设置系统主题Model是否黑暗模式等
  static void setSystemThemeModel(BuildContext context) {
    Provider.of<ThemeViewModel>(context, listen: false).updateSystemModel(context);
  }
}

//全局主题的viewModel
class ThemeViewModel extends BaseViewModel {
  //系统设置是否黑暗模式
  bool isSystemDarkModel = false;
  //用户设置是否黑暗模式
  ThemeModel userSetModel = _getUserSetModel();

  ///初始化系统设置
  void initSystemModel() {
    isSystemDarkModel = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  ///更新系统模式
  void updateSystemModel(BuildContext context) {
    var updateModel = MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (updateModel != isSystemDarkModel) {
      isSystemDarkModel = updateModel;
      notifyListeners();
    }
  }

  ///设置当前应用的模式
  void setUserThemeModel(BuildContext context, ThemeModel model) {
    if (model != userSetModel) {
      _saveUserThemeModel(model);
      userSetModel = model;
      notifyListeners();
    }
  }

  ///当前是否黑暗模式
  bool _isCurrentDarkModel() {
    if (userSetModel == ThemeModel.SYSTEM) {
      return isSystemDarkModel;
    } else {
      return userSetModel == ThemeModel.DARK;
    }
  }

  ///获取主题样式
  ThemeData getAppTheme() {
    bool dark = _isCurrentDarkModel();
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

enum ThemeModel {
  //跟随系统
  SYSTEM,

  //明亮模式
  LIGHT,

  //黑暗模式
  DARK,
}

///存储用户设置模式
void _saveUserThemeModel(ThemeModel model) {
  if (model == ThemeModel.SYSTEM) {
    PreferenceUtil.saveInt("userDarkModel", 0);
  } else if (model == ThemeModel.LIGHT) {
    PreferenceUtil.saveInt("userDarkModel", 1);
  } else {
    PreferenceUtil.saveInt("userDarkModel", 2);
  }
}

///获取用户是否设置模式
ThemeModel _getUserSetModel() {
  var modelIndex = PreferenceUtil.getInt("userDarkModel");
  if (modelIndex == 0) {
    return ThemeModel.SYSTEM;
  } else if (modelIndex == 1) {
    return ThemeModel.LIGHT;
  }
  return ThemeModel.DARK;
}
