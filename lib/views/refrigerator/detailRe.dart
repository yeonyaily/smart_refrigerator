import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_refrigerator/service/firebase_provider.dart';
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
    FirebaseProvider userInformation = Provider.of<FirebaseProvider>(context);
    String uid = userInformation.getUser().uid;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("상세 정보", style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        actions: [
          uid == docUid ?
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.create),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdateRe(widget.doc))
                    );
                  },
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deletePost(uid);
                  },
              ),
            ],
          ) : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      padding: EdgeInsets.fromLTRB(30,20,30,20),
                      child: ClipOval(
                        child: Container(
                          width: 190,
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child:
                          imageUrl == ""
                              ? Image.asset(
                            "assets/default.jpeg",
                            fit: BoxFit.fill,)
                              : Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.black,width: 2),
                    ),
                    child: Text(
                      '제품명 : ' + name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent[100]
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.black,width: 2),
                    ),
                    child: Text(
                      '유툥기한 : ' + expirationDate,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.pinkAccent[100],
                        fontWeight:FontWeight.bold,
                      ),
                      maxLines: 5,
                    ),
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

  deletePost(userUid) async {
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
                    .doc(userUid)
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
