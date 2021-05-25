// import 'dart:io';
// import 'package:Shrine/anonymous_user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
//
// class FoodAdd extends StatefulWidget {
//   @override
//   _FoodAddState createState() => _FoodAddState();
// }
//
// class _FoodAddState extends State<FoodAdd> {
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _expirationController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   File _image;
//   String _imageUrl;
//   String uid;
//
//   @override
//   Widget build(BuildContext context) {
//     uid = AnonymousUser.uid;
//     _imageUrl = "";
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey,
//         leadingWidth: 70,
//         leading: Container(
//           child: TextButton(
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.black),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         title: Text('Add'),
//         centerTitle: true,
//         actions: <Widget>[
//           TextButton(
//             child: Text(
//               "Save",
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () {
//               if (_formKey.currentState.validate()) {
//                 _image == null ? defaultAdd() : _uploadImageToStorage();
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Container(
//                 height: 250,
//                 child: _image == null
//                     ? Image.asset(
//                   "assets/default.png",
//                   fit: BoxFit.contain,
//                 )
//                     : Image.file(
//                   _image,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                     icon: Icon(Icons.camera_alt),
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: new Text("사진 업로드"),
//                             content: new Text("방식을 선택하세요."),
//                             actions: <Widget>[
//                               Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     new FlatButton(
//                                       child: new Text(
//                                         "사진첩",
//                                       ),
//                                       onPressed: () {
//                                         _getImage(ImageSource.gallery);
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                     new FlatButton(
//                                       child: new Text("카메라"),
//                                       onPressed: () async {
//                                         _getImage(ImageSource.camera);
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                     new FlatButton(
//                                       child: new Text("Close"),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   ]),
//                             ],
//                           );
//                         },
//                       );
//                     }),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter name';
//                         }
//                         return null;
//                       },
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         labelText: 'Product Name',
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter price';
//                         }
//                         return null;
//                       },
//                       controller: _priceController,
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         filled: true,
//                         labelText: 'Price',
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter description';
//                         }
//                         return null;
//                       },
//                       controller: _descriptionController,
//                       decoration: InputDecoration(
//                         filled: true,
//                         labelText: 'Description',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _getImage(ImageSource source) async {
//     PickedFile file;
//     ImagePicker _picker = ImagePicker();
//     if (source == ImageSource.gallery) {
//       file = await _picker.getImage(source: source);
//     } else {
//       file = await _picker.getImage(source: source);
//     }
//
//     if (file == null) return;
//     setState(() {
//       print(_image);
//       _image = File(file.path);
//     });
//   }
//
//   void _uploadImageToStorage() async {
//     FirebaseStorage storage = FirebaseStorage.instance;
//     Reference ref =
//     storage.ref().child("post/" + uid + DateTime.now().toString());
//
//     UploadTask uploadTask = ref.putFile(_image);
//
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//
//     String downloadURL = await taskSnapshot.ref.getDownloadURL();
//     setState(() {
//       _imageUrl = downloadURL;
//     });
//     createDoc();
//     Navigator.of(context).pop();
//
//   }
//
//   void createDoc() {
//     List<String> list = List();
//     FirebaseFirestore.instance.collection("post").add({
//       "name": _nameController.text,
//       "price": int.parse(_priceController.text),
//       "expirationDate": _expirationController.text,
//       "imageUrl": _imageUrl,
//       "uid": uid,
//       "like": 0,
//       "likeList" : list,
//     });
//   }
//
//   void defaultAdd(){
//     createDoc();
//     Navigator.of(context).pop();
//   }
// }
