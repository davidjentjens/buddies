import 'dart:developer';

import 'package:buddies/models/category.dart';
import 'package:buddies/models/event.dart';
import 'package:buddies/services/services.dart';
import 'package:buddies/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  _eventsList(BuildContext context, List<Event>? events) {
    if (events == null || events.isEmpty) {
      return [Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          "Não encontramos eventos cadastrados nesta categoria :(",
          textAlign: TextAlign.center
        ),
      )];
    }

    return events
        .map((event) => EventCard(event: event))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: FutureBuilder(
          future: DatabaseService().getEventsForCategory(category.id),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasData) {
              return ListView(children: _eventsList(context, snapshot.data));
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
