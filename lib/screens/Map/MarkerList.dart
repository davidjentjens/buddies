import 'package:flutter/material.dart';

import '../../services/Database/DatabaseService.dart';
import '../../services/LocationService.dart';
import '../../widgets/Loader.dart';

class MarkerList extends StatelessWidget {
  const MarkerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService.getUserPosition(),
      builder: (BuildContext context, AsyncSnapshot futureSnapshot) {
        if (futureSnapshot.hasData) {
          return StreamBuilder(
            stream: DatabaseService()
                .streamUserFeaturedEvents(userCoordinates: futureSnapshot.data),
            builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
              if (streamSnapshot.hasData) {
                return Container();
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
