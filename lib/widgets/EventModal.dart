import '../screens/EventDetails/EventDetails.dart';

import '../models/Event.dart';
import 'package:buddies/widgets/EventHeader.dart';
import 'package:flutter/material.dart';

class EventModal extends StatelessWidget {
  const EventModal({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Container(
            width: 40.0,
            height: 5.0,
            decoration: new BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
        ),
        EventHeader(event: event),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EventDetailScreen(eventId: event.id),
                  ),
                );
              },
              icon: Icon(Icons.visibility),
              label: Text("Visualizar"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static void showEventModal(BuildContext context, Event event) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: EventModal(event: event));
        });
  }
}
