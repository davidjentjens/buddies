import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/EventManager/EventEditor/EventEditor.dart';
import '../screens/EventDetails/EventDetails.dart';
import '../services/Database/DatabaseService.dart';
import '../models/Event.dart';

class EditEventCard extends StatelessWidget {
  final Event event;

  const EditEventCard({Key? key, required this.event}) : super(key: key);

  bool eventHasStarted(Event event) {
    return event.startTime.toDate().isBefore(DateTime.now());
  }

  Future<bool> confirmDeletion(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tem certeza que deseja deletar o evento?"),
        content: Text("Esta ação é irreversível."),
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
  }

  void snackBarDisplayDeletion(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        'Evento deletado com sucesso.',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green[300],
    ));
  }

  void showEditDeleteModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              height: !eventHasStarted(this.event)
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: 40.0,
                      height: 5.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                  Text(
                    "Evento ${event.title}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                        left: 100,
                        right: 100,
                      ),
                      child: Text(
                        event.code!,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("O que deseja fazer com este evento?"),
                  SizedBox(height: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EventDetailScreen(eventId: event.id),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility),
                        label: Text("Visualizar"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  !eventHasStarted(this.event)
                      ? SizedBox(height: 16)
                      : Container(),
                  !eventHasStarted(this.event)
                      ? Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EventEditor(event: event),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                                label: Text("Editar")),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () {
                            confirmDeletion(context).then((confirmed) => {
                                  if (confirmed)
                                    {
                                      DatabaseService().deleteEvent(event),
                                      snackBarDisplayDeletion(context),
                                      Navigator.pop(context)
                                    }
                                });
                          },
                          icon: Icon(Icons.delete),
                          label: Text("Deletar")),
                    ),
                  )
                ]),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          child: Stack(
            children: [
              Card(
                color: Color(0xFFfff4ed),
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    showEditDeleteModal(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              this.event.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person, size: 16),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${event.participants.length.toString()}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.MMMMd('pt_BR')
                              .add_jm()
                              .format(event.startTime.toDate()),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(event.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: new Container(
                  padding: EdgeInsets.all(5),
                  decoration: new BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 22,
                    minHeight: 22,
                  ),
                  child: new Text(
                    'Código: ${this.event.code}',
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class EventImage extends StatelessWidget {
  final String eventImage;

  const EventImage({
    Key? key,
    required this.eventImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image(
            image: NetworkImage(eventImage),
            fit: BoxFit.fitWidth,
            height: 150,
          ),
        ),
      ),
    ]);
  }
}
