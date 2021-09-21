import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import './models.dart';

class Event {
  String id;
  String title;
  String description;
  Timestamp startTime;
  Timestamp endTime;
  GeoPoint location;
  UserData creator;
  List<UserData> participants;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.creator,
      required this.participants});

  factory Event.fromMap(Map data) {
    return Event(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      location: data['location'],
      creator: UserData.fromMap(data['creator']),
      participants: (data['participants'] ?? [])
          .map<UserData>((data) => UserData.fromMap(data))
          .toList(),
    );
  }
}
