import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../models/Event.dart';
import '../../../widgets/Loader.dart';

import 'ClosedButton.dart';
import 'InsertCodeButton.dart';
import 'LeaveButton.dart';
import 'ParticipateButton.dart';

class EventActionButton extends StatefulWidget {
  final Event event;

  const EventActionButton({Key? key, required this.event}) : super(key: key);

  @override
  _EventActionButtonState createState() => _EventActionButtonState();
}

class _EventActionButtonState extends State<EventActionButton> {
  void showSnackBar(String text, Color backgroundColor) {
    var snackBar = new SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: backgroundColor,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 8, right: 40, left: 40),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget showButton(User user) {
    bool userIsParticipating = this
        .widget
        .event
        .participants
        .map((participant) => participant.uid)
        .contains(user.uid);

    var currentDate = DateTime.now();

    //TODO: Evaluate if user can join 24h before event
    bool eventIsBefore =
        currentDate.isBefore(this.widget.event.startTime.toDate());
    bool eventIsPast = currentDate.isAfter(this.widget.event.endTime.toDate());
    bool eventIsDuring = !eventIsBefore && !eventIsPast;

    if (userIsParticipating) {
      if (eventIsBefore) {
        return LeaveButton(
          event: this.widget.event,
          user: user,
          showSnackBar: this.showSnackBar,
        );
      } else if (eventIsDuring) {
        return InsertCodeButton(
          event: this.widget.event,
          showSnackBar: this.showSnackBar,
        );
      } else if (eventIsPast) {
        return ClosedButton();
      }
    }

    if (eventIsBefore) {
      return ParticipateButton(
        event: this.widget.event,
        user: user,
        showSnackBar: this.showSnackBar,
      );
    } else {
      return ClosedButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    if (user == null) {
      return Loader();
    }

    return showButton(user);
  }
}
