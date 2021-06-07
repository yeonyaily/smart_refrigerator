import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_refrigerator/start.dart';
import 'package:flutter/services.dart';
import 'package:smart_refrigerator/views/mypage/utils/user_preference.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  await dotenv.load(fileName: '.env');
  runApp(Start());
}
