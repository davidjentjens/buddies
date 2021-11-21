import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EventIcon.dart';
import 'ExpandableText.dart';
import '../models/Event.dart';

class EventHeader extends StatelessWidget {
  const EventHeader({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        bottom: 22,
        top: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(event.title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline1),
              ),
              SizedBox(
                width: 5,
              ),
              EventIcon(
                eventType: event.category,
                size: 50,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ExpandableText(event.description),
          SizedBox(
            height: 12,
          ),
          Text(
            "O evento ocorrerá dia ${DateFormat.MMMMd('pt_BR').add_jm().format(event.startTime.toDate())}",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
