import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('모두의 냉장고', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15,8,0,0),
          child: Image.asset('assets/logo.png'),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: feed,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _buildListTile(snapshot.data.docs[index]),
                  )
                : Container();
          },
        ),
      ),
      // resizeToAvoidBottomInset: false,
    );
  }

  _buildListTile(DocumentSnapshot document) {
    List<String> date = DateFormat('yyyy-MM-dd')
        .add_Hms()
        .format(document['date'].toDate())
        .split(RegExp(r" |:|-"));
    String name = document['name'];
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 10 * 3.5,
              height: MediaQuery.of(context).size.width / 10 * 3.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: (document['imageUrl'] != "")
                    ? Container(
                        child: Image.network(
                          document['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        child: Image.asset(
                          "assets/default.jpeg",
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(17.0, 10.0, 5.0, 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width / 10 * 2.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                document['title'],
                                style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w900),
                                maxLines: 1,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                document['description'],
                                style: TextStyle(
                                  fontSize: 10, fontWeight:FontWeight.w500,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          date[1] +
                              "/" +
                              date[2] +
                              "\n" +
                              date[3] +
                              ":" +
                              date[4],
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    Text(
                      "by $name 냉장고",
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w900),
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
