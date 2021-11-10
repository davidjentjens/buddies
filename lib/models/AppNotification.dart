import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  String id;
  Timestamp emissionDate;
  String body;
  String route;
  String title;
  String type;

  AppNotification({
    required this.id,
    required this.emissionDate,
    required this.body,
    required this.route,
    required this.title,
    required this.type,
  });

  factory AppNotification.fromMap(Map data) {
    return AppNotification(
        id: data['id'],
        emissionDate: data['emissionDate'],
        body: data['body'],
        route: data['route'],
        title: data['title'],
        type: data['type']);
  }
}
