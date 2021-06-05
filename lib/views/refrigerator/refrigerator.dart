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
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('나의 냉장고', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15,8,0,0),
          child: Image.asset('assets/logo.png'),
        ),
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
      body: Column(
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
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 9 / 13,
                  ),
                  itemBuilder: (context, index) =>
                      _buildGridCards(snapshot.data.docs[index]),
                ),
              )
                  : Container();
            },
          ),
        ],
      ),
    );
  }

  _buildGridCards(DocumentSnapshot document) {
    return InkWell(
      child: Column(
        children: <Widget>[
          //TODO: 사이즈 좀만 더 늘리기.
          ClipOval(
              child: document['imageUrl'] != ""
                  ? Image.network(
                document['imageUrl'],
                fit: BoxFit.fill,
                width: 75,
                height: 75,
              )
                  : Image.asset(
                "assets/default.jpeg",
                fit: BoxFit.fill,
                width: 75,
                height: 75,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            document['name'],
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            maxLines: 1,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            document['expirationDate'],
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '[' + document['category'] + ']',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
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