import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../services/Database/DatabaseService.dart';
import '../../widgets/EventCard.dart';
import '../../models/Event.dart';
import '../../widgets/Loader.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key}) : super(key: key);

  _eventsList(BuildContext context, List<Event>? events) {
    if (events == null || events.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
              "Você criou nenhum evento\n Crie um utilizando o botão acima",
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

    return StreamBuilder<List<Event>>(
        stream: DatabaseService().getUserCreatedEvents(user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: _eventsList(context, snapshot.data),
            );
          }
          return LoadingScreen();
        });
  }
}
