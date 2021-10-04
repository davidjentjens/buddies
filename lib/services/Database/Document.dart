import 'package:cloud_firestore/cloud_firestore.dart';

import '../Globals.dart';

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