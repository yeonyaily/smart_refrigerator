import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetItems extends StatelessWidget {
  String documentId;

  GetItems(String uid){
    documentId = uid;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Container(
            margin: EdgeInsets.only(left: 3, top: 5),
              child: Text(
                  "${data['Items']}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          );
        }
        return Text("loading");
      },
    );
  }
}