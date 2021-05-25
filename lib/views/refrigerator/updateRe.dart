import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_refrigerator/userInfomation.dart';

class UpdateRe extends StatefulWidget {
  DocumentSnapshot doc;

  UpdateRe(DocumentSnapshot document) {
    doc = document;
  }

  @override
  _UpdateReState createState() => _UpdateReState(doc);
}

class _UpdateReState extends State<UpdateRe> {
  final _nameController = TextEditingController();
  final _expirationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _imageUrl;
  String uid;

  _UpdateReState(DocumentSnapshot doc) {
    _imageUrl = doc.data()["imageUrl"];
    _nameController.text = doc.data()["name"];
    _expirationController.text = doc.data()["expiration"];
  }

  @override
  Widget build(BuildContext context) {
    uid = UserInformation.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leadingWidth: 70,
        leading: Container(
          child: TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text('Edit'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _image == null ? updateDoc() : _uploadImageToStorage();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  height: 250,
                  child: _image == null
                      ? (_imageUrl == ""
                          ? Image.asset(
                              "assets/default.jpeg",
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              _imageUrl,
                              fit: BoxFit.contain,
                            ))
                      : Image.file(
                          _image,
                          fit: BoxFit.contain,
                        )),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("사진 업로드"),
                            content: new Text("방식을 선택하세요."),
                            actions: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new FlatButton(
                                      child: new Text("사진첩"),
                                      onPressed: () {
                                        _getImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("카메라"),
                                      onPressed: () async {
                                        _getImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ]),
                            ],
                          );
                        },
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Product Name',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      controller: _expirationController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getImage(ImageSource source) async {
    PickedFile file;
    ImagePicker _picker = ImagePicker();
    if (source == ImageSource.gallery) {
      file = await _picker.getImage(source: source);
    } else {
      file = await _picker.getImage(source: source);
    }

    if (file == null) return;
    setState(() {
      _image = File(file.path);
    });
  }

  void _uploadImageToStorage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("post/" + uid + DateTime.now().toString());

    UploadTask uploadTask = ref.putFile(_image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl = downloadURL;
    });
    updateDoc();
  }

  void updateDoc() {
    FirebaseFirestore.instance.collection("post").doc(widget.doc.id).update({
      "name": _nameController.text,
      "expirationDate": _expirationController.text,
      "imageUrl": _imageUrl,
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
