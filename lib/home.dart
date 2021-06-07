import 'package:flutter/material.dart';
import 'package:smart_refrigerator/views/every/every.dart';
import 'package:smart_refrigerator/views/feed/feed.dart';
<<<<<<< HEAD
import 'package:smart_refrigerator/views/market.dart';
import 'package:smart_refrigerator/views/mypage/profile_page.dart';
=======
import 'package:smart_refrigerator/views/nearbysearch/nearbysearch.dart';
import 'package:smart_refrigerator/views/mypage/myPage.dart';
>>>>>>> 324d634e9ff74cb84fc44cecdd74ff5d586cf1cb
import 'package:smart_refrigerator/views/refrigerator/refrigerator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  List<Widget> _children;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final _selectedBgColor = Colors.pink[50];
  final _unselectedBgColor = Colors.grey[200];

  Color _getBgColor(int index) =>
      _currentIndex == index ? _selectedBgColor : _unselectedBgColor;

  Widget _buildIcon(IconData iconData, String text, int index) => Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight + 5,
        child: Material(
          color: _getBgColor(index),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(iconData),
                Text(text,
                    style: TextStyle(fontSize: 9, color: Colors.black87)),
              ],
            ),
            onTap: () => _onTap(index),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _children = [
      EveryPage(),
      FeedPage(),
      RefrigeratorPage(),
      MarketPage(),
      ProfilePage(),
    ];
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: 0,
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black87,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon:
                    _buildIcon(Icons.accessibility_new_outlined, '모두의 냉장고', 0),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.menu, '내 피드', 1),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.home_outlined, '나의 냉장고', 2),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.map, '마트 찾기', 3),
                title: SizedBox.shrink(),
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person_outline, '마이페이지', 4),
                title: SizedBox.shrink(),
              ),
            ]));
  }
}
