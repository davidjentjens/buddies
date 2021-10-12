import 'package:flutter/material.dart';

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
          ),
        ),
      ),
    );
  }
}
