import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/Database/Document.dart';

class Messaging {
  final FirebaseMessaging _ms = FirebaseMessaging.instance;

  Future<void> createTopic(String eventId) async {
    var db = FirebaseFirestore.instance;

    var topicDocRef = db.collection('topics').doc(eventId);
    await topicDocRef.set({
      "tokens": [await _ms.getToken()],
    });
  }

  Future<void> subscribeToTopic(String eventId) async {
    _ms.subscribeToTopic(eventId);

    var topicDocRef = Document(path: 'topics/$eventId');
    await topicDocRef.ref.update({
      "tokens": FieldValue.arrayUnion([await _ms.getToken()])
    });
  }

  Future<void> unsubscribeFromTopic(String eventId) async {
    _ms.unsubscribeFromTopic(eventId);

    var topicDocRef = Document(path: 'topics/$eventId');
    await topicDocRef.ref.update({
      "tokens": FieldValue.arrayRemove([await _ms.getToken()])
    });
  }
}
