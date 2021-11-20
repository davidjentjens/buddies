import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../screens/EventDetails/EventActionButton/InsertParticipationCode.dart';
import '../../../models/Event.dart';
import '../../../models/Attendance.dart';
import '../../../widgets/Loader.dart';
import '../../../services/Database/Document.dart';

class InsertCodeButton extends StatelessWidget {
  final Event event;

  final Function showSnackBar;

  const InsertCodeButton({
    Key? key,
    required this.event,
    required this.showSnackBar,
  }) : super(key: key);

  Future<bool> userIsConfirmed(String uid) async {
    var attendance =
        await Document<Attendance>(path: 'attendance/${event.id}').getData();

    return attendance.participantData[uid] ?? false;
  }

  void userInsertCode(BuildContext context) async {
    bool? confirmed = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InsertParticipationCode(event: this.event)),
    );

    if (confirmed == null || !confirmed) {
      return;
    }

    this.showSnackBar(
      'Parabéns! Sua presença está confirmada neste evento!',
      Colors.green[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return FutureBuilder(
      future: userIsConfirmed(user.uid),
      builder: (BuildContext context, AsyncSnapshot futureSnapshot) {
        if (futureSnapshot.hasData) {
          return futureSnapshot.data
              ? SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sua presença está confirmada',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.check),
                        ],
                      ),
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        primary: Colors.white,
                        backgroundColor: Colors.green[300],
                      )),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                      child: Text(
                        'Inserir código de participação',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () => userInsertCode(context),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        primary: Colors.white,
                        backgroundColor: Color(0xFFF5A57A),
                      )),
                );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
