import 'package:flutter/material.dart';

import '../../services/Database.dart';
import '../../shared/Loader.dart';
import '../../models/Event.dart';

import 'HeroImage.dart';
import 'ParticipateButton.dart';
import 'EventHeader.dart';
import 'EventMap.dart';
import 'EventParticipants.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Document<Event>(path: '/events/${event.id}').streamData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            bottomSheet: ParticipateButton(
              event: snapshot.data,
            ),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  HeroImage(event: snapshot.data),
                ];
              },
              body: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    EventHeader(event: snapshot.data),
                    EventMap(event: snapshot.data),
                    EventParticipants(event: snapshot.data)
                  ],
                ),
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
