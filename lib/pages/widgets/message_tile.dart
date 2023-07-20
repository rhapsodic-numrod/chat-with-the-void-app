import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase_chat_app2/utils/utils.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.message,
    required this.username,
    required this.created_at,
  });
  final String? message;
  final String? username;
  final Timestamp? created_at;

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
              formatDate(created_at!.toDate(), [HH, ':', nn," | ",dd," ",M," ",yyyy,]),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12
              ),
            ),
          )
        ],
      ),
    );
  }
}
