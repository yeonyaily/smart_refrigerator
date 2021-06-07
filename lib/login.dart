import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final int items = 0;
  final String des = "";
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> addUserToDB(String uid, int items, String des, String name){
    return users.doc(uid).get().then((value) {
      if(!value.exists) {
        users.doc(uid).set({
          'Items':items,
          'des':des,
          'name': name,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 150.0),
          Column(
            children: <Widget>[
              Image.asset(
                'assets/ic_launcher.png',
                width: 270,
                height: 300,
              ),
            ],
          ),
          SizedBox(height: 50,),
          InkWell(
            child:
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  alignment: Alignment.center,
                  child: OutlineButton(
                    splashColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.black),
                    onPressed: () async {
                      User result = await signInUsingGoogle();
                      if (result == null) {
                        print('@@ error signing in');
                      } else {
                        print('@@ signed in');
                        print(result.displayName);
                        print(result.email);
                        UserInformation.uid = result.uid;
                        UserInformation.name = result.displayName;
                        UserInformation.photoURL = result.photoURL;
                        UserInformation.email = result.email;
                        addUserToDB(result.uid,items,des, result.displayName);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    },
                    child: Padding(
                      padding:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(image: AssetImage("assets/google.png"), height: 35,),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    )
                                )
                            )
                          ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
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


