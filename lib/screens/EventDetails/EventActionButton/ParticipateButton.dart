import 'package:buddies/services/Database/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/Event.dart';
import '../../../services/Database/Document.dart';

import 'ConfirmParticipation.dart';

class ParticipateButton extends StatelessWidget {
  final Event event;
  final User user;

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

    var eventDoc = Document<Event>(path: 'events/${this.event.id}');
    await eventDoc.update({
      "participants": FieldValue.arrayUnion([
        {
          "name": this.user.displayName,
          "photoUrl": this.user.photoURL,
          "uid": this.user.uid,
        }
      ])
    });

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
