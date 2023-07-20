import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase_chat_app2/firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _isLoggedIn = false;
  bool get loggedIn => _isLoggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
      notifyListeners();
    });
  }
}

SharedPreferences? sharedPreferences;
