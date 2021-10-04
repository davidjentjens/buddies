import 'package:flutter/material.dart';

import '../../models/Event.dart';

class EventParticipants extends StatelessWidget {
  final Event event;

  const EventParticipants({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    event.participants.sort((lhs, rhs) => lhs.uid.compareTo(event.creator.uid));
    return Padding(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 22,
        bottom: 55,
      ),
      child: Column(
        children: event.participants
            .map(
              (participant) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(participant.photoUrl),
                        radius: 35,
                      ),
                      SizedBox(width: 16),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (participant.uid == event.creator.uid)
                              Text(
                                participant.uid == event.creator.uid
                                    ? "Criador"
                                    : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0),
                              ),
                            Text(
                              participant.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rate,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "4.6",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.0),
                                )
                              ],
                            )
                          ])
                    ]),
              ),
            )
            .toList(),
      ),
    );
  }
}
