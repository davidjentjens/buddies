import 'dart:math';

import '../../widgets/EventModal.dart';
import 'package:buddies/widgets/EventModal.dart';
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
  LatLng userPosition = LatLng(0, 0);
  LatLng currentPosition = LatLng(0, 0);
  Circle fetchRadiusCircle = Circle(circleId: CircleId("userPosition"));

  @override
  void initState() {
    super.initState();
    setUserPosition();
  }

  void setUserPosition() async {
    var position = await LocationService.getUserPosition();
    setState(() {
      userPosition = LatLng(position.latitude, position.longitude);
      currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void updateCameraZoom(CameraPosition cameraPosition) {
    // TODO: Debugar o calculo de distancia na navegacao para refazer o fetch do firebase
    // print(calculateDistance(
    //     cameraPosition.target.latitude,
    //     cameraPosition.target.longitude,
    //     this.currentPosition.latitude,
    //     this.currentPosition.longitude));
    if ((cameraPosition.zoom - this.zoom).abs() > 1 ||
        (calculateDistance(
                cameraPosition.target.latitude,
                cameraPosition.target.longitude,
                this.currentPosition.latitude,
                this.currentPosition.longitude) >
            2)) {
      if (cameraPosition.zoom > 16) {
        updateFetchRadius(cameraPosition.zoom, cameraPosition.target);
      }
      setState(() {
        this.currentPosition = cameraPosition.target;
        this.zoom = cameraPosition.zoom;
      });
    }
  }

  void updateFetchRadius(double zoom, LatLng location) {
    setState(() {
      var radius = (40000 / pow(2, zoom)) * 2;
      this.fetchRadiusCircle = Circle(
        circleId: CircleId("userPosition"),
        center: location,
        radius: ((radius * 500)).abs(),
      );
      // print(zoom);
      // print(radius);
      // inspect(this.fetchRadiusCircle);
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Iterable<Marker> getEventMarkers(List<Event> events, BuildContext context) {
    Iterable<Marker> markers = events.map(
      (event) => new Marker(
        markerId: MarkerId(event.id),
        position: LatLng(
          event.locationData.latitude,
          event.locationData.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        onTap: () {
          EventModal.showEventModal(context, event);
        },
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
              stream: DatabaseService().streamUserFeaturedEvents(
                  userCoordinates: this.currentPosition,
                  radius: (40000 / pow(2, this.zoom)) * 2),
              builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
                // print("Stream updated");
                if (streamSnapshot.hasData) {
                  var markers = getEventMarkers(streamSnapshot.data, context);
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
                    minMaxZoomPreference: MinMaxZoomPreference(10, 18),
                    onCameraMove: updateCameraZoom,
                    buildingsEnabled: true,
                    circles: Set<Circle>.of([this.fetchRadiusCircle]),
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        northeast: LatLng(userPosition.latitude + 0.3,
                            userPosition.longitude + 0.3),
                        southwest: LatLng(userPosition.latitude - 0.3,
                            userPosition.longitude - 0.3),
                      ),
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
      ),
    );
  }
}
