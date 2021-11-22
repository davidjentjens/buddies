import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../services/Database/DatabaseService.dart';
import '../../../widgets/ActiveEventCard.dart';
import '../../../widgets/Loader.dart';

class CurrentEvent extends StatelessWidget {
  const CurrentEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return LoadingScreen();
    }

    return StreamBuilder(
        stream: DatabaseService().streamUserCurrentEvent(user),
        builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, right: 18, left: 18),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Evento em andamento",
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                  ),
                  ActiveEventCard(event: streamSnapshot.data)
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
