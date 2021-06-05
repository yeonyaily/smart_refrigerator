import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:smart_refrigerator/views/mypage/page/profile_page.dart';
import 'package:smart_refrigerator/views/mypage/themes.dart';
import 'package:smart_refrigerator/views/mypage/utils/user_preference.dart';


class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  static final String title = 'User Profile';
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    final ThemeData theme = Theme.of(context);
    return ThemeProvider(
        initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.of(context),
            title: title,
            home: ProfilePage(),
          ),
        ),
    );
  }
}