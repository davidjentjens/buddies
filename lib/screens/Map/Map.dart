import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/Event.dart';
import '../../widgets/AvatarButton.dart';
import '../../services/Database/DatabaseService.dart';
import '../../services/LocationService.dart';
import '../../widgets/Loader.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double zoom = 15;

  void updateCameraZoom(CameraPosition cameraPosition) {
    if ((cameraPosition.zoom - this.zoom).abs() > 3) {
      setState(() {
        this.zoom = cameraPosition.zoom;
      });
    }
  }

  Iterable<Marker> getEventMarkers(List<Event> events) {
    Iterable<Marker> markers = events.map(
      (event) => new Marker(
        markerId: MarkerId(event.id),
        position: LatLng(
          event.locationData.latitude,
          event.locationData.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(
          title: event.title,
          snippet: event.description,
          onTap: () {},
        ),
      ),
    );

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Eventos próximos de você",
            style: Theme.of(context).textTheme.headline6),
        actions: [AvatarButton()],
      ),
      body: FutureBuilder(
        future: LocationService.getUserPosition(),
        builder: (BuildContext context, AsyncSnapshot futureSnapshot) {
          if (futureSnapshot.hasData) {
            return StreamBuilder(
              stream: DatabaseService()
                  .streamUserFeaturedEvents(futureSnapshot.data),
              builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
                if (streamSnapshot.hasData) {
                  var markers = getEventMarkers(streamSnapshot.data);
                  return GoogleMap(
                    markers: Set<Marker>.of(markers),
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        futureSnapshot.data!.latitude,
                        futureSnapshot.data!.longitude,
                      ),
                      zoom: this.zoom,
                    ),
                    onCameraMove: updateCameraZoom,
                    buildingsEnabled: true,
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
      ),
    );
  }
}
