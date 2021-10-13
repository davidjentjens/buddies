import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/LocationService.dart';

import './EventFields.dart';
import './EventImage.dart';
import './CreateButton.dart';

class EventCreator extends StatefulWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  _EventCreatorState createState() => _EventCreatorState();
}

class _EventCreatorState extends State<EventCreator> {
  final _formKey = GlobalKey<FormState>();

  Widget? eventFields;
  DateTime selectedDate = DateTime.now();
  Position? initialPosition;
  LocationResult selectedLocation = new LocationResult();

  @override
  void initState() {
    super.initState();
    setInitialPosition();
  }

  void setInitialPosition() async {
    var position = await LocationService.determinePosition();

    print(position);

    setState(() {
      initialPosition = position;
    });
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != selectedDate && pickedTime != null) {
      setState(() {
        selectedDate = new DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
      });
    }
  }

  Future<Null> selectLocation(BuildContext context) async {
    var apiKey = Platform.isAndroid
        ? dotenv.env['GOOGLE_MAPS_ANDROID_API_KEY']
        : dotenv.env['GOOGLE_MAPS_IOS_API_KEY'];

    if (apiKey == null) {
      print("Google Maps API key missing");
    }

    LocationResult? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey ?? "",
          displayLocation: initialPosition != null
              ? LatLng(initialPosition!.latitude, initialPosition!.longitude)
              : selectedLocation.latLng,
        ),
      ),
    );

    print("LOCATION: ${result.toString()}");

    if (result != null) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Crie seu próprio Evento",
            style: Theme.of(context).textTheme.headline6),
      ),
      bottomSheet: CreateButton(
        formKey: _formKey,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[EventImage()];
        },
        body: Form(
          key: _formKey,
          child: EventFields(
            selectedDate,
            this.selectDate,
            this.selectedLocation,
            this.selectLocation,
          ),
        ),
      ),
    );
  }
}
