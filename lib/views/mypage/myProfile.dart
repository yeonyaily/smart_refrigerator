import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smart_refrigerator/service/firebase_provider.dart';
import '../../service/login.dart';
import 'editProfile.dart';

class ProfilePage extends StatefulWidget {
  String userUid;

  ProfilePage(String uid) {
    this.userUid = uid;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<QuerySnapshot> items;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  void initState() {
    getItems(widget.userUid).then((snapshots) {
      setState(() {
        items = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider userInformation = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          '마이 페이지',
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Image(
                          image: NetworkImage(userInformation.getUser().photoURL),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: [
                        Text(
                          userInformation.getUser().displayName,
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userInformation.getUser().email,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              StreamBuilder(
                  stream: items,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '소개 문구',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      child: OutlinedButton.icon(
                                        label: Text(
                                          '문구 편집',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 19,
                                        ),
                                        style: ButtonStyle(
                                          minimumSize: MaterialStateProperty.all(
                                              Size(10, 30)),
                                          shape: MaterialStateProperty.resolveWith<
                                              OutlinedBorder>((_) {
                                            return RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25));
                                          }),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfilePage(
                                                        snapshot.data.docs[0],
                                                        userInformation
                                                            .getUser()
                                                            .uid)),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  snapshot.data.docs[0]['des'],
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 20),
                                Divider(
                                  color: Colors.grey,
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.exit_to_app),
                                  title: Text(
                                    "로그아웃",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginPage()),
                                        ModalRoute.withName('/'));
                                  },
                                )
                              ],
                            ),
                          )
                        : Container();
                  }),
            ],
          ),
        ],
      ),
    );
  }

  showDiaLog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('월 1억원이 청구됩니다!' + '\n' + '정말 하시겠습니까?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '취소',
              ),
              onPressed: () {
                Navigator.pop(context, '취소');
              },
            ),
            FlatButton(
              child: Text(
                '확인',
              ),
              onPressed: () async {
                alert("카드잔액이 부족합니다.");
                Navigator.pop(context, '확인');
              },
            )
          ],
        );
      },
    );
  }

  alert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

Future<dynamic> getItems(userUid) async {
  return FirebaseFirestore.instance
      .collection("users")
      .where("uid", isEqualTo: userUid)
      .snapshots();
}
