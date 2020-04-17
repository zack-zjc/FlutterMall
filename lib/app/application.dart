import 'package:dio/dio.dart';
import 'package:mall/routers/routers.dart';
import 'package:mall/utils/database.dart';
import 'package:mall/utils/network.dart';
import 'package:mall/utils/preference.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

class Application {
  ///网络地址
  static const String NET_BASE_URL = "";
  //主路由
  static Router router;

  ///路由跳转方法
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.inFromRight,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    if (params != null && params.isNotEmpty) {
      var resultPath = "$path?params=${Routers.encodeParam(params)}";
      return router.navigateTo(context, resultPath,
          replace: replace, clearStack: clearStack, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
    }
    return router.navigateTo(context, path,
        replace: replace, clearStack: clearStack, transition: transition, transitionDuration: transitionDuration, transitionBuilder: transitionBuilder);
  }

  ///初始化应用
  static Future<void> initApp() async {
    PreferenceUtil.initPreference();
    router = new Router();
    Routers.configureRoutes(router);
    initNetwork(enableCookie: true);
  }

  ///初始化网络库
  static void initNetwork(
      {String baseUrl = NET_BASE_URL,
      String contentType = Headers.jsonContentType,
      Map<String, dynamic> headers,
      ResponseType responseType = ResponseType.json,
      bool followRedirects = true,
      Transformer transformer,
      bool enableCookie: false}) {
    NetWorkUtil.getNetHelper()
        .setBaseOption(baseUrl: baseUrl, contentType: contentType, headers: headers, responseType: responseType, followRedirects: followRedirects);
    NetWorkUtil.getNetHelper().setDefaultTransformer(transformer);
    NetWorkUtil.getNetHelper().setCookieEnable(enableCookie);
  }

  ///设置网络请求代理，例如"PROXY 30.10.26.193:8888"
  static void setNetworkProxy(String proxy) {
    NetWorkUtil.getNetHelper().setProxy(proxy);
  }

  ///获取服务器数据
  static void getSetting(Function() complete) {
    //创建数据库
    DatabaseUnion.createCommonDatabase().then((result) {
      complete();
    });
  }
}
