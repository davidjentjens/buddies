import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../services/Database/Document.dart';
import '../../models/AppNotification.dart';
import '../../screens/EventDetails/EventDetails.dart';

class NotificationMessage extends StatefulWidget {
  const NotificationMessage({
    Key? key,
    required this.notifications,
    required this.user,
  }) : super(key: key);

  final List<AppNotification> notifications;
  final User user;

  @override
  _NotificationMessageState createState() => _NotificationMessageState();
}

class _NotificationMessageState extends State<NotificationMessage> {
  _getIcon(type) {
    switch (type) {
      case 'EVENT_SOON':
        return Icons.timer;
      case 'EVALUATE':
        return Icons.assignment_turned_in;
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
                  key: Key(notification.title),
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
