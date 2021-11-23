class UserInfo {
  String uid;
  List<dynamic> events;
  List<dynamic> interests;
  double participationPoints;
  double totalParticipation;

  UserInfo({
    required this.uid,
    required this.events,
    required this.interests,
    required this.participationPoints,
    required this.totalParticipation,
  });

  factory UserInfo.fromMap(Map data) {
    return UserInfo(
      uid: data['uid'],
      events: data['events'],
      interests: data['interests'],
      participationPoints: data['participationPoints'].toDouble(),
      totalParticipation: data['totalParticipation'].toDouble(),
    );
  }
}
