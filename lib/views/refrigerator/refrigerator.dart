import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'addRe.dart';
import 'detailRe.dart';

class RefrigeratorPage extends StatefulWidget {
  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  QuerySnapshot snapshotOfDocs;
  Stream<QuerySnapshot> refrigerator;

  @override
  void initState() {
    getPost().then((snapshots) {
      setState(() {
        refrigerator = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent[100],
        title: Text('My Refrigerator'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductAdd()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: refrigerator,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Expanded(
                        child: GridView.builder(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 40),
                          itemCount: snapshot.data.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 3,
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
      child: Container(
        margin: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //TODO: 사이즈 좀만 더 늘리기.
            ClipOval(
              child:
                document['imageUrl'] != ""
                  ? Image.network(
                      document['imageUrl'],
                      fit: BoxFit.fill,
                      width: 65,
                      height: 65,
                )
                    : Image.asset(
                  "assets/default.jpeg",
                  fit: BoxFit.fill,
                  width: 65,
                  height: 65,
                ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            document['name'],
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w900),
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.0),
                          Text(
                            '유통기한 :' + document['expirationDate'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 7, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 3.0,),
                          Text(
                            '['+document['category']+']',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 7, fontWeight: FontWeight.w500),
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
          MaterialPageRoute(builder: (context) => ReDetail(document)),
        );
      },
    );
  }

  Future<dynamic> getPost() async {
    return FirebaseFirestore.instance
        .collection("refrigerator")
        .doc(UserInformation.uid)
        .collection("product")
        .orderBy('expirationDate', descending: false)
        .snapshots();
  }
}
