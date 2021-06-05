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
  String userUrl;
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
    userUrl = doc.data()['userUrl'];
    date =
        DateFormat('yyyy-MM-dd').add_Hms().format(doc.data()['date'].toDate());
  }

  @override
  Widget build(BuildContext context) {
    List<String> dates = date.split(RegExp(r" |:|-"));
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
            InkWell(
              child: Container(
                color: Colors.amber[100],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
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
              onDoubleTap: (){
                likeList.contains(UserInformation.uid)
                    ? updateLikeMinus(UserInformation.uid)
                    : updateLikePlus(UserInformation.uid);
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 3, 0),
                            child: InkWell(
                              child: Icon(
                                likeList.contains(UserInformation.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onTap: () {
                                likeList.contains(UserInformation.uid)
                                    ? updateLikeMinus(UserInformation.uid)
                                    : updateLikePlus(UserInformation.uid);
                              },
                            ),
                          ),
                          Text(
                            like.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, right: 7),
                            child: Icon(
                              Icons.insert_comment_rounded,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            like.toString(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8, right: 5),
                            child: Column(
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900]),
                                  maxLines: 1,
                                ),
                                Text(
                                  dates[0] + "/" + dates[1] + "/" + dates[2],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blue[900]),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          ClipOval(
                            child: Image.network(
                              userUrl,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        height: 1.3,
                      ),
                      maxLines: 10,
                    ),
                  ),
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
                    .collection("feed")
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

  updateLikePlus(String uid) {
    likeList.add(uid);
    FirebaseFirestore.instance.collection('feed').doc(widget.doc.id).update({
      "like": like + 1,
      "likeList": likeList,
    });
    setState(() {
      like = like + 1;
    });
  }

  updateLikeMinus(String uid) {
    likeList.remove(uid);
    FirebaseFirestore.instance.collection('feed').doc(widget.doc.id).update({
      "like": like - 1,
      "likeList": likeList,
    });
    setState(() {
      like = like - 1;
    });
  }
}
