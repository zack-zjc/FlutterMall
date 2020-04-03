import 'package:mall/utils/log.dart';
import 'package:mall/viewmodel/base_view_model.dart';

abstract class BaseListViewModel<T> extends BaseViewModel {
  //加载index
  int index = 0;
  //是否加载完成
  bool all;
  //数据list
  List<T> dataList = [];

  ///初始化数据
  Future<void> initData() => Future.delayed(Duration(milliseconds: 250), () {
        refresh(null);
      });

  ///初始化数据
  Future<void> refresh(void Function() refreshComplete) async {
    try {
      index = 0;
      List<T> result = await loadData(loadMore: false);
      refreshComplete?.call();
      dataList.clear();
      if (result != null && result.isNotEmpty) {
        dataList.addAll(result);
        setDone();
      } else {
        setEmpty();
      }
      index++;
    } catch (exception) {
      refreshComplete?.call();
      LogUtil.debug(exception.toString());
      setError();
    }
  }

  ///加载更多数据
  Future<void> loadMore(void Function(bool all) loadComplete) async {
    try {
      List<T> result = await loadData(loadMore: true);
      loadComplete?.call(result.isEmpty);
      if (result != null && result.isNotEmpty) {
        dataList.addAll(result);
      }
      setDone();
      index++;
    } catch (exception) {
      loadComplete?.call(false);
      LogUtil.debug(exception.toString());
    }
  }

  ///设置是否加载完成
  void setAll(bool all) {
    this.all = all;
  }

  ///加载数据方法
  Future<List<T>> loadData({bool loadMore: false});
}
