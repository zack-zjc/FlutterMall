import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:mall/utils/log.dart';
import 'package:mall/viewmodel/base_view_model.dart';

///consumer封装的控件，添加打印用于优化刷新
class ProviderConsumerWidget<T extends BaseViewModel> extends StatefulWidget {
  //selector-builder
  final ValueWidgetBuilder<T> builder;
  //子控件
  final Widget child;
  //数据源
  final T model;

  ProviderConsumerWidget({
    Key key,
    @required this.builder,
    this.child,
    this.model,
  })  : assert(builder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderConsumerWidgetState<T>();
}

class _ProviderConsumerWidgetState<T extends BaseViewModel> extends State<ProviderConsumerWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: this.widget.model ?? Provider.of<T>(context),
      child: Consumer<T>(
        builder: (context, data, child) {
          //添加刷新打印
          LogUtil.debug("rebuild:consumer:model=${T.toString()}");
          return widget.builder(context, data, child);
        },
        child: widget.child,
      ),
    );
  }
}

///consumer封装的控件，添加打印用于优化刷新
class ProviderConsumerWidget2<T extends BaseViewModel, R extends BaseViewModel> extends StatefulWidget {
  //selector-builder
  final Widget Function(BuildContext context, T value, R value2, Widget child) builder;
  //子控件
  final Widget child;
  //数据源
  final T model;
  //数据源
  final R model2;

  ProviderConsumerWidget2({
    Key key,
    @required this.builder,
    this.child,
    this.model,
    this.model2,
  })  : assert(builder != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderConsumerWidgetState2<T, R>();
}

class _ProviderConsumerWidgetState2<T extends BaseViewModel, R extends BaseViewModel> extends State<ProviderConsumerWidget2<T, R>> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: this.widget.model ?? Provider.of<T>(context)),
        ChangeNotifierProvider.value(value: this.widget.model2 ?? Provider.of<R>(context))
      ],
      child: Consumer2<T, R>(
        builder: (context, t, r, child) {
          //添加刷新打印
          LogUtil.debug("rebuild:consumer:model=${T.toString()}");
          return widget.builder(context, t, r, child);
        },
        child: widget.child,
      ),
    );
  }
}
