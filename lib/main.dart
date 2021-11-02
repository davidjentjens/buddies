import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/EventManager/EventManager.dart';
import 'screens/Agenda.dart';
import 'screens/EventBrowser/EventBrowser.dart';
import 'screens/Login.dart';
import 'screens/Map/Map.dart';
import 'screens/Profile.dart';
import 'services/Auth.dart';
import 'services/Database/Document.dart';
import 'shared/NavController.dart';

import 'AppTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.unsubscribeFromTopic('hBArkKcfJu44vznJJwW3');

    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      User? user = AuthService().getUser;
      print(token);

      if (token != null && user != null) {
        Document(path: 'fcm_tokens/${user.uid}').upsert({token: token});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => NavController(),
          '/events': (context) => EventBrowserScreen(),
          '/map': (context) => MapScreen(),
          '/profile': (context) => ProfileScreen(),
          '/agenda': (context) => AgendaScreen(),
          '/manage': (context) => EventManager(),
        },
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: themeData,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      ),
    );
  }
}
