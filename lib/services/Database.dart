import 'package:buddies/models/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Globals.dart';

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

  Future<void> update(Map data) {
    return ref.update(Map<String, dynamic>.from(data));
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
        list.docs.map((doc) => Global.models[T](doc.data()) as T).toList());
  }
}
