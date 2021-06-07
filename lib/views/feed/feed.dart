import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/mypage/edit_profile_page.dart';
import '../../userInfomation.dart';
import 'package:intl/intl.dart';
import 'addFe.dart';
import 'detailFe.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  QuerySnapshot snapshotOfDocs;
  Stream<QuerySnapshot> feed, items;

  @override
  void initState() {
    getPost().then((snapshots) {
      setState(() {
        feed = snapshots;
      });
    });
    getItems().then((snapshots) {
      setState(() {
        items = snapshots;
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
        title: Text(
          'My Feed',
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
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 35),
                child: Text(
                  '팔로워 531',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '팔로잉 395',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25, left: 30, right: 20),
                child: ClipOval(
                  child: Image.network(
                    UserInformation.photoURL,
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
                    UserInformation.name,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(left:3,top:5),
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
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'foods',
                ),
              ),
              StreamBuilder(
                  stream: items,
                  builder: (context, snapshot){
                    return snapshot.hasData ?
                    Container(
                      margin: EdgeInsets.only(left: 220),
                      child: OutlinedButton.icon(
                        label: Text(
                          '프로필 편집',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 19,
                        ),
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(Size(10, 30)),
                          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (_) {
                                return RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)
                                );
                              }),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(snapshot.data.docs[0])),
                          );
                        },
                      ),
                    ): Container();
                  }
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
                          childAspectRatio: 9 / 13,
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
              aspectRatio: 11 / 10,
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
                padding: EdgeInsets.fromLTRB(0,0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            document['title'],
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w900),
                            maxLines: 1,
                          ),
                          SizedBox(height: 2.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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

  Future<dynamic> getPost() async {
    return FirebaseFirestore.instance
        .collection("feed")
        .orderBy('date', descending: true)
        .where("name", isEqualTo: UserInformation.name)
        .snapshots();
  }

  Future<dynamic> getItems() async{
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: UserInformation.name)
        .snapshots();
  }

}
