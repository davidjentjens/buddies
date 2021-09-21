import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  _eventList(List<Event> events) {
    return events.map((e) => EventCard(event: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Event>>(
        stream: Collection<Event>(path: '/events').streamData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [EventCard(event: snapshot.data[1])],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
