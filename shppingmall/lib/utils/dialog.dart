import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///展示对话框的样式
class DialogUtil {
  ///展示普通信息对话框
  static void showAlertDialog(BuildContext context,
      {String title = "",
      String content = "",
      bool showCancel = false,
      String cancelText = "取消",
      String confirmText = "确认",
      VoidCallback cancelAction,
      VoidCallback confirmAction}) {
    if (Platform.isIOS) {
      List<Widget> actions = [];
      if (showCancel) {
        actions.add(CupertinoButton(
          child: Text(
            cancelText,
          ),
          onPressed: () {
            cancelAction?.call();
            Navigator.of(context).pop();
          },
        ));
      }
      actions.add(CupertinoButton(
        child: Text(
          confirmText,
        ),
        onPressed: () {
          confirmAction?.call();
          Navigator.of(context).pop();
        },
      ));
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(title: title.isEmpty ? null : Text(title), content: Text(content), actions: actions);
          });
    } else {
      List<Widget> actions = [];
      if (showCancel) {
        actions.add(FlatButton(
          child: Text(
            cancelText,
          ),
          onPressed: () {
            cancelAction?.call();
            Navigator.of(context).pop();
          },
        ));
      }
      actions.add(FlatButton(
        child: Text(
          confirmText,
        ),
        onPressed: () {
          confirmAction?.call();
          Navigator.of(context).pop();
        },
      ));
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(title: title.isEmpty ? null : Text(title), content: Text(content), actions: actions);
          });
    }
  }

  ///展示时间选择控件
  static void showDatePick(BuildContext context, {DateTime initialDate, DateTime firstDate, DateTime lastDate, Function(DateTime dateTime) timeCallback}) {
    var initial = initialDate ?? DateTime.now();
    var first = firstDate ?? DateTime.now().subtract(Duration(days: 10));
    var last = lastDate ?? DateTime.now().add(Duration(days: 10));
    if (Platform.isIOS) {
      DateTime selectTime = DateTime(initial.year, initial.month, initial.day);
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (selectTime != null) {
                        timeCallback?.call(selectTime);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      color: Colors.white,
                      padding: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "确定",
                      ),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date, //日期时间模式，此处为日期模式
                      onDateTimeChanged: (dateTime) {
                        //日期改变时调用的方法
                        selectTime = dateTime;
                      },
                      initialDateTime: initial, //初始化展示时的日期时间
                      minimumYear: first.year, //最小年份，只有mode为date时有效
                      maximumYear: last.year, //最大年份，只有mode为date时有效
                    ),
                  )
                ],
              ),
            );
          });
    } else {
      showDatePicker(context: context, initialDate: initial, firstDate: first, lastDate: last, locale: Locale.fromSubtags(languageCode: 'zh')).then((dateTime) {
        if (dateTime != null) {
          timeCallback?.call(dateTime);
        }
      });
    }
  }

  ///展示选择弹框
  static void showPickDialog(BuildContext context, List<String> stringList, Function(int selectIndex) indexCallback) {
    if (Platform.isIOS) {
      List<Widget> widgetList = [];
      stringList.forEach((element) {
        widgetList.add(Container(
          alignment: Alignment.center,
          child: Text(element),
        ));
      });
      int selectIndex = 0;
      showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: 240,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      indexCallback(selectIndex);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40.0,
                      padding: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "确定",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white, //选择器背景色
                      itemExtent: 60.0, //item的高度
                      onSelectedItemChanged: (index) {
                        //选中item的位置索引
                        selectIndex = index;
                      },
                      children: widgetList,
                    ),
                  )
                ],
              ),
            );
          });
    } else {
      List<Widget> widgetList = [];
      for (var index = 0; index < stringList.length; index++) {
        widgetList.add(GestureDetector(
          onTap: () {
            indexCallback(index);
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.0,
            color: Colors.white,
            child: Text(stringList[index]),
          ),
        ));
        if (index < stringList.length - 1 && stringList.length > 1) {
          widgetList.add(Container(
            height: 0.5,
            color: Colors.grey,
          ));
        }
      }
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              children: widgetList,
              contentPadding: EdgeInsets.all(0.0),
            );
          });
    }
  }
}
