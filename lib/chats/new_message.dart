import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final controller = TextEditingController();
  var enteredMessage = '';

  void sendMessage() async{
    FocusScope.of(context).unfocus();

    final uid = FirebaseAuth.instance.currentUser!;
    final userData=await FirebaseFirestore.instance.collection('users').doc(uid.uid).get();
    FirebaseFirestore.instance.collection('chats').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': uid.uid,
      'username': userData['username'],
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                onSubmitted: (val){sendMessage();},
            controller: controller,
            decoration: const InputDecoration(labelText: 'Send a message'),
            onChanged: (value) {
              setState(() {
                enteredMessage = value;
              });
            },
          )),
          IconButton(
            onPressed: enteredMessage.trim().isEmpty ? null : sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
