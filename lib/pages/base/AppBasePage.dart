import 'package:flutter/material.dart';
import 'package:mall/viewmodel/impl/theme_view_model.dart';

class AppBasePage extends StatefulWidget {
  //中间的body
  final Widget bodyWidget;
  //页面标题
  final String title;
  //是否展示appbar
  final bool showAppBar;
  //右上角点击事件
  final VoidCallback menuCallback;
  //更多文字操作
  final String actionText;
  //更多操作本地图片
  final String actionImage;

  AppBasePage({
    Key key,
    @required this.bodyWidget,
    this.title,
    this.menuCallback,
    this.showAppBar: true,
    this.actionText,
    this.actionImage,
  }) : super(key: key);

  @override
  _AppBasePageState createState() => _AppBasePageState();
}

class _AppBasePageState extends State<AppBasePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    ThemeUtil.setSystemThemeModel(context);
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.showAppBar) {
      return Scaffold(
        appBar: CustomAppBar(
            title: this.widget.title, actionText: this.widget.actionText, actionImage: this.widget.actionImage, tapCallback: this.widget.menuCallback),
        body: this.widget.bodyWidget,
      );
    }
    return Scaffold(
      body: this.widget.bodyWidget,
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
  })  : assert(title != null),
        super(key: key);

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
    var widgetSize = Theme.of(context).appBarTheme.iconTheme.size;
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
