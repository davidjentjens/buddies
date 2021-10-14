import 'package:flutter/material.dart';

import './EventCreator/EventCreator.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton.extended(
      label: Text(
        "Novo Evento",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      icon: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => EventCreator(),
          ),
        );
      },
    );
  }
}
