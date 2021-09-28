import 'package:flutter/material.dart';

import '../../models/models.dart';

class EventParticipants extends StatelessWidget {
  final Event event;

  const EventParticipants({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: event.participants
          .map((participant) => Text(participant.name))
          .toList(),
    );
  }
}
