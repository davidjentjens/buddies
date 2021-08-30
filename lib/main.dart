import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'screens/screens.dart';
import 'shared/shared.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      routes: {
        '/': (context) => AboutScreen(), //LoginScreen(),
        //'/topics': (context) => TopicsScreen(),
        //'/profile': (context) => ProfileScreen(),
        //'/about': (context) => AboutScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Nunito',
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.black87),
        brightness: Brightness.dark,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 18),
          bodyText1: TextStyle(fontSize: 16),
          button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
          headline5: TextStyle(fontWeight: FontWeight.bold),
          subtitle1: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
