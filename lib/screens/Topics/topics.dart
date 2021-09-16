import 'package:buddies/screens/Topics/topicdrawer.dart';
import 'package:buddies/screens/Topics/topicitem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/services.dart';
import '../../services/globals.dart';
import '../../shared/shared.dart';

import '../screens.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.topicsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Topic> topics = snap.data;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: Text('Topics'),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  icon: Icon(FontAwesomeIcons.userCircle,
                      color: Colors.pink[200]),
                )
              ],
            ),
            drawer: TopicDrawer(topics: topics),
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
