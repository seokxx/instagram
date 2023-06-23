import 'package:flutter/material.dart';

var theme = ThemeData(

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    elevation: 4,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    elevation: 4,
    actionsIconTheme: IconThemeData(color:Colors.white),
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.red),
  ),
);