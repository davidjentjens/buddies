import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  const EventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      floating: true,
      pinned: true,
      flexibleSpace: Hero(
        tag: 'EVENTIMAGE',
        child: Row(children: [
          Expanded(
            child: Image(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1505666287802-931dc83948e9?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=871&q=80"),
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
