import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:smart_refrigerator/views/mypage/widget/appbar_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/profile_widget.dart';
import 'package:smart_refrigerator/views/mypage/edit_profile_page.dart';
import 'package:smart_refrigerator/views/mypage/widget/button_widget.dart';
import 'package:smart_refrigerator/views/mypage/widget/numbers_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: UserInformation.photoURL,
            onClicked: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
    children: [
      Text(
       UserInformation.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        UserInformation.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Upgrade To PRO',
    onClicked: () {},
  );

  Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          "*",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}
