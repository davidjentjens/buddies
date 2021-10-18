import 'package:flutter/material.dart';

import '../models/Category.dart';
import '../models/Event.dart';
import '../services/Database/DatabaseService.dart';
import '../widgets/EventCard.dart';
import '../widgets/Loader.dart';

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
              return LoadingScreen();
            }
          }),
    );
  }
}
