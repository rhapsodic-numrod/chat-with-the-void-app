import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  const MessageField({
    super.key,
  });

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final newMessageController = TextEditingController();

  @override
  void dispose() {
    newMessageController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection("messages");

  Future sendMessage() async {
    var messageLength = 140;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    String? username = userDoc["username"];

    if (newMessageController.text.isNotEmpty) {
      if (newMessageController.text.length < messageLength) {
        // add message
        try {
          return messagesRef.doc().set({
            "author": user!.uid,
            "author_username": username,
            "message": newMessageController.text.trim(),
            "created_at": Timestamp.now()
          }).then(
            (value) => newMessageController.clear(),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$e"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Must be $messageLength charaters or less"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Message cannot be empty")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(1, 1),
      children: [
        TextField(
          autofocus: false,
          cursorWidth: 10,
          cursorColor: Colors.black38,
          maxLines: 4,
          controller: newMessageController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: "New message to the void",
            border: InputBorder.none,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: ElevatedButton(
            onPressed: sendMessage,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Text("Send"),
            ),
          ),
        )
      ],
    );
  }
}
