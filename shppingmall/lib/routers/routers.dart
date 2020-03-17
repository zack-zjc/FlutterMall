import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:shppingmall/routers/router_list.dart';

import 'router_handler.dart';

class Routers {
  static const String root = "/";
  static const String splash = "/splash";
  static const String home = "/home";

  ///配置路由
  static void configureRoutes(Router router) {
    router.define(root, handler: splashHandler);
    RouterList.routerList.forEach((path, buildRouter) {
      var handler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return buildRouter(context, params);
        },
      );
      router.define(path, handler: handler);
    });
  }

  ///加密数据,处理传递中文的问题
  static String encodeParam(dynamic value) {
    String jsonString = jsonEncode(value);
    return jsonEncode(Utf8Encoder().convert(jsonString));
  }

  ///解密数据,处理传递中文的问题
  static dynamic decodeParam(String param) {
    var list = List<int>();
    jsonDecode(param).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    return json.decode(value);
  }
}
