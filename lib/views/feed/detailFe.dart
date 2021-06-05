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
    date = DateFormat('yyyy-MM-dd').add_Hms().format(doc.data()['date'].toDate());
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
            Container(
              //TODO: 이미지마다 Margin이 다름..
              width: 600,
              height: MediaQuery.of(context).size.height / 10 * 3.5,
              child: imageUrl == ""
                  ? Image.asset(
                      "assets/default.jpeg",
                      fit: BoxFit.fitWidth,
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top:2),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                      icon: ImageIcon(
                                        likeList.contains(uid)
                                            ? AssetImage('assets/heart_selected.png')
                                            : AssetImage('assets/heart.png'),
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        likeList.contains(uid)
                                            ? alert("You can only do it once !!")
                                            : updateLike(uid);
                                      }
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Text(
                                  like.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top:1),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: IconButton(
                                    icon: ImageIcon(
                                      AssetImage('assets/comment.png'),
                                    ),
                                    onPressed: () => {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:8, right:5),
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
                                  fontSize: 12,
                                  color: Colors.blue[900]),
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
                  SizedBox(height: 10.0),
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
