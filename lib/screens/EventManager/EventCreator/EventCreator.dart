import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../services/LocationService.dart';

import './EventFields.dart';
import './EventImage.dart';
import './CreateButton.dart';

enum DateType { start, end }

class EventCreator extends StatefulWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  _EventCreatorState createState() => _EventCreatorState();
}

class _EventCreatorState extends State<EventCreator> {
  final _formKey = GlobalKey<FormState>();

  Widget? eventFields;
  DateTime selectedInitialDate = DateTime.now();
  DateTime selectedFinalDate = DateTime.now();

  Position? initialPosition;
  LocationResult selectedLocation = new LocationResult();

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

  Future<Null> selectDate(BuildContext context, DateType datetype) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedInitialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    pickedDate = new DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute);

    if (datetype == DateType.start) {
      if (pickedDate == selectedInitialDate ||
          pickedDate.isAfter(selectedFinalDate)) {
        Fluttertoast.showToast(
            msg: "A data de ínicio deve ser antes da data de término",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red[300],
            textColor: Colors.white,
            fontSize: 20.0);
        return;
      }
      setState(() {
        selectedInitialDate = pickedDate!;
      });
    } else {
      if (pickedDate == selectedFinalDate ||
          pickedDate.isBefore(selectedInitialDate)) {
        Fluttertoast.showToast(
            msg: "A data de término deve ser depois da data de ínicio",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red[300],
            textColor: Colors.white,
            fontSize: 20.0);
        return;
      }
      setState(() {
        selectedFinalDate = pickedDate!;
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
        body: new GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Form(
            key: _formKey,
            child: EventFields(
              selectedInitialDate,
              selectedFinalDate,
              this.selectDate,
              this.selectedLocation,
              this.selectLocation,
            ),
          ),
        ),
      ),
    );
  }
}
