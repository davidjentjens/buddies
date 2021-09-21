class UserData {
  String uid;
  String name;
  String photoUrl;

  UserData({
    required this.uid,
    required this.name,
    required this.photoUrl,
  });

  factory UserData.fromMap(Map data) {
    return UserData(
      uid: data['uid'],
      name: data['name'],
      photoUrl: data['photoUrl'],
    );
  }
}
