import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Event.dart';
import '../../widgets/Loader.dart';
import '../../services/Database/Document.dart';

class ParticipateButton extends StatefulWidget {
  final Event event;

  const ParticipateButton({Key? key, required this.event}) : super(key: key);

  @override
  _ParticipateButtonState createState() => _ParticipateButtonState();
}

class _ParticipateButtonState extends State<ParticipateButton> {
  bool _userIsParticipating(User user) {
    var participants = widget.event.participants;

    return participants
        .map((participant) => participant.uid)
        .contains(user.uid);
  }

  void _userParticipate(BuildContext context, User user) async {
    var eventDoc = Document<Event>(path: 'events/${widget.event.id}');
    await eventDoc.update({
      "participants": FieldValue.arrayUnion([
        {
          "name": user.displayName,
          "photoUrl": user.photoURL,
          "uid": user.uid,
        }
      ])
    });

    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        'Parabéns! Você está participando deste evento!',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green[300],
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 8, right: 40, left: 40),
    ));
  }

  void _userLeave(BuildContext context, User user) async {
    var eventDoc = Document<Event>(path: 'events/${widget.event.id}');
    await eventDoc.update({
      "participants": FieldValue.arrayRemove([
        {
          "name": user.displayName,
          "photoUrl": user.photoURL,
          "uid": user.uid,
        }
      ])
    });

    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        "Você saiu deste evento. Esperamos vê-lo em breve!",
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red[300],
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 10, right: 40, left: 40),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return Loader();
    }

    return _userIsParticipating(user)
        ? SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              child: Text(
                'Sair deste evento',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () => _userLeave(context, user),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  primary: Colors.white,
                  backgroundColor: Colors.red[300]),
            ),
          )
        : SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              child: Text(
                'Participar deste Evento',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () => _userParticipate(context, user),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor),
            ),
          );
  }
}
