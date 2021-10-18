import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/Event.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Event>> getEventsForCategory(categoryId) {
    return _db
        .collection('events')
        .where("category", isEqualTo: categoryId)
        .where("startTime", isGreaterThan: DateTime.now())
        .get()
        .then((querySnap) => querySnap.docs
            .map((docSnap) => Event.fromMap(docSnap.data()))
            .toList());
  }

  Future<List<Event>> searchByTerm(String term) {
    return _db.collection('events').get().then((querySnap) => querySnap.docs
        .map((docSnap) => Event.fromMap(docSnap.data()))
        .where((element) =>
            element.title.toUpperCase().contains(term.toUpperCase()))
        .toList());
  }

  Stream<List<Event>> getUserFutureEvents(User user) {
    return _db
        .collection('events')
        .where("participants", arrayContains: {
          "uid": user.uid,
          "name": user.displayName,
          "photoUrl": user.photoURL
        })
        .where("startTime", isGreaterThan: DateTime.now())
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((docSnap) => Event.fromMap(docSnap.data()))
            .toList());
  }

  Stream<List<Event>> getUserCreatedEvents(User user) {
    return _db
        .collection('events')
        .where("creator.uid", isEqualTo: user.uid)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((docSnap) => Event.fromMap(docSnap.data()))
            .toList());
  }

  Future<Null> createEvent(Event event) async {
    var newDocRef = _db.collection('events').doc();
    newDocRef.set({
      "id": newDocRef.id,
      "title": event.title,
      "description": event.description,
      "photoUrl": event.photoUrl,
      "startTime": event.startTime,
      "endTime": event.endTime,
      "locationData": {
        "formattedAdress": event.locationData.formattedAddress,
        "postalCode": event.locationData.postalCode,
        "latitude": event.locationData.latitude,
        "longitude": event.locationData.longitude,
      },
      "point": event.point,
      "creator": {
        "uid": event.creator.uid,
        "name": event.creator.name,
        "photoUrl": event.creator.photoUrl
      },
      "participants": [
        {
          "uid": event.creator.uid,
          "name": event.creator.name,
          "photoUrl": event.creator.photoUrl
        }
      ],
      "category": event.category
    });
  }

  Future<Null> editEvent(Event event) async {
    var docRef = _db.doc('events/${event.id}');
    docRef.set({
      "title": event.title,
      "description": event.description,
      "photoUrl": event.photoUrl,
      "startTime": event.startTime,
      "endTime": event.endTime,
      "locationData": {
        "formattedAdress": event.locationData.formattedAddress,
        "postalCode": event.locationData.postalCode,
        "latitude": event.locationData.latitude,
        "longitude": event.locationData.longitude,
      },
      "point": event.point,
      "creator": {
        "uid": event.creator.uid,
        "name": event.creator.name,
        "photoUrl": event.creator.photoUrl
      },
      "participants": [
        {
          "uid": event.creator.uid,
          "name": event.creator.name,
          "photoUrl": event.creator.photoUrl
        }
      ],
      "category": event.category
    }, SetOptions(merge: true));
  }
}
