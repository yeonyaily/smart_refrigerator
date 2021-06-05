import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smart_refrigerator/userInfomation.dart';


class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _imageUrl;
  String uid;
  String dropdownValue = '채소';
  DateTime _expiredDate = DateTime.now();

  Future<Null> _selectExpired(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _expiredDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2110)
    );
    if(picked != null && picked != _expiredDate)
      setState(() {
        _expiredDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    _imageUrl = "";
    uid = UserInformation.uid;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.black,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height:20),
                  ClipOval(
                    child: _image == null
                        ? Image.asset(
                      "assets/default.jpeg",
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,)
                        : Image.file(
                      _image,
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10),
                    child: Text(
                      "음식 사진 추가하기",
                      style: TextStyle(
                        color: const Color(0xff537D3B),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
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
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                        '이름 :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        controller: _nameController,
                        decoration: InputDecoration(
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Product Name',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading:
                      Text(
                        '분류 :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                            contentPadding: EdgeInsets.all(10),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isDense: true,
                            isExpanded: true,
                            style: const TextStyle(color:Colors.grey),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['채소', '육류','생선','과일','기타']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Text(
                        '유통기한 :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      title: Container(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            child: Text('Select Expired Date',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () => _selectExpired(context),
                          )
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
    storage.ref().child("refrigerator/" + uid + DateTime.now().toString());
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
    FirebaseFirestore.instance
        .collection("refrigerator")
        .doc(UserInformation.uid)
        .collection("product")
        .add({
      "uid": UserInformation.uid,
      "name": _nameController.text,
      "expirationDate": DateFormat("yyyy-MM-dd").format(_expiredDate),
      "imageUrl": _imageUrl,
      "category": dropdownValue,
    });
  }

  void defaultAdd() {
    createDoc();
    Navigator.of(context).pop();
  }
}