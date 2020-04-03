import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mall/utils/log.dart';
import 'package:mall/viewmodel/base_view_model.dart';

///封装selector的相关使用
///添加了答应用于优化控件刷新
class ProviderSelectorWidget<T extends BaseViewModel, R> extends StatefulWidget {
  //selector-builder
  final ValueWidgetBuilder<R> builder;
  //选择刷新控件对应数值
  final R Function(BuildContext, T) selector;
  //子控件
  final Widget child;
  //model
  final T model;

  ProviderSelectorWidget({
    Key key,
    @required this.builder,
    @required this.selector,
    this.child,
    this.model,
  })  : assert(builder != null),
        assert(selector != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderSelectorWidgetState<T, R>();
}

class _ProviderSelectorWidgetState<T extends BaseViewModel, R> extends State<ProviderSelectorWidget<T, R>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: this.widget.model ?? Provider.of<T>(context),
      child: Selector<T, R>(
        selector: widget.selector,
        shouldRebuild: (previous, next) {
          LogUtil.debug("ProviderSelectorWidget-shouldRebuild=${previous != next}-"
              "pre=${previous.toString()}-next=${next.toString()}");
          return previous != next;
        },
        builder: (context, data, child) {
          //添加刷新打印
          LogUtil.debug("rebuild:selector:model=${T.toString()}");
          return widget.builder(context, data, child);
        },
        child: widget.child,
      ),
    );
  }
}
