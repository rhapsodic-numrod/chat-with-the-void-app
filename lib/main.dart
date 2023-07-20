import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase_chat_app2/router/config.dart';
import 'app_state.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => ApplicationState(),
  //     builder: (context, child) => const ChatApp(),
  //   ),
  // );
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "CWTV",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Colors.grey.shade100,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.black87),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          )),
      routerConfig: routes,
    );
  }
}
