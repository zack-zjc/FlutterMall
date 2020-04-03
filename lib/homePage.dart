import 'package:flutter/material.dart';

import 'HomePageBar.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }

}

class MyHomePageState extends State<MyHomePage>{
  int _tabIndex = 0;
  var _tabImages;

  Image getTabImage(path) {
    return new Image.asset(path, width: 100.0, height: 30.0);
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return _tabImages[curIndex][1];
    }
    return _tabImages[curIndex][0];
  }

  /*
   * 初始化数据
   */
  void initData() {
    /*
     * 初始化选中和未选中的icon
     */
    _tabImages = [
      [getTabImage('assets/images/home_unselect.png'), getTabImage('assets/images/home_selected.png')],
      [getTabImage('assets/images/mine_unselect.png'), getTabImage('assets/images/mine_selected.png')]
    ];
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return new Scaffold(
      appBar: HomePageBar(),
      body: new Container(child: Image.asset('assets/images/home_unselect.png'),),
      bottomNavigationBar: new BottomNavigationBar(items: [new BottomNavigationBarItem(icon: getTabIcon(0),title: new Container()),
        new BottomNavigationBarItem(icon: getTabIcon(1),title: new Container())],
      onTap: (index){
        setState(() {
          _tabIndex = index;
        });
      },),
    );
  }

}