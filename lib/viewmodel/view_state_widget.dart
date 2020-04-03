import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// 加载中
class ViewStateLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

/// 数据加载为空页面
class ViewStateEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("数据为空"));
  }
}

/// 数据加载失败页面
class ViewStateErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("加载失败"));
  }
}
