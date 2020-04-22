import 'package:flutter/material.dart';
import 'package:mall/viewmodel/impl/theme_view_model.dart';

///封装的页面基类
abstract class AppBasePage extends StatefulWidget {
  @override
  _AppBasePageState createState() => _AppBasePageState();

  ///是否展示头部bar
  bool showAppBar() => true;

  ///获取标题
  String getTitle(BuildContext context) => "";

  ///获取menu文字
  String getActionText(BuildContext context) => null;

  ///获取menu本地图片
  String getActionImage(BuildContext context) => null;

  ///获取menu点击事件
  VoidCallback getMenuCallback(BuildContext context) => null;

  ///初始化相关操作
  void didInitState(BuildContext context) {}

  ///dispose相关操作
  void didDispose(BuildContext context) {}

  ///获取页面body
  Widget getBody(BuildContext context);
}

//是否展示欢迎页
bool showSplashPage = false;

class _AppBasePageState extends State<AppBasePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this.widget.didInitState(context);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    this.widget.didDispose(context);
  }

  @override
  void didChangePlatformBrightness() {
    ThemeUtil.setSystemThemeModel(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      showSplashPage = true;
    } else if (state == AppLifecycleState.resumed) {
      if (showSplashPage) {
        showSplashPage = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.showAppBar()) {
      return Scaffold(
        appBar: CustomAppBar(
            title: this.widget.getTitle(context),
            actionText: this.widget.getActionText(context),
            actionImage: this.widget.getActionImage(context),
            tapCallback: this.widget.getMenuCallback(context)),
        body: Builder(
          builder: (builderContext) => this.widget.getBody(builderContext),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
    }
    return Scaffold(
      body: Builder(
        builder: (builderContext) => this.widget.getBody(builderContext),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

///自定义的appbar
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  //标题
  final String title;
  //右上角操作点击事件
  final VoidCallback tapCallback;
  //更多文字操作
  final String actionText;
  //更多操作本地图片
  final String actionImage;

  CustomAppBar({
    Key key,
    this.title,
    this.actionText,
    this.actionImage,
    this.tapCallback,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      //appbar背景使用主题的主色调
      backgroundColor: Theme.of(context).appBarTheme.color,
      //按钮的样式
      iconTheme: Theme.of(context).appBarTheme.iconTheme,
      centerTitle: true,
      //appbar文字使用主题的配置
      title: Text(
        this.widget.title ?? "",
        style: Theme.of(context).appBarTheme.textTheme.headline1,
      ),
      actions: _getActions(),
    );
  }

  ///获取更多操作
  _getActions() {
    var action = _getActionWidget();
    if (action == null) return null;
    return [
      GestureDetector(
        onTap: this.widget.tapCallback ?? () {},
        child: Container(
          width: kToolbarHeight,
          height: kToolbarHeight,
          child: action,
        ),
      )
    ];
  }

  ///获取自定义更多操作按钮
  _getActionWidget() {
    var widgetSize = Theme.of(context).appBarTheme.actionsIconTheme.size;
    if (this.widget.actionImage != null) {
      return Image.asset(
        this.widget.actionImage,
        width: widgetSize,
        height: widgetSize,
        fit: BoxFit.contain,
      );
    }
    if (this.widget.actionText != null) {
      return Container(
        width: widgetSize,
        height: widgetSize,
        alignment: Alignment.center,
        child: Text(
          this.widget.actionText,
          style: Theme.of(context).appBarTheme.textTheme.headline2,
        ),
      );
    }
    return null;
  }
}
