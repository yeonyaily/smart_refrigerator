import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/mypage/widget/appbar_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/profile_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/button_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/numbers_widget.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<QuerySnapshot> items;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  void initState() {
    getItems().then((snapshots) {
      setState(() {
        items = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: UserInformation.photoURL,
          ),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
    children: [
      Text(
       UserInformation.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        UserInformation.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () => showDiaLog(),
  );

  Widget buildAbout() => StreamBuilder(
      stream: items,
      builder: (context, snapshot){
        return snapshot.hasData ?
        Container(
          padding: EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   'About',
                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                 ),
                 const SizedBox(height: 16),
                 Text(
                   snapshot.data.docs[0]['des'],
                   style: TextStyle(fontSize: 16, height: 1.4),
                   maxLines: 3,
                 ),
               ],
          ),
        )
        : Container();
      }
      );

  showDiaLog() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('월 1억원이 청구됩니다!'+'\n'+'정말 하시겠습니까?'),
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

Future<dynamic> getItems() async{
  return FirebaseFirestore.instance
      .collection("users")
      .where("name", isEqualTo: UserInformation.name)
      .snapshots();
}