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
      body: StreamBuilder<List<Event>>(
        stream: Collection<Event>(path: '/events').streamData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
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
