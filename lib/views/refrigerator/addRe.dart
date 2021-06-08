import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_refrigerator/service/firebase_provider.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';


class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class _ProductAddState extends State<ProductAdd> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _imageUrl;
  String uid;
  String dropdownValue = '채소';
  String _date = "Not set";
  DateTime _expiredDate = DateTime.now();

  Future<Null> _selectExpired(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _expiredDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2110),
    );
    if(picked != null && picked != _expiredDate)
      setState(() {
        _expiredDate = picked;
        _date = '${picked.year} - ${picked.month} - ${picked.day}';
      });
  }

  double _imageWidth;
  double _imageHeight;
  String _model = ssd;
  bool _busy = false;
  List _recognitions;

  @override
  void initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
          model: "assets/tflite/yolov2_tiny.tflite",
          labels: "assets/tflite/yolov2_tiny.txt",
        );
      } else {
        res = await Tflite.loadModel(
          model: "assets/tflite/ssd_mobilenet.tflite",
          labels: "assets/tflite/ssd_mobilenet.txt",
        );
      }
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  predictImage(File image) async {

    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {

      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    setState(() {
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

   ssdMobileNet(File image) async {

    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
      _recognitions.sort((A, B){
        var r = B["confidenceInClass"].compareTo(A["confidenceInClass"]);
        if(r != 0) return r;
        return B["confidenceInClass"].compareTo(A["confidenceInClass"]);
      });

      _nameController.text = _recognitions[0]["detectedClass"];

    });

  }
  @override
  Widget build(BuildContext context) {
    FirebaseProvider userInformation = Provider.of<FirebaseProvider>(context);
    _imageUrl = "";
    uid = userInformation.getUser().uid;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('추가하기', style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
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
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.black,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _image == null ? defaultAdd(userInformation.getUser().uid) : _uploadImageToStorage(userInformation.getUser().uid);
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
                                      onPressed: () async {
                                        await _getImage(ImageSource.gallery);
                                        _busy = true; //for tflite
                                        await predictImage(_image);
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
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
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
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          hintText: "Product Name",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: Colors.teal,
                                width: 2
                            ),
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
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                            contentPadding: EdgeInsets.all(10),

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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            isDense: true,
                            isExpanded: true,
                            style: const TextStyle(
                              color:Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['채소','육류','생선','과일','기타']
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
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),

                            onPressed: () => _selectExpired(context),
                            child:
                            Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 18.0,
                                              color: Colors.teal,
                                            ),
                                            Text(
                                              " $_date",
                                              style: TextStyle(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "  Change",
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0),
                                  ),
                                ],
                              ),
                            ),
                          color: Colors.white,
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

  void _uploadImageToStorage(userUid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
    storage.ref().child("refrigerator/" + uid + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      _imageUrl = downloadURL;
    });
    createDoc(userUid);
    Navigator.of(context).pop();
  }

  void createDoc(userUid) {
    FirebaseFirestore.instance
        .collection("refrigerator")
        .doc(userUid)
        .collection("product")
        .add({
      "uid": userUid,
      "name": _nameController.text,
      "expirationDate": DateFormat("yyyy-MM-dd").format(_expiredDate),
      "imageUrl": _imageUrl,
      "category": dropdownValue,
    });
  }

  void defaultAdd(userUid) {
    createDoc(userUid);
    Navigator.of(context).pop();
  }
}