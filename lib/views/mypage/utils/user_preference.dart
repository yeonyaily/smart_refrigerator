import 'dart:convert';

import 'package:smart_refrigerator/views/mypage/model/user.dart';
import 'package:smart_refrigerator/userInfomation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static SharedPreferences _preferences;

  static const _keyUser = 'user';

  static final myUser = User(
    imagePath: UserInformation.photoURL,
    name: UserInformation.name,
    email: UserInformation.email,
    about: 'Our smart refrigerator app will revolutionize the whole world. Perhaps, it will receive a large investment from Lim Yeon-soo, the No. 1 market capitalization company.',
    isDarkMode: false,
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyUser, json);
  }

  static User getUser(){
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }

}
