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
            selectedItemColor: Colors.green,
            type: BottomNavigationBarType.fixed,
            onTap: _onTap,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('홈'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('카테고리'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                title: Text('글쓰기'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                title: Text('채팅'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('마이페이지'),
              ),
            ]));
  }
}
