import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/Loader.dart';
import '../../services/Auth.dart';
import '../../services/Database/Collection.dart';
import '../../models/AppNotification.dart';
import './NotificationMessages.dart';

class NotificationsScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return StreamBuilder(
      stream: Collection<AppNotification>(
              path: '/userinfo/${user.uid}/notifications')
          .streamData(),
      builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
        if (streamSnapshot.hasData) {
          var notifications = streamSnapshot.data as List<AppNotification>;

          return Scaffold(
            appBar: AppBar(
              title: Text("Notifications"),
            ),
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: notifications.length > 0
                    ? NotificationMessages(
                        notifications: notifications, user: user)
                    : Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Você esta atualizado com as suas notificações :)',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                          //style: TextStyle(fontSize: 40, color: Colors.black),
                        ),
                      ),
              ),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
