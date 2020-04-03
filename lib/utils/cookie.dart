
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';


class CookieHelper {

  final _lock = new Lock();

  PersistCookieJar _persistCookieJar;

  ///获取cookieJar实例
  Future<PersistCookieJar> getCookieJar() async{
    if (_persistCookieJar == null){
      await _lock.synchronized(() async {
        if (_persistCookieJar == null) {
          Directory documentsDir = await getApplicationDocumentsDirectory();
          String documentsPath = documentsDir.path;
          var dir = new Directory("$documentsPath/cookies");
          await dir.create();
          _persistCookieJar = PersistCookieJar(dir: dir.path);
        }
      });
    }
    return _persistCookieJar;
  }

  ///清楚所有cookie
  Future<void> clearCookie() async {
    PersistCookieJar cookieJar = await getCookieJar();
    cookieJar.deleteAll();
  }

}