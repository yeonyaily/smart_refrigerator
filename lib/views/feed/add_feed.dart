import 'package:smart_refrigerator/views/feed/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

CollectionReference products = FirebaseFirestore.instance.collection('products');

class _AddPageState extends State<AddPage> {

  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add')),
        leading: TextButton(
          child: Text('Cancel'),
          style: TextButton.styleFrom(
              primary: Colors.black, textStyle: TextStyle(fontSize: 12)),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => FeedPage()
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Save'),
            style: TextButton.styleFrom(
                primary: Colors.white, textStyle: TextStyle(fontSize: 12)),
            onPressed: () {
              addProduct(UserInformation.uid.toString(), productNameController.text, descriptionController.text);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => FeedPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blue,
                        width: 2,
                        style: BorderStyle.solid)),
                labelText: "Product Name",
                fillColor: Colors.blue,
                labelStyle: TextStyle(
                  color: Colors.blue,
                )),
            controller: productNameController,
          ),
          TextField(
            decoration: InputDecoration(
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                        color: Colors.blue,
                        width: 2,
                        style: BorderStyle.solid)),
                labelText: "Description",
                fillColor: Colors.white,
                labelStyle: TextStyle(
                  color: Colors.blue,
                )),
            controller: descriptionController,
          ),
        ],
      ),
    );
  }
  Future<void> addProduct(String uid, String productName, String description) {
    return products.add({
      'creator': uid,
      'created': FieldValue.serverTimestamp(),
      'modified': FieldValue.serverTimestamp(),
      'productName': productName,
      'description': description,
      'imageUrl': 'https://handong.edu/site/handong/res/img/logo.png'
    })
        .then((value) => print("Product Added"))
        .catchError((error) => print("Failed to add Product: $error"));
  }
}