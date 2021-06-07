import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/login.dart';

AppBar buildAppBar(BuildContext context) {

  return AppBar(
    leading: Padding(
      padding: const EdgeInsets.fromLTRB(15,8,0,0),
      child: Image.asset(
        'assets/logo.png',
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(
      'User Profile',
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              ModalRoute.withName('/'));
        },
      )
    ],
  );
}