import 'package:buddies/services/Database/DatabaseService.dart';
import 'package:buddies/widgets/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/Loader.dart';
import '../services/Auth.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () async {
                await auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Row(
                children: [
                  Text(
                    "Sair",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.logout,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(context, user),
              Divider(),
              FutureBuilder(
                  future: _eventHistory(context, user),
                  builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!);
                    }
                    return Text(
                        "Parece que você ainda não participou de nenhum evento.");
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              child: CircleAvatar(
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : AssetImage("assets/avatar_placeholder.jpg")
                        as ImageProvider,
              ),
              height: 75,
              width: 75),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.displayName ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              SizedBox(height: 0),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> _eventHistory(BuildContext context, User user) async {
    var eventCards = (await DatabaseService().getEventHistoryForUser(user))
        .map((event) => EventCard(event: event));

    return [
      Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          children: [
            Icon(Icons.pin_drop, color: Theme.of(context).primaryColor),
            SizedBox(width: 5),
            Text(
              "Histórico de eventos",
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
      ...eventCards
    ];
  }
}
