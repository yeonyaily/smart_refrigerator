import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_refrigerator/userInfomation.dart';

class FeedAdd extends StatefulWidget {
  @override
  _FeedAddState createState() => _FeedAddState();
}

class _FeedAddState extends State<FeedAdd> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _imageUrl;
  String uid;
  String name;

  @override
  Widget build(BuildContext context) {
    _imageUrl = "";
    uid = UserInformation.uid;
    name = UserInformation.name;
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
        title: Text('Add'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _image == null ? defaultAdd() : _uploadImageToStorage();
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
                    ? Image.asset(
                  "assets/default.jpeg",
                  fit: BoxFit.contain,
                )
                    : Image.file(
                  _image,
                  fit: BoxFit.contain,
                ),
              ),
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
                                      child: new Text(
                                        "사진첩",
                                      ),
                                      onPressed: () {
                                        _getImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("카메라"),
                                      onPressed: () async {
                                        _getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]),
                            ],
                          );
                        },
                      );
                    }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' 제목',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.pinkAccent[100])),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      ' 상세 정보',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                      controller: _descriptionController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.pinkAccent[100])),
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
      print(_image);
      _image = File(file.path);
    });
  }

  void _uploadImageToStorage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
    storage.ref().child("feed/" + uid + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      _imageUrl = downloadURL;
    });
    createDoc();
    Navigator.of(context).pop();
  }

  void createDoc() {
    List<String> list = List();
    FirebaseFirestore.instance
        .collection("feed")
        .add({
      "title": _titleController.text,
      "description": _descriptionController.text,
      "date": FieldValue.serverTimestamp(),
      "imageUrl": _imageUrl,
      "uid": uid,
      "name": name,
      "like": 0,
      "likeList" : list,
    });
  }

  void defaultAdd() {
    createDoc();
    Navigator.of(context).pop();
  }
}
