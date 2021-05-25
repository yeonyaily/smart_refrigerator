import 'package:flutter/material.dart';
import 'package:smart_refrigerator/views/every/every.dart';
import 'package:smart_refrigerator/views/feed/feed.dart';
import 'package:smart_refrigerator/views/market.dart';
import 'package:smart_refrigerator/views/mypage/myPage.dart';
import 'package:smart_refrigerator/views/refrigerator/refrigerator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      EveryPage(),
      FeedPage(),
      RefrigeratorPage(),
      MarketPage(),
      MyPage()
    ];
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.pinkAccent[100],
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.accessibility),
                title: Text('모두의 냉장고'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('내 피드'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.water_damage),
                title: Text('나의 냉장고'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apartment_rounded),
                title: Text('마트 찾기'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('마이페이지'),
              ),
            ]));
  }
}
