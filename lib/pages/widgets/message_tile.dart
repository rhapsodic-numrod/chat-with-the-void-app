import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_chat_app2/utils/utils.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.username,
    required this.createdAt,
  });
  final String? message;
  final String? username;
  final Timestamp? createdAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.black87,
      ),
      child: ListBody(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://xsgames.co/randomusers/avatar.php?g=pixel"),
              ),
              addWidth(8),
              Text(
                "@$username",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          addHeight(8),
          Text(
            message!,
            style: const TextStyle(
              color: Colors.white,
            ),
            softWrap: true,
          ),
          addHeight(8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              getFomattedDate(createdAt),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  String getFomattedDate(Timestamp? date) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(date!.toDate());
    if (difference.inMinutes == 0) {
      return "just now";
    } else if (difference.inHours < 24) {
      if (difference.inHours == 0) {
        return "${difference.inMinutes} minutes ago";
      }
      return "${difference.inHours} hours ago";
    } else {
      return formatDate(
          date.toDate(), [HH, ':', nn, " | ", dd, " ", M, " ", yyyy]);
    }
  }
}
