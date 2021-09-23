import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/services.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Event>>(
        stream: Collection<Event>(path: '/events').streamData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                EventCard(event: snapshot.data[1]),
                CategoryGrid(),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    Key? key,
  }) : super(key: key);

  _categoryList(List<Category> categories) {
    return categories
        .map(
          (category) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: EventIcon(
              eventType: category.id,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Collection<Category>(path: '/categories').streamData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        inspect(snapshot);
        if (snapshot.hasData) {
          return Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: GridView.count(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: _categoryList(snapshot.data),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
