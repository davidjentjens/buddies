import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import './models.dart';
import './globals.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Quiz> getQuiz(quizId) {
    return _db
        .collection('quizzes')
        .doc(quizId)
        .get()
        .then((snap) => Quiz.fromMap(snap.data()));
  }
}

class Document<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;

  late DocumentReference ref;

  Document({required this.path}) {
    ref = _db.doc(path);
  }

  Future<T> getData() async {
    var response = await ref.get();

    return Global.models[T](response.data() as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Global.models[T](v.data()) as T);
  }

  Future<void> upsert(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
}

class Collection<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;

  late CollectionReference ref;

  Collection({required this.path}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshot = await ref.get();

    return snapshot.docs
        .map((doc) => Global.models[T](doc.data()) as T)
        .toList();
  }

  Stream<List<T>> streamData() {
    var snapshot = ref.snapshots();

    return snapshot.map((list) =>
        list.docs.map((doc) => Global.models[T](doc.data) as T).toList());
  }
}

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
