import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/AppNotification.dart';
import '../../services/Database/Collection.dart';
import './NotificationIcon.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return Container();
    }

    return StreamBuilder(
      stream: Collection<AppNotification>(
              path: '/userinfo/${user.uid}/notifications')
          .streamData(),
      builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
        if (streamSnapshot.hasData) {
          var notifications = streamSnapshot.data as List<AppNotification>;

          return Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                child: NotificationIcon(counter: notifications.length),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
