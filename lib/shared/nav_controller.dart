import 'package:buddies/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/screens.dart';
import './shared.dart';

class NavController extends StatefulWidget {
  NavController({Key? key}) : super(key: key);

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    TopicsScreen(),
    MapScreen(),
    AboutScreen()
  ];

  static const List<String> _screenTitles = [
    "Topics",
    "Buddies perto de você",
    "Sobre"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text(_screenTitles.elementAt(_selectedIndex)),
              backgroundColor: Color(0xFF00A19D),
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : AssetImage("assets/avatar_placeholder.jpg")
                                as ImageProvider,
                      ),
                    ))
              ],
            ),
            body: _screens.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.graduationCap, size: 20),
                  label: 'Topics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.mapMarkerAlt, size: 20),
                  label: 'Mapa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.userCircle, size: 20),
                  label: 'Sobre',
                ),
              ].toList(),
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF00A19D),
              onTap: _onItemTapped,
            ),
          )
        : LoadingScreen();
  }
}
