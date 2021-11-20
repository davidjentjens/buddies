import 'package:buddies/models/Event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InsertParticipationCode extends StatelessWidget {
  final Event event;

  const InsertParticipationCode({Key? key, required this.event})
      : super(key: key);

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
          onPressed: () => {Navigator.pop(context, true)},
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
              decoration:
                  new InputDecoration(labelText: "Insira o código aqui"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            )
          ],
        ),
      ),
    );
  }
}
