import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class ChatListPage extends StatelessWidget {
  final String sellerUid;

  const ChatListPage({Key? key, required this.sellerUid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список чатов'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('receiverId', isEqualTo: sellerUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final buyers = snapshot.data!.docs.map((doc) => doc['senderId']).toSet().toList();

          return ListView.builder(
            itemCount: buyers.length,
            itemBuilder: (context, index) {
              final buyerUid = buyers[index];

              return ListTile(
                title: Text('Пользователь: $buyerUid'),
                trailing: const Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(sellerUid: buyerUid),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}