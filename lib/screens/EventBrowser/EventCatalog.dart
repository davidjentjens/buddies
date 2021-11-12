import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/Database/DatabaseService.dart';
import '../../services/LocationService.dart';
import '../../models/Event.dart';
import '../../widgets/Loader.dart';
import '../../screens/EventBrowser/CategoryPage.dart';

import 'EventCarousel.dart';
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
                        //EventCard(event: streamSnapshot.data[0])
                        streamSnapshot.data.length != 0
                            ? EventCarousel(events: streamSnapshot.data)
                            : SizedBox(height: 25),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, right: 18, left: 18, bottom: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bookmarks,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Categorias populares",
                                style: Theme.of(context).textTheme.headline6,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 385,
                          child: CategoryGrid(popularCategoriesOnly: true),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CategoryPage(),
                              ),
                            ),
                          },
                          child: Text('Ver todas as categorias'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
