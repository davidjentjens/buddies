import 'package:flutter/material.dart';

class EventIcon extends StatelessWidget {
  final String eventType;

  const EventIcon({Key? key, required this.eventType}) : super(key: key);

  _getIcon(type) {
    switch (type) {
      case 'FOOTBALL':
        return Icons.sports_soccer_rounded;
      case 'TENNIS':
        return Icons.sports_tennis_rounded;
      case 'BASKETBALL':
        return Icons.sports_basketball_rounded;
      case 'BIKE':
        return Icons.pedal_bike_rounded;
      case 'RUN':
        return Icons.directions_run_rounded;
      case 'VOLLEY':
        return Icons.sports_volleyball;
      case 'MISC':
        return Icons.ac_unit;
      default:
        return Icons.miscellaneous_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(eventType),
      size: 72,
      color: Colors.orange[300],
    );
  }
}
