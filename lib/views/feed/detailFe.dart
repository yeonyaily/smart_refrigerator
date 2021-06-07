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

  Stream<QuerySnapshot> comments;
  TextEditingController commentEditingController = new TextEditingController();
  var redocId;
  var _blankFocusnode = new FocusNode();


  @override
  void initState() {
    getComments(widget.doc.id).then((val) {
      setState(() {
        comments = val;
      });
    });
    super.initState();
  }

  getComments(String docId) async {
    return FirebaseFirestore.instance
        .collection("feed")
        .doc(docId)
        .collection("comments")
        .orderBy('date')
        .snapshots();
  }

  bool isRecomment = false;
  var _recommentFocusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<String> dates = date.split(RegExp(r" |:|-"));
    return GestureDetector(
      onTap: () {
        isRecomment = false;
        FocusScope.of(context).requestFocus(_blankFocusnode);
      },
      child: Scaffold(
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      onDoubleTap: () {
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
                                              color: Colors.purple[900]),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          dates[0] + "/" + dates[1] + "/" + dates[2],
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.purple[900]),
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
                    Divider(
                      color: Colors.black38,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,10),
                      child: Text(
                        '[ 댓글 ]',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: commentWindow(),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                isRecomment
                    ? Container(
                  child: Text(
                    '대댓글 작성중..',
                  ),
                  alignment: Alignment.centerLeft,
                  height: 25,
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.green[50],
                )
                    : Container(),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.075,
                  padding: EdgeInsets.fromLTRB(15, 8, 10, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          focusNode: _recommentFocusnode,
                          controller: commentEditingController,
                          decoration: InputDecoration(
                            hintText: '댓글 달기',
                            fillColor: Colors.grey[200],
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink[100])),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 45,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          shape: OutlineInputBorder(),
                          child: Text(
                            '등록',
                            style: TextStyle(color: Colors.pink[200]),
                          ),
                          onPressed: () {
                            isRecomment ? addReComment(redocId) : addComment();
                            isRecomment = false;
                            FocusManager.instance.primaryFocus.unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                decItems(UserInformation.uid);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void decItems(String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      value.reference.update({'Items': FieldValue.increment(-1)});
    });
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

  void addComment() {
    if (commentEditingController.text.isNotEmpty) {
      Map<String, dynamic> commentMap = {
        "sendBy": UserInformation.uid,
        "name": UserInformation.name,
        "comment": commentEditingController.text,
        'date': new DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()),
      };
      FirebaseFirestore.instance
          .collection("feed")
          .doc(widget.doc.id)
          .collection("comments")
          .add(commentMap)
          .catchError((e) {
        print(e.toString());
      });
      setState(() {
        commentEditingController.text = "";
      });
    }
  }

  void addReComment(redocId) {
    if (commentEditingController.text.isNotEmpty) {
      Map<String, dynamic> recommentMap = {
        "sendBy": UserInformation.uid,
        "name": UserInformation.name,
        "recomment": commentEditingController.text,
        'date': new DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now()),
      };
      FirebaseFirestore.instance
          .collection("feed")
          .doc(widget.doc.id)
          .collection("comments")
          .doc(redocId)
          .collection("recomments")
          .add(recommentMap)
          .catchError((e) {
        print(e.toString());
      });
      setState(() {
        commentEditingController.text = "";
      });
    }
  }

  Widget commentWindow() {
    return StreamBuilder(
      stream: comments,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                children: snapshot.data.docs.map<Widget>(
                  (DocumentSnapshot document) {
                    return Column(
                      children: <Widget>[
                        commentTile(document['sendBy'], document['name'],
                            document['comment'], document['date'], document.id),
                        SizedBox(
                          height: 5,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("feed")
                              .doc(widget.doc.id)
                              .collection("comments")
                              .doc(document.id)
                              .collection("recomments")
                              .orderBy('date')
                              .snapshots(),
                          builder: (context, snapshots) {
                            String codocId = document.id;
                            return snapshots.hasData
                                ? ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shrinkWrap: true,
                                    children: snapshots.data.docs.map<Widget>(
                                        (DocumentSnapshot document) {
                                      return recommentTile(
                                          document['sendBy'],
                                          document['name'],
                                          document['recomment'],
                                          document['date'],
                                          codocId,
                                          document.id);
                                    }).toList(),
                                  )
                                : Container();
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    );
                  },
                ).toList(),
              )
            : Container();
      },
    );
  }

  Widget commentTile(
      String id, String name, String comment, String date, String documentID) {
    var allTime = date.split(RegExp(r"-| |:"));
    var month = allTime[1];
    var day = allTime[2];
    var hour = allTime[3];
    var minute = allTime[4];
    var time = month + "/" + day + " " + hour + ":" + minute;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              id == UserInformation.uid
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 15, 0),
                      child: InkWell(
                        child: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.black45,
                        ),
                        onTap: () {
                          deleteComment(documentID);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(comment),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  child: Text(
                    '답글 달기',
                    style: TextStyle(fontSize: 10),
                  ),
                  onTap: () {
                    isRecomment = true;
                    redocId = documentID;
                    FocusScope.of(context).requestFocus(_recommentFocusnode);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget recommentTile(String id, String name, String comment, String date,
      String codocId, String documentID) {
    var allTime = date.split(RegExp(r"-| |:"));
    var month = allTime[1];
    var day = allTime[2];
    var hour = allTime[3];
    var minute = allTime[4];
    var time = month + "/" + day + " " + hour + ":" + minute;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.subdirectory_arrow_right, size: 20, color: Colors.black45),
        Expanded(
          child: Container(
            color: Colors.pink[50],
            margin: EdgeInsets.fromLTRB(5, 0, 0, 3),
            padding: EdgeInsets.fromLTRB(10, 3, 0, 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    id == UserInformation.uid
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(0, 3, 6, 0),
                            child: InkWell(
                              child: Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.black45,
                              ),
                              onTap: () {
                                deleteReComment(codocId, documentID);
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
                  child: Text(comment),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  deleteComment(String codocId) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          {
            return AlertDialog(
              content: Text('댓글을 삭제하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.pink[200]),
                  ),
                  onPressed: () {
                    Navigator.pop(context, '취소');
                  },
                ),
                TextButton(
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.pink[200]),
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('feed')
                        .doc(widget.doc.id)
                        .collection('comments')
                        .doc(codocId)
                        .delete();
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        });
  }

  deleteReComment(String codocId, String recodocId) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        {
          return AlertDialog(
            content: Text('대댓글을 삭제하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  '취소',
                  style: TextStyle(color: Colors.pink[200]),
                ),
                onPressed: () {
                  Navigator.pop(context, '취소');
                },
              ),
              TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.pink[200]),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('feed')
                      .doc(widget.doc.id)
                      .collection('comments')
                      .doc(codocId)
                      .collection('recomments')
                      .doc(recodocId)
                      .delete();
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
      },
    );
  }
}
