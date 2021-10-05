import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/Event.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Event>> getEventsForCategory(categoryId) {
    return _db
        .collection('events')
        .where("category", isEqualTo: categoryId)
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
}
