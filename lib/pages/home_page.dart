import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase_chat_app2/app_state.dart';
import 'package:test_firebase_chat_app2/pages/widgets/message_field.dart';
import 'package:test_firebase_chat_app2/pages/widgets/messages_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.black87,
        title: const Text("CWTV"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: MessagesList()),
          const MessageField()
        ],
      ),
    );
  }

  Future<void> signOut() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.clear();
    return FirebaseAuth.instance.signOut();
  }
}
