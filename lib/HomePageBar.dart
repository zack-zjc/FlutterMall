import 'package:flutter/material.dart';

class HomePageBar extends StatefulWidget implements PreferredSizeWidget{

  @override
  State<StatefulWidget> createState() {
    return new HomePageBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(120);

}

class HomePageBarState extends State<HomePageBar>{

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 120,
        child: Image.asset('assets/images/home_unselect.png')
    );
  }

}