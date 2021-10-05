import 'package:flutter/material.dart';

import '../../widgets/Loader.dart';
import '../../services/Database/Collection.dart';
import '../../models/Event.dart';
import '../../widgets/EventCard.dart';
import 'CategoryGrid.dart';

class EventCatalog extends StatelessWidget {
  const EventCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
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
          return LoadingScreen();
        }
      },
    );
  }
}
