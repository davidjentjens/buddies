import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/EventDetails/EventDetails.dart';
import '../models/Event.dart';

class ActiveEventCard extends StatelessWidget {
  final Event event;

  const ActiveEventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: event.photoUrl,
      child: SingleChildScrollView(
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Card(
              color: Color(0xFFfff4ed),
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                side: new BorderSide(
                    color: Theme.of(context).primaryColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EventDetailScreen(eventId: event.id),
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
                          Flexible(
                            child: Container(
                              padding: new EdgeInsets.only(right: 13.0),
                              child: Text(
                                this.event.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
