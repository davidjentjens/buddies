import "package:flutter/material.dart";

import 'package:buddies/services/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    var user = auth.user;

    user.listen((user) {
      if (user != null) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    });

    /*if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image.asset("assets/logo.png"),
                  const SizedBox(height: 64),
                  const TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Sign in"),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF00A19D),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey.withOpacity(1),
                      )),
                      Padding(
                          child: Text("or",
                              style: TextStyle(
                                color: Colors.grey.withOpacity(1),
                              )),
                          padding: const EdgeInsets.only(left: 8, right: 8)),
                      Expanded(
                          child: Divider(
                        color: Colors.grey.withOpacity(1),
                      ))
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  var user = await auth.googleSignIn();
                                  if (user != null) {
                                    Navigator.pushReplacementNamed(
                                        context, '/topics');
                                  }
                                },
                                icon: Image.asset("assets/google_icon.png"),
                                label: const Text("Sign in with Google"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    padding: const EdgeInsets.all(8)),
                              )))
                    ],
                  ),
                ]))));
  }
}
