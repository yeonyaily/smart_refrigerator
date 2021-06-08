import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier{
  final FirebaseAuth auth = FirebaseAuth.instance;
  User _user;

  FirebaseProvider() {
    logger.d("init FirebaseProvider");
    _prepareUser();
  }

  User getUser() {
    return _user;
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  _prepareUser() {
    setUser(auth.currentUser);
  }
}