import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'chat_bubble.dart';

class ChatBubbleShimmer extends StatelessWidget {
  const ChatBubbleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: const ChatBubble(
            content:
            'Lorem Ipsum Dolor Amet Sit\nLorem Ipsum Dolor Amet Sit\nLorem Ipsum Dolor Amet Sit',
            isIncoming: true));
  }
}