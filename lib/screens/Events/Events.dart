import 'package:buddies/widgets/AvatarButton.dart';
import 'package:flutter/material.dart';

import '../../services/Database/Collection.dart';
import '../../models/Event.dart';
import '../../widgets/EventCard.dart';
import 'CategoryGrid.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Pesquisar eventos",
            style: Theme.of(context).textTheme.headline6),
        actions: [AvatarButton()],
      ),
      body: StreamBuilder<List<Event>>(
        stream: Collection<Event>(path: '/events').streamData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                EventCard(event: snapshot.data[1]),
                CategoryGrid(),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
