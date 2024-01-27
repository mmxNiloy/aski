import 'dart:convert';

import 'package:aski/components/typing_indicator.dart';
import 'package:aski/constants/server_response_constants.dart';
import 'package:aski/constants/utils.dart';
import 'package:aski/models/ai_reply_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../components/chat_bubble.dart';

class AskAIAssistantTab extends StatefulWidget {
  const AskAIAssistantTab({super.key});

  @override
  State<StatefulWidget> createState() => _AskAIAssistantTabState();
}

class _AskAIAssistantTabState extends State<AskAIAssistantTab> {
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey();
  final _tecMsg = TextEditingController();

  final List<String> _messages = [];
  final List<ChatRole> _roles = []; // true -> ai, false -> user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASKi > AI Assistant'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _openHistoryDrawer(context),
              );
            }
          )
        ],
      ),
      endDrawer: const Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text('History'),
            ),
            Expanded(
                child: Center(
                  child: Text('TODO: Render asked questions history'),
                )
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Main viewport
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedList(
                  shrinkWrap: true,
                  reverse: true,
                  key: _animListKey,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: animation.drive(Tween<Offset>(
                          begin: const Offset(0, 1), end: Offset.zero)),
                      child: _roles[index] == ChatRole.loading
                          ? TypingIndicator(showIndicator: true, bubbleColor: Theme.of(context).highlightColor,)
                          : ChatBubble(
                          content: _messages[index],
                          isIncoming: _roles[index] == ChatRole.ai),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 7,),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
            // Chat text box
            TextField(
              controller: _tecMsg,
              decoration: InputDecoration(
                suffix: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    String msg = _tecMsg.text.trim();
    if(msg.isEmpty) return;

    _tecMsg.clear();

    _roles.insert(0, ChatRole.user);
    _messages.insert(0, msg);
    _animListKey.currentState?.insertItem(_messages.length - 1,
        duration: const Duration(milliseconds: 20));

    _getReply();
  }

  Future<void> _getReply() async {
    // Encode message to uri
    String msg = Uri.encodeComponent(_messages.first);

    // Release the typing indicator
    _roles.insert(0, ChatRole.loading);
    _messages.insert(0, '');
    _animListKey.currentState?.insertItem(_roles.length - 1,
        duration: const Duration(milliseconds: 20));

    // Fetch a reply from the API

    // request uri
    final rUri = Uri.http(
        APIInfo.host, APIInfo.messageAIRoute, {APIInfo.messageParamKey: msg});

    // response
    String reply = '';

    final response = await http.get(rUri);

    // Successful fetch
    if (response.statusCode == 200) {
      // debugPrint('AskAIAssistantTab > _getReply() > Success: ${response.body}');
      final hash = json.decode(response.body) as Map<String, dynamic>;
      final rModel = AIReplyModel.fromJSON(hash);

      // Defaulting to the first choice
      reply = rModel.getFirstReply();
    } else {
      reply = 'Error parsing message';
      // debugPrint('AskAIAssistantTab > _getReply() > Error: ${response.body}');
    }

    // Retract the typing indicator
    _animListKey.currentState?.removeItem(
        _roles.length - 1, (context, animation) => TypingIndicator(showIndicator: true, bubbleColor: Theme.of(context).highlightColor,),
        duration: const Duration(milliseconds: 2));
    _roles.removeAt(0);
    _messages.removeAt(0);

    // Push the ai reply
    _roles.insert(0, ChatRole.ai);
    _messages.insert(0, reply);
    _animListKey.currentState?.insertItem(_messages.length - 1,
        duration: const Duration(milliseconds: 20));
  }

  void _openHistoryDrawer(BuildContext context) {
    Scaffold.of(context)
        .openEndDrawer();
  }
}
