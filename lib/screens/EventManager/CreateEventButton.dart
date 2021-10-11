import 'package:flutter/material.dart';

import './EventCreator/EventCreator.dart';

class CreateEventButton extends StatelessWidget {
  const CreateEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      floating: true,
      pinned: true,
      flexibleSpace: Row(children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => EventCreator(),
                  ),
                )
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Criar um novo evento',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.add_box_outlined)
                ],
              ),
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.zero)),
                  primary: Color(0xFF444444),
                  backgroundColor: Theme.of(context).secondaryHeaderColor),
            ),
          ),
        ),
      ]),
      toolbarHeight: 50,
      collapsedHeight: 50,
      backgroundColor: Color(0xFFFFFFFF),
    );
  }
}
