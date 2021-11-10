class FCMToken {
  List<String> tokens;

  FCMToken({
    required this.tokens,
  });

  factory FCMToken.fromMap(Map data) {
    return FCMToken(tokens: data['tokens']);
  }
}
