import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Event.dart';
import '../../widgets/Loader.dart';
import '../../services/Database/Document.dart';
import '../../services/Messaging.dart';

import './ConfirmParticipation.dart';

class ParticipateButton extends StatefulWidget {
  final Event event;

  const ParticipateButton({Key? key, required this.event}) : super(key: key);

  @override
  _ParticipateButtonState createState() => _ParticipateButtonState();
}

class _ParticipateButtonState extends State<ParticipateButton> {
  bool _eventIsPast() {
    return DateTime.now().isAfter(this.widget.event.startTime.toDate());
  }

  bool _userIsParticipating(User user) {
    var participants = widget.event.participants;

    return participants
        .map((participant) => participant.uid)
        .contains(user.uid);
  }

  void _userParticipate(BuildContext context, User user) async {
    bool? confirmed = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConfirmParticipation(event: this.widget.event)),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

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

    await Messaging().subscribeToTopic(this.widget.event.id);

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
    var eventDate = DateTime.fromMillisecondsSinceEpoch(
        this.widget.event.startTime.millisecondsSinceEpoch);

    if (this.widget.event.creator.uid == user.uid) {
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
        //TODO: Implementar redução de ranking
      }
    }

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

    await Messaging().unsubscribeFromTopic(this.widget.event.id);

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

    return _eventIsPast()
        ? SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              child: Text(
                'Este evento está fechado',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () => {},
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  primary: Colors.white,
                  backgroundColor: Colors.grey[500]),
            ),
          )
        : _userIsParticipating(user)
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
