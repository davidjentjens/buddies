class UserDetails {
  String uid;
  String name;
  String photoUrl;
  String rating;

  UserDetails({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.rating,
  });

  factory UserDetails.fromMap(Map data) {
    return UserDetails(
      uid: data['uid'],
      name: data['name'],
      photoUrl: data['photoUrl'],
      rating: data['rating'],
    );
  }
}
