import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  const EventImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      flexibleSpace: SizedBox(
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).secondaryHeaderColor,
                BlendMode.colorBurn,
              ),
              child: Image(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1607962837359-5e7e89f86776?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80"),
                fit: BoxFit.cover,
              ),
            ),
            Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 60,
            ),
          ],
        ),
      ),
      expandedHeight: 150,
      backgroundColor: Color(0x00000000),
      elevation: 0,
    );
  }
}
