class FCMToken {
  String token;

  FCMToken({
    required this.token,
  });

  factory FCMToken.fromMap(Map data) {
    return FCMToken(token: data['token']);
  }
}
