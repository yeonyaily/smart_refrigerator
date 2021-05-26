import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/refrigerator/updateRe.dart';

class ReDetail extends StatefulWidget {
  DocumentSnapshot doc;

  ReDetail(DocumentSnapshot document) {
    doc = document;
  }

  @override
  _ReDetailState createState() => _ReDetailState(doc);
}

class _ReDetailState extends State<ReDetail> {
  String name;
  String expirationDate;
  String docUid;
  String imageUrl;

  _ReDetailState(DocumentSnapshot doc) {
    name = doc.data()['name'];
    expirationDate = doc.data()['expirationDate'];
    docUid = doc.data()['uid'];
    imageUrl = doc.data()['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    String uid = UserInformation.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detail'),
        centerTitle: true,
        actions: [
          uid == docUid
              ? Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.create),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateRe(widget.doc))
                          );
                        }
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePost();
                        }
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250,
              child: imageUrl == ""
                  ? Image.asset(
                      "assets/default.jpeg",
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                    maxLines: 1,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    expirationDate,
                    style: TextStyle(
                        fontSize: 12, color: Colors.indigo[300], height: 1.5),
                    maxLines: 5,
                  ),
                  SizedBox(height: 130),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deletePost() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('정말 삭제하시겠습니까?'),
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
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("refrigerator")
                    .doc(UserInformation.uid)
                    .collection("product")
                    .doc(widget.doc.id)
                    .delete();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
