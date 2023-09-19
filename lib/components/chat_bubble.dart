import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isIncoming;

  const ChatBubble(
      {super.key, required this.content, required this.isIncoming});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        direction: Axis.horizontal,
        alignment: isIncoming ? WrapAlignment.start : WrapAlignment.end,
        children: [
          Card(
            color:
            !isIncoming ? Colors.blueAccent : Theme.of(context).cardColor,
            child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  content,
                  textAlign: isIncoming ? TextAlign.left : TextAlign.right,
                )),
          ),
        ]);
  }
}