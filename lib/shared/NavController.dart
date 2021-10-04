import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/Events/Events.dart';
import '../screens/Map.dart';
import '../screens/Agenda.dart';

class NavController extends StatefulWidget {
  NavController({Key? key}) : super(key: key);

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    EventScreen(),
    MapScreen(),
    AgendaScreen()
  ];

  static const List<String> _screenTitles = [
    "Pesquisar Eventos",
    "Buddies perto de você",
    "Seus próximos eventos"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('KOE'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          _screenTitles.elementAt(_selectedIndex),
          style: Theme.of(context).textTheme.headline6,
        ),
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
            icon: Icon(FontAwesomeIcons.home, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mapMarkerAlt, size: 20),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendar, size: 20),
            label: 'Agenda',
          ),
        ].toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
