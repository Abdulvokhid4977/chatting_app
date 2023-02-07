import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => Container(
          padding: const EdgeInsets.all(10),
          child: const Text('this is a dummy message'),
        ),
        itemCount: 10,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/wYwcu8g3uP1HMQIg7jXL/messages')
              .snapshots()
              .listen((event) {
           for (var element in event.docs) {print(element['text']);}
          });
        },
      ),
    );
  }
}
