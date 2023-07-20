import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_chat_app2/pages/widgets/message_tile.dart';
import 'package:test_firebase_chat_app2/utils/utils.dart';

class MessagesList extends StatelessWidget {
  MessagesList({
    super.key,
  });

  final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy("created_at")
      .limit(20)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close the keyboard if anything else is tapped
      onTap: () {
        closeKeyBoard(context);
      },
      child: StreamBuilder<QuerySnapshot>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map(
                  (document) {
                    Map<String, dynamic> message =
                        document.data()! as Map<String, dynamic>;

                    return MessageTile(
                      message: message["message"],
                      username: message["author_username"],
                      created_at: message["created_at"],
                    );
                  },
                )
                .toList()
          );
        },
      ),
    );
  }
}
