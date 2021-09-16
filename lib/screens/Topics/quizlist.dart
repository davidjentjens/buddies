import 'package:buddies/shared/progress_bar.dart';
import 'package:flutter/material.dart';

import '../../services/services.dart';

class QuizList extends StatelessWidget {
  final Topic topic;
  QuizList({Key? key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topic.quizzes.map((quiz) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 4,
          margin: EdgeInsets.all(4),
          child: InkWell(
            onTap: () {
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      QuizScreen(quizId: quiz.id),
                ),
              );*/
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  quiz.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  quiz.description,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                leading: QuizBadge(topic: topic, quizId: quiz.id),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
