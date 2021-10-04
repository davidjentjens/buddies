import 'package:flutter/material.dart';

import '../../services/db.dart';
import '../../shared/loader.dart';
import '../../models/models.dart';

import './heroimage.dart';
import './participatebutton.dart';
import './eventheader.dart';
import './eventmap.dart';
import './eventparticipants.dart';

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
