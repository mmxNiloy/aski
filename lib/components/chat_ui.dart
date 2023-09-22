import 'package:aski/components/typing_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'chat_bubble.dart';

class ChatUI extends StatefulWidget {
  final double heightFactor;
  final double widthFactor;
  final int maxChatBoxLines;
  final List<String> participants;

  const ChatUI({
    super.key,
    required this.heightFactor,
    required this.widthFactor,
    required this.maxChatBoxLines,
    required this.participants
  });

  @override
  State<ChatUI> createState() => _ChatUIState();
}

enum Role { sender, receiver, loading }

class _ChatUIState extends State<ChatUI> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey();
  final List<String> _messages = [];
  final List<Role> _roles = [];
  String message = '';
  final TextEditingController _chatboxController = TextEditingController();
  String _chatID = '';
  final String _senderUID = FirebaseAuth.instance.currentUser!.uid;
  late String _receiverUID;

  @override
  void initState() {
    super.initState();

    // Assuming two people are participating
    for(String uid in widget.participants) {
      if(uid != _senderUID) _receiverUID = uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Viewport for messages
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * widget.heightFactor,
            width: MediaQuery.of(context).size.width * widget.widthFactor,
            child: AnimatedList(
              reverse: true,
              key: _animListKey,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(Tween<Offset>(
                  begin: const Offset(0, 1), end: Offset.zero)),
                  child: _roles[index] == Role.loading
                      ? TypingIndicator(
                          showIndicator: true,
                          bubbleColor: Theme.of(context).highlightColor,
                      )
                      : ChatBubble(
                          content: _messages[index],
                          isIncoming: _roles[index] == Role.receiver
                      ),
                );
              },
            ),
          ),
        ),

        // Chat Textfield
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: sendMessage,
            ),
          ),
          minLines: 1,
          maxLines: widget.maxChatBoxLines,
          controller: _chatboxController,
        )
      ],
    );
  }

  Future<void> findOrGenerateChatID() async {
    final db = FirebaseFirestore.instance;
    final collRef = db.collection('connections');
    final query = collRef
        .where('member1', isEqualTo: widget.participants.first)
        .where('member2', isEqualTo: widget.participants.last);

    final response = await query.get();
    if(response.docs.isNotEmpty && response.docs.first.exists) {
      setState(() {
        _chatID = response.docs.first.id;
      });
    } else {
      // Member connection data
      Map<String, String> members = {
        'member1': widget.participants.first,
        'member2': widget.participants.last,
      };

      // Create a new chat id in firebase rtdb
      final rtdb = FirebaseDatabase.instance;
      final membersRef = rtdb.ref('/members');
      final itemRef = membersRef.push();


      setState(() {
        _chatID = itemRef.key!;
      });

      // Update the RTDB
      // TODO: Handle errors
      await itemRef.set(members);

      // Update Firestore
      final docRef = collRef.doc(_chatID);

      // TODO: Handle errors
      await docRef.set(members);
    }
  }

  void sendMessage() async {
    // Get chat box text
    message = _chatboxController.text;

    // Append the message at the front of the list of messages
    _messages.insert(0, message);
    _roles.insert(0, Role.sender);
    _animListKey.currentState!.insertItem(_messages.length - 1,
        duration: const Duration(milliseconds: 20));

    // Clear the chat box
    _chatboxController.clear();

    // Actual message sending process
    if(_chatID.isEmpty) await findOrGenerateChatID();

    // Notify the RTDB
    FirebaseDatabase database = FirebaseDatabase.instance;
    final mChatRef = database.ref('messages/$_chatID');

    int ts = Timestamp.now().millisecondsSinceEpoch;
    final msgRef = mChatRef.push();
    await msgRef.set({
      'sender': _senderUID,
      'receiver': _receiverUID,
      'content': message,
      'timestamp': ts
    });

    // Update the metadata in the database
    final chatRef = database.ref('/chats/$_chatID');
    await chatRef.set({
      'last_message': message,
      'sender': _receiverUID,
      'timestamp': ts,
    });
  }
}
