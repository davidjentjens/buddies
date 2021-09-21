import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: _eventList(Provider.of<List<Event>>(context)),
        ),
      ),
    );
  }

  _eventList(List<Event> events) {
    return events
        .map((e) => Card(
              child: Text(e.title),
            ))
        .toList();
  }
}
