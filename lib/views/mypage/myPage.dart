import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/login.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'My Page',
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                semanticLabel: 'logout',
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                    ModalRoute.withName('/'));
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: EdgeInsets.fromLTRB(45, 20, 45, 30),
                child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.accentColor, width: 0.5),
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(UserInformation.photoURL, fit: BoxFit.fill)
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25,10,25,10),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '<Your UID>',
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          UserInformation.uid,
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.accentColor,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                color: theme.primaryColor,
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: Text(
                          '<Your Name>',
                          style: TextStyle(
                            fontSize: 20,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                              UserInformation.name,
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.accentColor,
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }
}