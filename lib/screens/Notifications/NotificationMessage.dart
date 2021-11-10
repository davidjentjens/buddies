import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../services/Database/Document.dart';
import '../../models/AppNotification.dart';

class NotificationMessage extends StatelessWidget {
  const NotificationMessage({
    Key? key,
    required this.notifications,
    required this.user,
  }) : super(key: key);

  final List<AppNotification> notifications;
  final User user;

  _getIcon(type) {
    switch (type) {
      case 'EVENT_SOON':
        return Icons.timer;
      case 'EVALUATE':
        return Icons.thumbs_up_down;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: notifications
          .map(
            (notification) => Column(
              children: [
                Dismissible(
                  key: Key(notification.title),
                  child: ListTile(
                    leading: Icon(
                      _getIcon(notification.type),
                      size: 36,
                    ),
                    title: Text(notification.title),
                    subtitle: Text(
                      "${notification.body}\n${DateFormat.MMMMd('pt_BR').add_jm().format(notification.emissionDate.toDate())}",
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    enableFeedback: true,
                    onTap: () async {
                      var notificationRef = Document(
                              path:
                                  "userinfo/${user.uid}/notifications/${notification.id}")
                          .ref;
                      await notificationRef.delete();

                      // TODO Implement redirect here
                    },
                  ),
                  onDismissed: (direction) async {
                    var notificationRef = Document(
                            path:
                                "userinfo/${user.uid}/notifications/${notification.id}")
                        .ref;
                    await notificationRef.delete();
                    notifications.removeWhere(
                        (element) => element.id == notification.id);
                    print(notifications.length);
                  },
                ),
                SizedBox(height: 20)
              ],
            ),
          )
          .toList(),
    );
  }
}
