import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/Attendance.dart';
import '../../../models/Event.dart';
import '../../../services/Database/Document.dart';

class InsertParticipationCode extends StatelessWidget {
  final Event event;
  final User user;

  final inputController = TextEditingController();

  InsertParticipationCode({
    Key? key,
    required this.event,
    required this.user,
  }) : super(key: key);

  Future<Null> handleCodeValidation(BuildContext context, String code) async {
    var codeIsCorrect = (this.event.code == code);

    if (codeIsCorrect) {
      var attendance = Document<Attendance>(path: 'attendance/${event.id}');
      await attendance.update({
        "participantData.${this.user.uid}": true,
      });
    }

    Navigator.pop(
      context,
      codeIsCorrect,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Inserir código de participação"),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 60,
        child: TextButton(
          child: Text(
            'Enviar código',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () =>
              handleCodeValidation(context, this.inputController.text),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            primary: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              "Por favor insira o código de participação no campo a seguir:",
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 30),
            TextField(
              controller: inputController,
              decoration:
                  new InputDecoration(labelText: "Insira o código aqui"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
            SizedBox(height: 50),
            Text(
              "O código de participação no campo é disponibilizado pelo criador do evento. Peça o código para ele durante o evento para que sua presença possa ser contabilizada.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 30),
            Text(
              "Bom evento buddies! :)",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
