import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/mypage/widget/appbar_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget//profile_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/textfield_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/button_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  DocumentSnapshot doc;

  EditProfilePage(DocumentSnapshot document) {
    doc = document;
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState(doc);
}

class _EditProfilePageState extends State<EditProfilePage> {
  String des;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  TextEditingController descontroller = TextEditingController();
  Stream<QuerySnapshot> items;

  _EditProfilePageState(DocumentSnapshot doc){
    des = doc.data()['des'];
  }

  @override
  void initState() {
    descontroller = TextEditingController(text: des);
    getItems().then((snapshots) {
      setState(() {
        items = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: UserInformation.photoURL,
            isEdit: true,
            onClicked: () async {
              final image = await ImagePicker().getImage(source: ImageSource.gallery);
              if (image == null) return;
            },
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: UserInformation.name,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: UserInformation.email,
          ),
          const SizedBox(height: 24),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
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
          SizedBox(height: 24,),
          ButtonWidget(
            text: 'Save',
            onClicked: () async {
              await users.doc(UserInformation.uid).update({"des":descontroller.text}).then((value)=>print('updated'));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}


Future<dynamic> getItems() async{
  return FirebaseFirestore.instance
      .collection("users")
      .where("name", isEqualTo: UserInformation.name)
      .snapshots();
}