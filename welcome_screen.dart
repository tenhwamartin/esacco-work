import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    late User loggedinUser;
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 28, 49, 76),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 135, 206, 235),
                      fontSize: 72.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'to the eSacco app.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 51, 153, 255),
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                RoundedButton(
                  colour: Colors.greenAccent[400],
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
                const SizedBox(
                  height: 20.0,
                  child: Center(
                      child: Text(
                    'Or',
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                  )),
                ),
                RoundedButton(
                    colour: Colors.purple,
                    title: 'Sign up',
                    onPressed: () {
                      Navigator.pushNamed(context, 'sign_up_screen');
                    }),
              ]),
        ));
  }
}
