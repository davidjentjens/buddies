import 'package:flutter/material.dart';

import '../../models/models.dart';

import './eventheader.dart';
import './eventmap.dart';
import './eventparticipants.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Color(0x00000000),
      //   elevation: 0,
      // ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              floating: true,
              pinned: true,
              flexibleSpace: Hero(
                tag: event.photoUrl,
                child: Row(children: [
                  Expanded(
                    child: Image(
                      image: NetworkImage(event.photoUrl),
                      fit: BoxFit.fitWidth,
                      height: 250,
                    ),
                  ),
                ]),
              ),
              expandedHeight: 200,
              backgroundColor: Color(0x00000000),
              elevation: 0,
            ),
          ];
        },
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              EventHeader(event: event),
              EventMap(event: event),
              EventParticipants(event: event)
            ],
          ),
        ),
      ),
    );
  }
}
