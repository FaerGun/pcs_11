import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
    };
  }
}