import 'package:buddies/screens/Topics/quizlist.dart';
import 'package:flutter/material.dart';

import '../../services/services.dart';

class TopicScreen extends StatelessWidget {
  final Topic topic;

  TopicScreen({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: topic.img,
          child: Image.asset('assets/covers/${topic.img}',
              width: MediaQuery.of(context).size.width),
        ),
        Text(
          topic.title,
          style:
              TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        QuizList(topic: topic)
      ]),
    );
  }
}
