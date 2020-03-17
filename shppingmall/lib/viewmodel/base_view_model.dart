import 'package:flutter/cupertino.dart';

///处理页面状态使用
enum ViewState {
  //加载中
  LOADING,

  //数据为空
  EMPTY,

  //加载数据失败
  ERROR,

  //加载完数据
  DONE
}

///基础viewModel
abstract class BaseViewModel extends ChangeNotifier {
  //是否被销毁了
  bool _disposed = false;
  //数据加载状态
  ViewState _viewState = ViewState.LOADING;

  ///是否加载中
  bool isLoading() => _viewState == ViewState.LOADING;

  ///是否数据为空
  bool isEmpty() => _viewState == ViewState.EMPTY;

  ///是否加载出错
  bool isError() => _viewState == ViewState.ERROR;

  ///是否加载完数据
  bool isComplete() => _viewState == ViewState.DONE;

  ///设置界面状态
  void _setViewState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  ///设置数据为空状态
  void setEmpty() {
    _setViewState(ViewState.EMPTY);
  }

  ///设置加载出错
  void setError() {
    _setViewState(ViewState.ERROR);
  }

  ///设置完成状态
  void setDone() {
    _setViewState(ViewState.DONE);
  }

  ///初始化state
  void initState() {
    _disposed = false;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
