import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/feed/addFe.dart';
import 'package:smart_refrigerator/views/feed/detailFe.dart';

class EveryPage extends StatefulWidget {
  @override
  _EveryPageState createState() => _EveryPageState();
}

class _EveryPageState extends State<EveryPage> {
  QuerySnapshot snapshotOfDocs;
  Stream<QuerySnapshot> feed;

  @override
  void initState() {
    getPost().then((snapshots) {
      setState(() {
        feed = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        title: Text('Every Refrigerator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedAdd()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
              stream: feed,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Expanded(
                        child: GridView.builder(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 40),
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) =>
                              _buildGridCards(snapshot.data.docs[index]),
                        ),
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  _buildGridCards(DocumentSnapshot document) {
    return InkWell(
      child: Card(
        elevation: 3,
        margin: EdgeInsets.fromLTRB(7, 0, 7, 14),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 12 / 7,
              child: (document['imageUrl'] != "")
                  ? Image.network(
                      document['imageUrl'],
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/default.jpeg",
                      fit: BoxFit.contain,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(35.0, 20.0, 10.0, 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            document['title'],
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w900),
                            maxLines: 1,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            document['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeDetail(document)),
        );
      },
    );
  }

  Future<dynamic> getPost() async {
    return FirebaseFirestore.instance
        .collection("feed")
        .orderBy('date', descending: true)
        .snapshots();
  }
}
