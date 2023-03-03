import 'package:chat_app/chats/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
            reverse: true,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (ctx, index) {
              return MessageBubble(
                snapshot.data?.docs[index]['text'],
                snapshot.data?.docs[index]['userId'] ==
                    FirebaseAuth.instance.currentUser?.uid,
                snapshot.data?.docs[index]['username'],
                k: ValueKey(snapshot.data?.docs[index].id),

              );
            });
      },
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
