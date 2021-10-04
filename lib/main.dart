import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'screens/screens.dart';
import 'shared/shared.dart';
import 'services/services.dart';

import 'AppTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
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
        theme: themeData,
      ),
    );
  }
}
