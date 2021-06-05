import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import '../../userInfomation.dart';
import 'addFe.dart';
import 'detailFe.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //TODO: Connect Follower / Following ( Stream )
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

                  //TODO: Connect with Profile Description.
                  Text(
                    '주로 한식을 만들어서 올립니다!',
                  ),
                  Text(
                    '🇰🇷초보 자취러',
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //TODO: Connect num of items.
              Container(
                margin: EdgeInsets.only(right: 4, top: 5),
                child: Text(
                  '48',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  'foods',
                ),
              ),
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
                            borderRadius: BorderRadius.circular(25));
                      }),
                    ),
                    onPressed: () => {}
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => EditProfilePage()),
                    // ),
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
    return InkWell(
      child: Container(
        height: 1500,
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                          SizedBox(height: 8.0),
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
}
