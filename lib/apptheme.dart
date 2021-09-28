import 'package:flutter/material.dart';

var themeData = ThemeData(
  fontFamily: 'Roboto',
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.black87),
  primarySwatch: Colors.blue,
  primaryColor: Color(0xFF7EB1AE),
  secondaryHeaderColor: Color(0xFFFFD4BD),
  scaffoldBackgroundColor: Color(0xFFFAF9F9),
  textTheme: TextTheme(
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 17),
    headline1: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    headline5: TextStyle(fontWeight: FontWeight.bold),
    headline6: TextStyle(color: Color(0xFFFAF9F9)),
    subtitle1: TextStyle(color: Colors.grey),
    button: TextStyle(
      color: Colors.white,
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
    ),
  ).apply(bodyColor: Color(0xFF444444), displayColor: Color(0xFF444444)),
);
