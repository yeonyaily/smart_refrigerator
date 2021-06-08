import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_refrigerator/service/firebase_provider.dart';
import 'package:intl/intl.dart';
import 'addFe.dart';
import 'detailFe.dart';

class FeedPage extends StatefulWidget {
  String userUid;

  FeedPage(String uid){
    this.userUid = uid;
  }

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  QuerySnapshot snapshotOfDocs;
  Stream<QuerySnapshot> feed, items;

  @override
  void initState() {
    getPost(widget.userUid).then((snapshots) {
      setState(() {
        feed = snapshots;
      });
    });
    getItems(widget.userUid).then((snapshots) {
      setState(() {
        items = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider userInformation = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          '내 피드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15,8,0,0),
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25, left: 30, right: 20),
                child: ClipOval(
                  child: Image.network(
                    userInformation.getUser().photoURL,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    userInformation.getUser().displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  StreamBuilder(
                    stream: items,
                      builder: (context, snapshot){
                        return snapshot.hasData ?
                            Text(
                              snapshot.data.docs[0]['des'],
                              maxLines: 3,
                            ):
                            Text(
                              'none'
                            );
                      }
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left:15,top:5, bottom: 5),
                child:StreamBuilder(
                  stream: items,
                  builder: (context, snapshot){
                    return snapshot.hasData ?
                        Text(
                          snapshot.data.docs[0]['Items'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : Text("no");
                  }
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  'foods',
                ),
              ),
            ],
          ),
          Container(
            child: StreamBuilder(
              stream: feed,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 9 / 15,
                        ),
                        itemBuilder: (context, index) {
                          return _buildGridCards(snapshot.data.docs[index]);
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildGridCards(DocumentSnapshot document) {
    List<String> dates = DateFormat('yyyy-MM-dd').add_Hms().format(document['date'].toDate()).split(RegExp(r" |:|-"));
    return InkWell(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 3.0),
                        Text(
                          document['title'],
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w900),
                          maxLines: 1,
                        ),
                        SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            document['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:[
                          SizedBox(
                            width: 20,
                            child: ImageIcon(
                              AssetImage('assets/Chef_Hat.png'),
                              size: 24,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:4,right: 4),
                            child: Text(
                              document.data()['like'].toString(),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                          ImageIcon(
                            AssetImage('assets/Chat_Bubble.png'),
                            size: 17,
                          ),
                          Container(
                            margin: EdgeInsets.only(top:4),
                            child: Text(
                              document.data()['comments'].toString(),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top:4),
                        child: dates == null
                            ? CircularProgressIndicator()
                            : Text(
                          dates[1] + "/" + dates[2],
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
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

  Future<dynamic> getPost(userUid) async {
    return FirebaseFirestore.instance
        .collection("feed")
        .orderBy('date', descending: true)
        .where("uid", isEqualTo: userUid)
        .snapshots();
  }

  Future<dynamic> getItems(userUid) async{
    return FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: userUid)
        .snapshots();
  }

}
