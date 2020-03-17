

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {

  //实例对象
  static SharedPreferences _sharedPreferences;

  ///初始化preference
  static Future<void> initPreference() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ///获取轻量存储int值
  int getInt(String key,{int defaultValue}) {
    if (_sharedPreferences == null) return defaultValue ?? 0;
    return _sharedPreferences.getInt(key);
  }

  ///轻量存储int值
  Future<bool> saveInt(String key,int intValue) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setInt(key, intValue);
  }

  ///获取轻量存储bool值
  bool getBool(String key,{bool defaultValue}) {
    if (_sharedPreferences == null) return defaultValue ?? false;
    return _sharedPreferences.getBool(key);
  }

  ///轻量存储bool值
  Future<bool> saveBool(String key,bool boolValue) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setBool(key, boolValue);
  }

  ///获取轻量存储string值
  String getString(String key,{String defaultValue}) {
    if (_sharedPreferences == null) return defaultValue ?? "";
    return _sharedPreferences.getString(key);
  }

  ///轻量存储string值
  Future<bool> saveString(String key,String stringValue) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setString(key, stringValue);
  }

  ///获取轻量存储double值
  double getDouble(String key,{double defaultValue}) {
    if (_sharedPreferences == null) return defaultValue ?? 0.0;
    return _sharedPreferences.getDouble(key);
  }

  ///轻量存储double值
  Future<bool> saveDouble(String key,double doubleValue) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setDouble(key, doubleValue);
  }

  ///获取轻量存储stringList值
  List<String> getStringList(String key) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.getStringList(key);
  }

  ///轻量存储stringList值
  Future<bool> saveStringList(String key,List<String> stringList) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.setStringList(key, stringList);
  }

  ///移除存储的变量
  Future<bool> removeKey(String key) {
    if (_sharedPreferences == null) return null;
    return _sharedPreferences.remove(key);
  }

}