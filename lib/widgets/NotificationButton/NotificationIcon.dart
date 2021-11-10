import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    Key? key,
    required this.counter,
  }) : super(key: key);

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Icon(
          this.counter == 0 ? Icons.notifications : Icons.notifications_active,
          size: 38,
        ),
        if (this.counter > 0)
          Positioned(
            right: 0,
            child: new Container(
              padding: EdgeInsets.all(1),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: BoxConstraints(
                minWidth: 22,
                minHeight: 22,
              ),
              child: new Text(
                '$counter',
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
