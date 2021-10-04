import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text(
              'Um aplicativo para um mundo pós-pandêmico, onde muitos sofrem por não terem conseguido manter amigos antigos ou fazer amigos novos.'),
        ),
      ),
    );
  }
}
