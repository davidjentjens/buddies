import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/Database/DatabaseService.dart';
import '../widgets/AvatarButton.dart';
import '../widgets/EventCard.dart';
import '../models/Event.dart';
import '../widgets/Loader.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  _eventsList(BuildContext context, List<Event>? events) {
    if (events == null || events.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text("Você não está participando de nenhum evento...",
              textAlign: TextAlign.center),
        )
      ];
    }

    return events.map((event) => EventCard(event: event)).toList();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Seus próximos eventos",
            style: Theme.of(context).textTheme.headline6),
        actions: [AvatarButton()],
      ),
      body: StreamBuilder<List<Event>>(
          stream: DatabaseService().getUserFutureEvents(user),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _eventsList(context, snapshot.data),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
