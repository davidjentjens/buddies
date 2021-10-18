import 'package:buddies/services/LocationService.dart';
import 'package:flutter/material.dart';

import '../../widgets/Loader.dart';
import '../../services/Database/DatabaseService.dart';
import '../../models/Event.dart';
import '../../widgets/EventCard.dart';

import 'CategoryGrid.dart';

class EventCatalog extends StatelessWidget {
  const EventCatalog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService.getUserPosition(),
      builder: (BuildContext context, AsyncSnapshot futureSnapshot) {
        if (futureSnapshot.hasData) {
          return StreamBuilder<List<Event>>(
            stream:
                DatabaseService().streamUserFeaturedEvents(futureSnapshot.data),
            builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Container(
                  height: double.infinity,
                  child: ListView(
                    children: [
                      streamSnapshot.data.length != 0
                          ? EventCard(event: streamSnapshot.data[0])
                          : SizedBox(
                              height: 25,
                            ),
                      CategoryGrid(),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                );
              } else {
                return LoadingScreen();
              }
            },
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
