import 'package:aski/components/typing_indicator.dart';
import 'package:aski/mediators/message_mediator.dart';
import 'package:aski/models/rtdb_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  String message = '';
  final TextEditingController _chatboxController = TextEditingController();
  String _chatID = '';
  late Future<String> _futureChatID;
  late Future<List<RTDBMessageModel>> _futureLatestMessagesList;
  List<RTDBMessageModel> _latestMessages = [];
  final String _senderUID = FirebaseAuth.instance.currentUser!.uid;
  late String _receiverUID;
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();

    // Assuming two people are participating
    for(String uid in widget.participants) {
      if(uid != _senderUID) _receiverUID = uid;
    }

    initChat();
  }

  Future<void> initChat() async {
    // Chat ID debacle
    _futureChatID = MessageMediator
        .findOrGenerateChatID(
        widget.participants.first,
        widget.participants.last
    );
    _futureChatID.then((cID) {
      setState(() {
        _chatID = cID;
      });

      // TODO: Get previous chat
      _futureLatestMessagesList = MessageMediator.getLatestMessages(_chatID, 10);
      _futureLatestMessagesList.then((latestMessages) {
        setState(() {
          _isLoadingMessages = false;
        });

        setState(() {
          _latestMessages = latestMessages;
        });

        MessageMediator.listenToChatChanges(_chatID, (newMessage) {
          debugPrint('New message found');
          debugPrint(newMessage.toString());
          debugPrint('End new message');

          if(_latestMessages.isNotEmpty && _latestMessages.first.equals(newMessage)) return;
          _latestMessages.insert(0, newMessage);
          _animListKey.currentState!.insertItem(_latestMessages.length - 1,
              duration: const Duration(milliseconds: 20));
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _futureChatID,
      builder: buildChatInterface,
    );
  }

  void sendMessage() async {
    // Get chat box text
    message = _chatboxController.text.trim();
    // Clear the chat box
    _chatboxController.clear();

    if(message.isEmpty) return;

    RTDBMessageModel model = RTDBMessageModel(
        sender: _senderUID, receiver: _receiverUID,
        content: message, timestamp: Timestamp.now().millisecondsSinceEpoch
    );

    // Append the message at the front of the list of messages
    _latestMessages.insert(0, model);
    _animListKey.currentState!.insertItem(_latestMessages.length - 1,
        duration: const Duration(milliseconds: 20));


    MessageMediator.storeMessageToRTDB(_chatID, model);
  }

  Widget buildChatInterface(BuildContext context, AsyncSnapshot<String> snapshot) {
    if(snapshot.hasData && snapshot.data!.isNotEmpty) {
      return Column(
        children: [
          // Viewport for messages
          Expanded(
            child: FutureBuilder<List<RTDBMessageModel>>(
              future: _futureLatestMessagesList,
              builder: buildChatViewport,
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
            readOnly: _isLoadingMessages,
            minLines: 1,
            maxLines: 3,
            controller: _chatboxController,
          )
        ],
      );
    } else if(snapshot.hasError) {
      return const Center(
        child: Text('Error loading conversation'),
      );
    }

    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      ),
    );
  }

  Widget buildChatViewport(BuildContext context, AsyncSnapshot<List<RTDBMessageModel>> snapshot) {
    if(snapshot.hasData) {
      return AnimatedList(
        shrinkWrap: true,
        initialItemCount: _latestMessages.length,
        reverse: true,
        key: _animListKey,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: const Offset(0, 1), end: Offset.zero)),
            child: _isLoadingMessages // TODO: show typing indicator when the other person is typing
                ? TypingIndicator(
              showIndicator: true,
              bubbleColor: Theme.of(context).highlightColor,
            )
                : ChatBubble(
                content: _latestMessages[index].content,
                isIncoming: _latestMessages[index].sender != _senderUID
            ),
          );
        },
      );
    } else if(snapshot.hasError) {
      return const Center(
        child: Text('Error loading conversation'),
      );
    }

    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      ),
    );
  }
}
