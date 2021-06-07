import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_refrigerator/userInfomation.dart';

class NumbersWidget extends StatefulWidget {

  @override
  _NumbersWidgetState createState() => _NumbersWidgetState();
}
class _NumbersWidgetState extends State<NumbersWidget> {
  Stream<QuerySnapshot> items;

  @override
  void initState() {
    getItems().then((snapshots) {
      setState(() {
        items = snapshots;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      StreamBuilder(
      stream: items,
      builder: (context, snapshot){
        return snapshot.hasData ?
       buildButton(context,snapshot.data.docs[0]['Items'].toString(), 'Feed')
            : Container();
      },
      ),
      buildDivider(),
      buildButton(context, '35', 'Following'),
      buildDivider(),
      buildButton(context, '50', 'Followers'),
    ],
  );
  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

Future<dynamic> getItems() async{
  return FirebaseFirestore.instance
      .collection("users")
      .where("name", isEqualTo: UserInformation.name)
      .snapshots();
}