import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shppingmall/utils/log.dart';
import 'package:shppingmall/viewmodel/base_list_view_model.dart';
import 'package:shppingmall/viewmodel/base_view_model.dart';
import 'package:shppingmall/viewmodel/view_state_widget.dart';

///provider的封装类，方便使用独立控件使用
///listen:是否添加根部consumer
class ProviderWidget<T extends BaseViewModel> extends StatefulWidget {
  //consumer-builder
  final ValueWidgetBuilder<T> builder;
  //子widget,与model无关不需要刷新的控件，
  final Widget child;
  //数据源
  final T model;
  //处理model数据
  final Function(T model) onModelReady;
  //是否添加监听根consumer
  final bool listen;

  ProviderWidget({
    Key key,
    @required this.model,
    this.builder,
    this.child,
    this.onModelReady,
    this.listen: true,
  })  : assert(model != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends BaseViewModel> extends State<ProviderWidget<T>> {
  T _model;

  @override
  void initState() {
    _model = widget.model;
    _model.initState();
    widget.onModelReady?.call(_model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listen) {
      return ChangeNotifierProvider<T>(
        create: (context) => _model,
        child: Consumer<T>(
          builder: (context, data, child) {
            //添加刷新打印
            LogUtil.debug("rebuild:provider:model=${T.toString()}");
            return widget.builder(context, data, child);
          },
          child: widget.child,
        ),
      );
    }
    if (widget.builder != null) {
      return ChangeNotifierProvider<T>(
        create: (context) => _model,
        child: widget.builder(context, _model, widget.child),
      );
    }
    return ChangeNotifierProvider<T>(
      create: (context) => _model,
      child: widget.child,
    );
  }
}

///provider的封装类，方便使用
///封装下拉刷新控件
class ProviderListPageWidget<T extends BaseListViewModel> extends StatefulWidget {
  //consumer-builder
  final ValueWidgetBuilder<T> builder;
  //子widget,与model无关不需要刷新的控件，
  final Widget child;
  //数据源
  final T model;
  //处理model数据
  final Function(T model) onModelReady;
  //是否添加监听根consumer
  final bool listen;
  //是否可下拉
  final enableRefresh;
  //是否可上拉
  final enableLoadMore;
  //刷新控制器
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  ProviderListPageWidget({
    Key key,
    @required this.builder,
    @required this.model,
    this.child,
    this.onModelReady,
    this.listen: true,
    this.enableRefresh: true,
    this.enableLoadMore: true,
  })  : assert(builder != null),
        assert(model != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _ProviderListPageWidgetState<T>();
}

class _ProviderListPageWidgetState<T extends BaseListViewModel> extends State<ProviderListPageWidget<T>> {
  T _model;

  @override
  void initState() {
    _model = widget.model;
    _model.initState();
    widget.onModelReady?.call(_model);
    _model.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listen) {
      return ChangeNotifierProvider<T>(
        create: (context) => _model,
        child: Consumer<T>(
          builder: _getBuildWidget,
          child: widget.child,
        ),
      );
    }
    return ChangeNotifierProvider<T>(
      create: (context) => _model,
      child: _getRefreshWidget(context, _model, widget.child),
    );
  }

  ///根据装填获取widget
  Widget _getBuildWidget(BuildContext context, T data, Widget child) {
    //添加刷新打印
    LogUtil.debug("rebuild:provider:model=${T.toString()}");
    if (_model.isLoading()) {
      return ViewStateLoadingWidget();
    } else if (_model.isEmpty()) {
      return ViewStateEmptyWidget();
    } else if (_model.isError()) {
      return ViewStateErrorWidget();
    }
    return _getRefreshWidget(context, data, child);
  }

  ///获取刷新控件
  Widget _getRefreshWidget(BuildContext context, T data, Widget child) {
    return ChangeNotifierProvider<T>(
      create: (context) => _model,
      child: SmartRefresher(
        controller: widget._refreshController,
        enablePullDown: widget.enableRefresh,
        enablePullUp: widget.enableLoadMore,
        onRefresh: () => _model.refresh(() {
          widget._refreshController.refreshCompleted(resetFooterState: true);
        }),
        onLoading: () => _model.loadMore((all) {
          if (all) {
            widget._refreshController.loadNoData();
          } else {
            widget._refreshController.loadComplete();
          }
        }),
        child: widget.builder(context, data, child),
      ),
    );
  }
}
