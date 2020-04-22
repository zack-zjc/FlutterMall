import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mall/app/application.dart';
import 'package:mall/routers/routers.dart';
import 'package:mall/viewmodel/impl/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//全局的provider集合
List<SingleChildWidget> globalProvider = [
  //主题viewModel
  ChangeNotifierProvider<ThemeViewModel>(
    create: (context) => ThemeViewModel(),
  ),
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: globalProvider,
        child: Consumer<ThemeViewModel>(
          builder: (context, data, child) {
            return RefreshConfiguration(
              hideFooterWhenNotFull: true,
              headerBuilder: () => WaterDropHeader(),
              footerBuilder: () => ClassicFooter(),
              child: MaterialApp(
                debugShowCheckedModeBanner: !bool.fromEnvironment("dart.vm.product"),
                themeMode: data.userSetMode,
                theme: data.getAppTheme(false),
                darkTheme: data.getAppTheme(true),
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
              ),
            );
          },
        ));
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
