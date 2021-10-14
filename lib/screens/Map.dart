import 'package:buddies/widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../services/LocationService.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? initialPosition;

  @override
  void initState() {
    super.initState();
    setInitialPosition();
  }

  void setInitialPosition() async {
    var position = await LocationService.determinePosition();

    setState(() {
      initialPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialPosition != null
          ? GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    initialPosition!.latitude, initialPosition!.longitude),
                zoom: 15,
              ),
            )
          : LoadingScreen(),
    );
  }
}
