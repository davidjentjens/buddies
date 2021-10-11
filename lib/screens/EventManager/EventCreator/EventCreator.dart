import 'package:flutter/material.dart';

import './EventFields.dart';
import './EventImage.dart';

class EventCreator extends StatelessWidget {
  const EventCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Crie seu próprio Evento",
            style: Theme.of(context).textTheme.headline6),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[EventImage()];
        },
        body: EventFields(),
      ),
    );
  }
}
