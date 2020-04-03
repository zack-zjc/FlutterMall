import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mall/app/application.dart';
import 'package:mall/routers/routers.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: !bool.fromEnvironment("dart.vm.product"),
      onGenerateRoute: Application.router.generator,
      initialRoute: Routers.root,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        //只配置显示中文
        const Locale.fromSubtags(languageCode: 'zh'),
//                  const Locale.fromSubtags(languageCode: 'en'),
      ],
    );
  }
}

void main() async {
  //Provider 状态管理，同步数据
  Provider.debugCheckInvalidValueType = null;
  //WidgetsFlutterBinding 承担各类的初始化以及功能配置
  WidgetsFlutterBinding.ensureInitialized();
  //初始化应用
  Application.initApp();
  //打开主页
  runApp(MyApp());
  // 调整状态栏颜色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light));
}
