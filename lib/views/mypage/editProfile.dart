import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:smart_refrigerator/service/firebase_provider.dart';

class EditProfilePage extends StatefulWidget {
  DocumentSnapshot doc;
  String userUid;

  EditProfilePage(DocumentSnapshot document, String uid) {
    doc = document;
    userUid = uid;
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState(doc);
}

class _EditProfilePageState extends State<EditProfilePage> {
  String des;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  TextEditingController descontroller = TextEditingController();
  Stream<QuerySnapshot> items;

  _EditProfilePageState(DocumentSnapshot doc) {
    des = doc.data()['des'];
  }

  @override
  void initState() {
    descontroller = TextEditingController(text: des);
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
    return Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              '프로필 수정',
            ),
            centerTitle: true,
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Image(
                          image: NetworkImage(userInformation.getUser().photoURL),
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이름',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          userInformation.getUser().displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이메일',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 3),
                        child: Text(
                          userInformation.getUser().email,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '자기소개',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: descontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: TextButton(
                      child: Text(
                        '저장',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.pink[100]),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                          minimumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width / 10 * 5,
                            45,
                          ))),
                      onPressed: () async {
                        await users
                            .doc(userInformation.getUser().uid)
                            .update({"des": descontroller.text}).then(
                                (value) => print('updated'));
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

Future<dynamic> getItems(userUid) async {
  return FirebaseFirestore.instance
      .collection("users")
      .where("uid", isEqualTo: userUid)
      .snapshots();
}
