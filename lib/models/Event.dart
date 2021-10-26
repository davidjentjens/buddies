import 'package:buddies/models/Category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './LocationData.dart';

import 'UserDetails.dart';

class Event {
  String id;
  String title;
  String description;
  String photoUrl;
  Timestamp startTime;
  Timestamp endTime;
  LocationData locationData;
  dynamic point;
  UserDetails creator;
  List<UserDetails> participants;
  String category;
  Category? categoryObject;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.photoUrl,
      required this.startTime,
      required this.endTime,
      required this.locationData,
      required this.point,
      required this.creator,
      required this.participants,
      required this.category});

  factory Event.fromMap(Map data) {
    return Event(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        photoUrl: data['photoUrl'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        locationData: LocationData.fromMap(data['locationData']),
        point: data['point'],
        creator: UserDetails.fromMap(data['creator']),
        participants: (data['participants'] ?? [])
            .map<UserDetails>((data) => UserDetails.fromMap(data))
            .toList(),
        category: data['category'] ?? 'MISC');
  }
}
