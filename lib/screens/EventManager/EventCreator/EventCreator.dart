import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/LocationService.dart';
import '../../../models/Category.dart';

import './EventFields.dart';
import './EventImage.dart';
import './SelectCategory.dart';
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

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Category? selectedCategory;

  DateTime selectedInitialDate = DateTime.now();
  DateTime selectedFinalDate = DateTime.now().add(Duration(days: 30));

  Position? userPosition;
  LocationResult? selectedLocation;

  @override
  void initState() {
    super.initState();
    setuserPosition();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void setuserPosition() async {
    var position = await LocationService.getUserPosition();

    setState(() {
      this.userPosition = position;
    });
  }

  Future<Null> selectDate(BuildContext context, DateType datetype) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: this.selectedInitialDate,
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
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text(
            'Erro: A data de ínicio deve ser antes da data de término.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[300],
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 10,
              right: 40,
              left: 40),
        ));
        return;
      }
      setState(() {
        this.selectedInitialDate = pickedDate!;
      });
    } else {
      if (pickedDate == selectedFinalDate ||
          pickedDate.isBefore(selectedInitialDate)) {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Text(
            'Erro: A data de término deve ser depois da data de ínicio.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[300],
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height / 8,
              right: 40,
              left: 40),
        ));
        return;
      }
      setState(() {
        this.selectedFinalDate = pickedDate!;
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
          displayLocation: userPosition != null
              ? LatLng(userPosition!.latitude, userPosition!.longitude)
              : new LocationResult().latLng,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        this.selectedLocation = result;
      });
    }
  }

  Future<Null> selectCategory(BuildContext context) async {
    final Category? chosenCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SelectCategory(),
      ),
    );
    if (chosenCategory != null) {
      setState(() {
        this.selectedCategory = chosenCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: CreateButton(
        formKey: this._formKey,
        titleController: this.titleController,
        descriptionController: this.descriptionController,
        selectedCategory: this.selectedCategory,
        selectedInitialDate: this.selectedInitialDate,
        selectedFinalDate: this.selectedFinalDate,
        selectedLocation: this.selectedLocation,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[EventImage(selectedCategory: this.selectedCategory)];
        },
        body: Form(
          key: _formKey,
          child: EventFields(
            this.titleController,
            this.descriptionController,
            this.selectedCategory,
            this.selectCategory,
            this.selectedInitialDate,
            this.selectedFinalDate,
            this.selectDate,
            this.selectedLocation,
            this.selectLocation,
          ),
        ),
      ),
    );
  }
}
