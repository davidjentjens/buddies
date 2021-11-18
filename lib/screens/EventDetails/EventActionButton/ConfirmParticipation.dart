import 'package:buddies/models/Event.dart';
import 'package:flutter/material.dart';

class ConfirmParticipation extends StatelessWidget {
  final Event event;

  const ConfirmParticipation({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Termos de compromisso"),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 60,
        child: TextButton(
          child: Text(
            'Concordo com os termos acima',
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
              "Para podermos providenciar a melhor experiência aos nossos Buddies, consideramos que é importante que os participantes respeitem uns aos outros. Portanto, ao confirmar sua participação neste evento, você está concordando com os termos a seguir:",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 30),
            Text(
              "* Eu me comprometo a comparecer no local marcado no horário definido.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              "* Caso eu não possa comparecer por algum imprevisto, irei sair do evento pelo app com pelo menos 24 horas de antecedência.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              "* Eu não irei desrespeitar nem ofender nenhum participante, por quaisquer motivos.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              "* Se descumprir com os termos acima, estarei me submetendo a uma possível diminuição no ranking do meu perfil, o que pode afetar negativamente minha participação em eventos futuros.",
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
