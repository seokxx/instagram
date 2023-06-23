import 'package:flutter/material.dart';

var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey,
    )
  ),
  iconTheme: IconThemeData(color: Colors.blue),
  appBarTheme: AppBarTheme(
    color: Colors.black,
    elevation: 4,
    actionsIconTheme: IconThemeData(color:Colors.white),
  ),
);