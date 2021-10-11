import 'package:flutter/material.dart';

class EventFields extends StatelessWidget {
  const EventFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        new ListTile(
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Título para o Evento",
            ),
          ),
        ),
        new ListTile(
          title: new TextField(
            decoration: new InputDecoration(
              hintText: "Descrição para o Evento",
            ),
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        new ListTile(
          leading: const Icon(Icons.label),
          title: const Text('Nick'),
          subtitle: const Text('None'),
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
