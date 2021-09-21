import 'package:buddies/screens/map.dart';
import 'package:buddies/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'screens/screens.dart';
import 'shared/shared.dart';
import 'services/services.dart';
import 'models/models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
        StreamProvider<Report?>.value(
          initialData: Report(topics: [], total: 0, uid: ''),
          value: Global.reportRef.documentStream,
        ),
        StreamProvider<List<Event>>.value(
          initialData: [],
          value: Collection<Event>(path: '/events').streamData(),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => NavController(),
          '/events': (context) => EventScreen(),
          '/map': (context) => MapScreen(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen(),
        },
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.black87),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFFFF8E5),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 18),
            bodyText1: TextStyle(fontSize: 16),
            button: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
            headline5: TextStyle(fontWeight: FontWeight.bold),
            subtitle1: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
