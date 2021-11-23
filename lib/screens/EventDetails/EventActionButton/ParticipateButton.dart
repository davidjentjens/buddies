import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/Event.dart';
import '../../../models/UserInfo.dart';
import '../../../services/Database/Document.dart';
import '../../../services/Database/DatabaseService.dart';

import 'ConfirmParticipation.dart';

class ParticipateButton extends StatelessWidget {
  final Event event;
  final FirebaseAuth.User user;

  final Function showSnackBar;

  const ParticipateButton({
    Key? key,
    required this.event,
    required this.user,
    required this.showSnackBar,
  }) : super(key: key);

  void _userParticipate(BuildContext context) async {
    if (await DatabaseService()
        .hasConflictingEventTimes(this.user.uid, this.event)) {
      this.showSnackBar(
        'Você está participando de um evento cujo horário coincide com este. Verifique sua Agenda.',
        Colors.red[300],
      );
      return;
    }

    bool? confirmed = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmParticipation(event: this.event)),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

    var userInfoDoc = Document<Event>(path: 'userinfo/${this.user.uid}');
    await userInfoDoc.update({
      "events": FieldValue.arrayUnion([
        {
          "id": this.event.id,
          "startTime": this.event.startTime,
          "endTime": this.event.endTime,
        }
      ]),
      "participantUids": FieldValue.arrayUnion([this.user.uid])
    });

    var userInfo =
        await Document<UserInfo>(path: 'userinfo/${user.uid}').getData();
    var rating = 5.0;
    if (userInfo.totalParticipation != 0) {
      rating = (userInfo.participationPoints / userInfo.totalParticipation) * 5;
    }

    var eventDoc = Document<Event>(path: 'events/${this.event.id}');
    await eventDoc.update({
      "participants": FieldValue.arrayUnion([
        {
          "name": this.user.displayName,
          "photoUrl": this.user.photoURL,
          "uid": this.user.uid,
          "rating": rating.toStringAsFixed(1)
        }
      ]),
      "participantUids": FieldValue.arrayUnion([this.user.uid])
    });

    this.showSnackBar(
      'Parabéns! Você está participando deste evento!',
      Colors.green[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        child: Text(
          'Participar deste Evento',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => _userParticipate(context),
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            primary: Colors.white,
            backgroundColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
