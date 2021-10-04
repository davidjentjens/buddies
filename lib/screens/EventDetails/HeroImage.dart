import 'package:flutter/material.dart';

import '../../models/models.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
    required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      floating: true,
      pinned: true,
      flexibleSpace: Hero(
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
      expandedHeight: 200,
      backgroundColor: Color(0x00000000),
      elevation: 0,
    );
  }
}
