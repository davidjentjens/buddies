import 'package:flutter/material.dart';

import '../models/models.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Hero(
            tag: event.photoUrl,
            child: Row(children: [
              Expanded(
                child: Image(
                  image: NetworkImage(event.photoUrl),
                  fit: BoxFit.fitWidth,
                  height: 250,
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(children: []),
          )
        ],
      ),
    );
  }
}
