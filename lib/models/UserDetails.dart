class UserDetails {
  String uid;
  String name;
  String photoUrl;

  UserDetails({
    required this.uid,
    required this.name,
    required this.photoUrl,
  });

  factory UserDetails.fromMap(Map data) {
    return UserDetails(
      uid: data['uid'],
      name: data['name'],
      photoUrl: data['photoUrl'],
    );
  }
}
