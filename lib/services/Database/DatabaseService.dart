import 'package:buddies/services/Database/Document.dart';
import 'package:buddies/services/Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/Event.dart';
import '../../models/Category.dart';

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

  Stream<List<Category>> streamMostPopularCategories(
      {required int categoryNum}) {
    return _db
        .collection('categories')
        .orderBy('eventNum', descending: true)
        .limit(categoryNum)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((docSnap) => Category.fromMap(docSnap.data()))
            .toList());
  }

  Stream<List<Event>> streamUserFeaturedEvents(
      {required LatLng userCoordinates, double radius = 30}) {
    final geo = Geoflutterfire();
    GeoFirePoint center = geo.point(
      latitude: userCoordinates.latitude,
      longitude: userCoordinates.longitude,
    );

    /*var queryRef = _db
        .collection('events')
        .where("startTime", isGreaterThan: DateTime.now())
        .orderBy("startTime");*/

    return geo
        .collection(collectionRef: _db.collection('events'))
        .within(
            center: center, radius: radius, field: 'point', strictMode: true)
        .map((event) => event
            .map((e) => Event.fromMap(e.data()!))
            .where((event) =>
                DateTime.now().millisecondsSinceEpoch <
                event.startTime.millisecondsSinceEpoch)
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

  Stream<List<Event>> getUserCreatedEvents(User user) async* {
    // Gets the events stream
    var eventsStream = _db
        .collection('events')
        .where("creator.uid", isEqualTo: user.uid)
        .snapshots()
        .map((querySnap) => querySnap.docs
            .map((docSnap) => Event.fromMap(docSnap.data()))
            .toList());

    // Awaits a response for each stream
    await for (List<Event> eventList in eventsStream) {
      // For each event of the response list
      for (Event event in eventList) {
        // Gets its event category
        var categorySnapshot =
            await _db.doc("categories/${event.category}").get();
        var categoryMap = categorySnapshot.data();
        if (categoryMap != null) {
          event.categoryObject = Category.fromMap(categoryMap);
        }
      }
      // Returns the updated events list
      yield eventList;
    }
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
        "formattedAddress": event.locationData.formattedAddress,
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
