import 'package:flutter/material.dart';

import '../../services/Database/Document.dart';
import '../../widgets/Loader.dart';
import '../../models/Event.dart';

import 'HeroImage.dart';
import 'ParticipateButton.dart';
import 'EventHeader.dart';
import 'EventMap.dart';
import 'EventParticipants.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Document<Event>(path: '/events/$eventId').streamData(),
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
