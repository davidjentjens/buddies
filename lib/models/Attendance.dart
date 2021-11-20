import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String title;
  Timestamp emissionDate;
  String code;
  Map<dynamic, dynamic> participantData;

  Attendance({
    required this.title,
    required this.emissionDate,
    required this.participantData,
    required this.code,
  });

  factory Attendance.fromMap(Map data) {
    return Attendance(
      title: data['title'],
      emissionDate: data['emissionDate'],
      participantData: (data['participantData']),
      code: data['code'],
    );
  }
}
