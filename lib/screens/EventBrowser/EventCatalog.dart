import 'package:buddies/services/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          return LayoutBuilder(builder: (context, constrains) {
            return StreamBuilder<List<Event>>(
              stream: DatabaseService().streamUserFeaturedEvents(
                  userCoordinates: LatLng(futureSnapshot.data.latitude,
                      futureSnapshot.data.longitude)),
              builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return Container(
                    child: ListView(
                      children: [
                        streamSnapshot.data.length != 0
                            ? EventCard(event: streamSnapshot.data[0])
                            : SizedBox(
                                height: 25,
                              ),
                        Container(
                            height: constrains.maxHeight,
                            child: CategoryGrid()),
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
          });
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
