import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/EventDetails/EventDetails.dart';
import '../models/Event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: event.photoUrl,
      child: SingleChildScrollView(
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EventDetailScreen(event: event),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventImage(eventImage: event.photoUrl),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.event.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.person, size: 16),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${event.participants.length.toString()}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        DateFormat.MMMMd('pt_BR')
                            .add_jm()
                            .format(event.startTime.toDate()),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(event.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class EventImage extends StatelessWidget {
  final String eventImage;

  const EventImage({
    Key? key,
    required this.eventImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image(
            image: NetworkImage(eventImage),
            fit: BoxFit.fitWidth,
            height: 150,
          ),
        ),
      ),
    ]);
  }
}
