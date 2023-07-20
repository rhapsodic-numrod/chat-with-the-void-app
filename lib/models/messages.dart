import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? username;
  final String? message;
  final Timestamp? created_at;

  Message({
    this.username,
    this.message,
    this.created_at,
  });

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      username: data?['username'],
      message: data?['message'],
      created_at: data?['created_at'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) "username": username,
      if (message != null) "message": message,
      if (created_at != null) "created_at": created_at,
    };
  }
}
