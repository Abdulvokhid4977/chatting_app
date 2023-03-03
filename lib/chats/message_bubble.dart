import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key k;
  final String username;
  final String imageUrl;
  const MessageBubble(this.message, this.isMe, this.username, this.imageUrl,
      {super.key, required this.k});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(

      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if(!isMe)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(12),
              topLeft: const Radius.circular(12),
              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
              bottomRight: !isMe ? const Radius.circular(12) : Radius.zero,
            ),
          ),
          width: width * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [

              if (!isMe)
                Text(
                  username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              Text(
                message,
                style: TextStyle(color: isMe ? Colors.black : Colors.white),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        if(isMe)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
          ),
      ],
    );
  }
}
