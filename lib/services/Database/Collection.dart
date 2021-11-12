import 'package:cloud_firestore/cloud_firestore.dart';

import '../Globals.dart';

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
