import 'dart:io' show Platform;
import 'package:buddies/widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import '../../../services/LocationService.dart';
import '../../../models/Event.dart';
import '../../../models/Category.dart';

import './EventFields.dart';
import './EventImage.dart';
import './SelectCategory.dart';
import './EditButton.dart';

enum DateType { start, end }

class EventEditor extends StatefulWidget {
  final Event event;

  const EventEditor({Key? key, required this.event}) : super(key: key);

  @override
  _EventEditorState createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  bool loading = true;

  final _formKey = GlobalKey<FormState>();

  Widget? eventFields;

  String? eventId;

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
    setState(() {
      this.eventId = this.widget.event.id;

      this.titleController.text = this.widget.event.title;
      this.descriptionController.text = this.widget.event.description;

      //this.selectedCategory = this.widget.event.category;

      this.selectedInitialDate = DateTime.fromMillisecondsSinceEpoch(
          this.widget.event.startTime.millisecondsSinceEpoch);
      this.selectedFinalDate = DateTime.fromMillisecondsSinceEpoch(
          this.widget.event.endTime.millisecondsSinceEpoch);

      this.selectedLocation = new LocationResult();
      this.selectedLocation!.latLng = LatLng(
        this.widget.event.locationData.latitude,
        this.widget.event.locationData.longitude,
      );
      this.selectedLocation!.formattedAddress =
          this.widget.event.locationData.formattedAddress;
      this.selectedLocation!.postalCode =
          this.widget.event.locationData.postalCode;
    });
    setuserPosition();
    setState(() {
      this.loading = false;
    });
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
          displayLocation: this.selectedLocation!.latLng,
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
      bottomSheet: EditButton(
        eventId: this.eventId,
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
        body: !this.loading
            ? Form(
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
              )
            : LoadingScreen(),
      ),
    );
  }
}
