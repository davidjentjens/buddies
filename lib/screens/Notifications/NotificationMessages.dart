import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../services/Database/Document.dart';
import '../../models/AppNotification.dart';
import '../../screens/EventDetails/EventDetails.dart';

class NotificationMessages extends StatefulWidget {
  const NotificationMessages({
    Key? key,
    required this.notifications,
    required this.user,
  }) : super(key: key);

  final List<AppNotification> notifications;
  final User user;

  @override
  _NotificationMessagesState createState() => _NotificationMessagesState();
}

class _NotificationMessagesState extends State<NotificationMessages> {
  _getIcon(type) {
    switch (type) {
      case 'EVENT_SOON':
        return Icons.timer;
      case 'EVENT_STARTED':
        return Icons.flag;
      case 'EVENT_END':
        return Icons.thumb_up;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.notifications
          .map(
            (notification) => Column(
              children: [
                Dismissible(
                  key: Key(notification.id),
                  child: ListTile(
                    leading: Icon(
                      _getIcon(notification.type),
                      size: 36,
                    ),
                    title: Text(notification.title),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${notification.body}",
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(height: 10),
                        Text(
                          "${DateFormat.MMMMd('pt_BR').add_jm().format(notification.emissionDate.toDate())}",
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    enableFeedback: true,
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EventDetailScreen(eventId: notification.route),
                        ),
                      );
                      setState(() => {
                            this.widget.notifications.removeWhere(
                                (element) => element.id == notification.id)
                          });
                      var notificationRef = Document(
                              path:
                                  "userinfo/${widget.user.uid}/notifications/${notification.id}")
                          .ref;
                      await notificationRef.delete();
                    },
                  ),
                  onDismissed: (direction) async {
                    setState(() => {
                          this.widget.notifications.removeWhere(
                              (element) => element.id == notification.id)
                        });
                    var notificationRef = Document(
                            path:
                                "userinfo/${widget.user.uid}/notifications/${notification.id}")
                        .ref;
                    await notificationRef.delete();
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
