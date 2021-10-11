import 'package:flutter/material.dart';

import '../../widgets/AvatarButton.dart';

import './CreateEventButton.dart';
import './EventList.dart';

class EventManager extends StatelessWidget {
  const EventManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Gerenciador de Eventos",
            style: Theme.of(context).textTheme.headline6),
        actions: [AvatarButton()],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[CreateEventButton()];
        },
        body: EventList(),
      ),
    );
  }
}
