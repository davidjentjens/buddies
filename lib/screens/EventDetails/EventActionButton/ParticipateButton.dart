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

    //TODO: Move logic to functions
    var topicDoc = Document<Event>(path: 'topics/${this.event.id}');
    await topicDoc.update({
      "uids": FieldValue.arrayUnion([this.user.uid])
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
