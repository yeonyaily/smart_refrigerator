import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addRe.dart';
import 'detailRe.dart';

class RefrigeratorPage extends StatefulWidget {
  String userUid;

  RefrigeratorPage(String uid){
    this.userUid = uid;
  }

  @override
  _RefrigeratorPageState createState() => _RefrigeratorPageState();
}

class _RefrigeratorPageState extends State<RefrigeratorPage> {
  QuerySnapshot snapshotOfDocs;
  Stream<QuerySnapshot> refrigerator;

  @override
  void initState() {
    getPost(widget.userUid).then((snapshots) {
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
            height: 40,
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

    var color;
    final expireDate = DateTime.parse(document['expirationDate']);
    final nowDate = DateTime.now();
    final difference = expireDate.difference(nowDate).inDays;
    difference > 2 ? color = Colors.green : color = Colors.red;

    return InkWell(
      child: Column(
        children: <Widget>[
          Stack(
            children: [
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
                  )
              ),
              Positioned(
                bottom: -3,
                right: 5,
                child: expirationCircle(color),
              )
            ],
          ),
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
  Widget expirationCircle(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: ClipOval(
        child: Container(
          height: 1,
          width: 1,
        ),
      ),
    ),
  );

  Widget buildCircle({
    @required Widget child,
    @required double all,
    @required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Future<dynamic> getPost(userUid) async {
    return FirebaseFirestore.instance
        .collection("refrigerator")
        .doc(userUid)
        .collection("product")
        .orderBy('expirationDate', descending: false)
        .snapshots();
  }
}