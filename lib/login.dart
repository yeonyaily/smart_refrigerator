import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 220.0),
          // Column(
          //   children: <Widget>[
          //     Image.asset(
          //       'assets/logo.png',
          //       width: 60,
          //       height: 60,
          //     ),
          //     SizedBox(height: 16.0),
          //   ],
          // ),
          SizedBox(height: 150.0),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: Colors.red[900],
                  ),
                  alignment: Alignment.center,
                  width: 50,
                  height: 45,
                  child: Text(
                    "G",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.red[200],
                  ),
                  alignment: Alignment.centerLeft,
                  width: 220,
                  height: 45,
                  child: Text(
                    "GOOGLE",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                )
              ],
            ),
            onTap: () async {
              User result = await signInUsingGoogle();
              if (result == null) {
                print('@@ error signing in');
              } else {
                print('@@ signed in');
                print(result.email);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

Future signInUsingGoogle() async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  UserCredential userCredential =
  await FirebaseAuth.instance.signInWithCredential(credential);
  return userCredential.user;
}


