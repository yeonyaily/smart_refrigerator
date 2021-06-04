import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/feed/updateFe.dart';

class FeDetail extends StatefulWidget {
  DocumentSnapshot doc;

  FeDetail(DocumentSnapshot document) {
    doc = document;
  }

  @override
  _FeDetailState createState() => _FeDetailState(doc);
}

class _FeDetailState extends State<FeDetail> {
  String title;
  String name;
  String description;
  String imageUrl;
  String date;
  String uid;
  int like;
  List<dynamic> likeList;

  _FeDetailState(DocumentSnapshot doc) {
    title = doc.data()['title'];
    description = doc.data()['description'];
    imageUrl = doc.data()['imageUrl'];
    name = doc.data()['name'];
    like = doc.data()['like'];
    likeList = doc.data()['likeList'];
    uid = doc.data()['uid'];
    date =
        DateFormat('yyyy-MM-dd').add_Hms().format(doc.data()['date'].toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(title),
        centerTitle: true,
        actions: [
          Row(
            children: [
              uid == UserInformation.uid
                  ? IconButton(
                      icon: Icon(Icons.create),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeUpdate(widget.doc)));
                      })
                  : Container(),
              uid == UserInformation.uid
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deletePost();
                      })
                  : Container(),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 400,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900]),
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                likeList.contains(uid)
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                likeList.contains(uid)
                                    ? alert("You can only do it once !!")
                                    : updateLike(uid);
                              }),
                          Text(
                            like.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900]),
                    maxLines: 1,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    description,
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

  alert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  updateLike(String uid) {
    likeList.add(uid);
    FirebaseFirestore.instance.collection('feed').doc(widget.doc.id).update({
      "like": like + 1,
      "likeList": likeList,
    });
    setState(() {
      like = like + 1;
    });
    alert("I LIKE IT!");
  }
}
