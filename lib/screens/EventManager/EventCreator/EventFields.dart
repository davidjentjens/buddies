import 'package:flutter/material.dart';

class EventFields extends StatefulWidget {


  EventFields(
  ) : super();

  @override
  _EventFieldsState createState() => _EventFieldsState();
}

class _EventFieldsState extends State<EventFields> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new ListTile(
          leading: const Icon(Icons.title),
          title: new TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor informe um título para o Evento";
              }
              if (value.length < 10) {
                return "O título precisa ter pelo menos 10 caracteres";
              }
              return null;
            },
            decoration: new InputDecoration(
              hintText: "Título para o Evento",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.description),
          title: new TextFormField(
            decoration: new InputDecoration(
              hintText: "Descrição para o Evento",
            ),
          ),
        ),
        new ListTile(
          leading: const Icon(Icons.today),
          title: const Text('Birthday'),
          subtitle: const Text('February 20, 1980'),
        ),
        new ListTile(
          leading: const Icon(Icons.group),
          title: const Text('Contact group'),
          subtitle: const Text('Not specified'),
        )
      ],
    );
  }
}
