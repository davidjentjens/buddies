import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/Event.dart';

class EventMap extends StatelessWidget {
  const EventMap({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  _initialCameraPosition(Event event) {
    return CameraPosition(
      target: LatLng(
        event.point["geopoint"].latitude,
        event.point["geopoint"].longitude,
      ),
      zoom: 13.0,
    );
  }

  _mapMarker(Event event) {
    return Set<Marker>.of([
      Marker(
          markerId: MarkerId(event.id),
          position: LatLng(
            event.point["geopoint"].latitude,
            event.point["geopoint"].longitude,
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        markers: _mapMarker(event),
        initialCameraPosition: _initialCameraPosition(event),
      ),
    );
  }
}
