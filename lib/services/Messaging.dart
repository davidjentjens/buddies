import 'package:buddies/services/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/Database/Document.dart';

class Messaging {
  final FirebaseMessaging _ms = FirebaseMessaging.instance;

  Future<void> createTopic(String eventId) async {
    var db = FirebaseFirestore.instance;

    var user = AuthService().getUser;
    if (user == null) {
      return;
    }

    _ms.subscribeToTopic(eventId);

    var topicDocRef = db.collection('topics').doc(eventId);
    await topicDocRef.set({
      "uids": [user.uid],
    });
  }

  Future<void> subscribeToTopic(String eventId) async {
    var user = AuthService().getUser;
    if (user == null) {
      return;
    }

    _ms.subscribeToTopic(eventId);

    var topicDocRef = Document(path: 'topics/$eventId');
    await topicDocRef.ref.update({
      "uids": FieldValue.arrayUnion([user.uid])
    });
  }

  Future<void> unsubscribeFromTopic(String eventId) async {
    var user = AuthService().getUser;
    if (user == null) {
      return;
    }

    _ms.unsubscribeFromTopic(eventId);

    var topicDocRef = Document(path: 'topics/$eventId');
    await topicDocRef.ref.update({
      "uids": FieldValue.arrayRemove([user.uid])
    });
  }
}
