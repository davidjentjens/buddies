import 'package:buddies/models/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/Event.dart';
import '../../../services/Database/Document.dart';

class LeaveButton extends StatelessWidget {
  final Event event;
  final FirebaseAuth.User user;

  final Function showSnackBar;

  const LeaveButton({
    Key? key,
    required this.event,
    required this.user,
    required this.showSnackBar,
  }) : super(key: key);

  void _userLeave(BuildContext context, FirebaseAuth.User user) async {
    var eventDate = DateTime.fromMillisecondsSinceEpoch(
        this.event.startTime.millisecondsSinceEpoch);

    if (this.event.creator.uid == user.uid) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Ação bloqueada"),
          content: Text(
              "O criador do evento não pode sair do mesmo. Se desejar cancelar o evento, delete-o na tela de gerenciamento de eventos."),
          actions: [
            TextButton(
              onPressed: () => {Navigator.pop(context, true)},
              child: Text("Ok"),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return;
    }

    var userInfoDoc = Document<UserInfo>(path: 'userinfo/${user.uid}');
    await userInfoDoc.update({
      "events": FieldValue.arrayRemove([
        {
          "id": this.event.id,
          "startTime": this.event.startTime,
          "endTime": this.event.endTime,
        }
      ])
    });

    if (eventDate.difference(DateTime.now()).inHours < 24) {
      bool confirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Confirmação de Saída"),
          content: Text(
              "Este evento irá começar em menos de 24 horas. Se você sair agora, está concordando em receber uma pequena penalidade no seu ranking. Tem certeza que deseja sair?"),
          actions: [
            TextButton(
              onPressed: () => {Navigator.pop(context, false)},
              child: Text("Não"),
            ),
            TextButton(
              onPressed: () => {Navigator.pop(context, true)},
              child: Text("Sim"),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (!confirm) {
        return;
      } else {
        await userInfoDoc.update({
          "participationPoints": FieldValue.increment(0.75),
          "totalParticipation": FieldValue.increment(1)
        });
      }
    }

    var eventDoc = Document<Event>(path: 'events/${this.event.id}');

    var participantData = this
        .event
        .participants
        .singleWhere((element) => element.uid == this.user.uid);

    await eventDoc.update({
      "participants": FieldValue.arrayRemove([
        {
          "name": user.displayName,
          "photoUrl": user.photoURL,
          "uid": user.uid,
          "rating": participantData.rating
        }
      ]),
      "participantUids": FieldValue.arrayRemove([user.uid])
    });

    this.showSnackBar(
      "Você saiu deste evento. Esperamos vê-lo em breve!",
      Colors.red[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            borderRadius: BorderRadius.all(Radius.zero),
          ),
          primary: Colors.white,
          backgroundColor: Colors.red[300],
        ),
      ),
    );
  }
}
