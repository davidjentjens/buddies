import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import './db.dart';

class UserData<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({required this.collection});

  Stream<T> get documentStream {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        var docStream = doc.streamData();
        return docStream;
      } else {
        return Stream<T>.empty();
      }
    });
  }

  Future<T?> getDocument() async {
    User? user = _auth.currentUser;

    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}');
      return doc.getData() as T;
    } else {
      return null;
    }
  }

  Future<void> upsert(Map data) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Error();
    }

    Document<T> doc = Document(path: '$collection/${user.uid}');

    return doc.ref.set(data);
  }
}
