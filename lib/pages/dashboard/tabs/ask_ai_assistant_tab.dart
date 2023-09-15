import 'dart:convert';

import 'package:aski/models/ai_reply_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AIAssistantTab extends StatefulWidget {
  const AIAssistantTab({super.key});

  @override
  State<StatefulWidget> createState() => AIAssistantTabState();
}

enum Role {
  user,
  ai,
  loading
}

class AIAssistantTabState extends State<AIAssistantTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey();

  late String message;
  bool isAIReply = false;
  final List<String> _messages = [];
  final List<Role> _roles = []; // true -> ai, false -> user

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        )
      ),

      body: Stack(
        children: [
          FloatingActionButton.small(
              onPressed: openDrawer,
              child: const Icon(Icons.menu),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2.0,
              child: Column(
                children: [
                  // Viewport
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 2.0 / 3.0,
                      child: AnimatedList(
                        reverse: true,
                        key: _animListKey,
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                              position: animation.drive(
                                  Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero
                                  )
                              ),
                            child:
                              _roles[index] == Role.loading ?
                              const ChatBubbleShimmer() :
                              ChatBubble(content: _messages[index], isIncoming: _roles[index] == Role.ai),
                          );
                        },
                      ),
                    ),
                  ),

                  // Textbox
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: sendMessage,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 8,
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  void openDrawer() {
    debugPrint("Attempting to open drawer");
    _scaffoldKey.currentState!.openDrawer();
  }

  void sendMessage() async {
    _roles.insert(0, Role.user);
    _messages.insert(0, message);
    _animListKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 20));

    getReply();
  }

  Future<void> getReply() async {
    // Encode message to uri
    String msg = Uri.encodeComponent(_messages.first);

    // Release the shimmer
    _roles.insert(0, Role.loading);
    _messages.insert(0, '');
    _animListKey.currentState?.insertItem(_roles.length - 1, duration: const Duration(milliseconds: 20));

    // Fetch a reply from the API

    // request uri
    final rUri = Uri.http(
        'blacklabelengineering.pythonanywhere.com',
        '/',
        {
          'message': msg
        }
    );

    // response
    String reply = '';

    final response = await http.get(rUri);

    // Successful fetch
    if(response.statusCode == 200) {
      final hash = json.decode(response.body) as Map<String, dynamic>;
      final rModel = AIReplyModel.fromJSON(hash);

      // Defaulting to the first choice
      reply = rModel.choices.first;
    } else {
      reply = 'Error parsing message';
    }

    //Retract the shimmer
    _animListKey.currentState?.removeItem(_roles.length - 1, (context, animation) => const ChatBubbleShimmer(), duration: const Duration(milliseconds: 0));
    _roles.removeAt(0);
    _messages.removeAt(0);

    _roles.insert(0, Role.ai);
    _messages.insert(0, reply);
    _animListKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 20));
  }

}

class ChatBubble extends StatelessWidget {
  final String content;
  final bool isIncoming;

  const ChatBubble({super.key, required this.content, required this.isIncoming});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: isIncoming ? WrapAlignment.start : WrapAlignment.end,
      children: [
          Card(
            color: !isIncoming ? Colors.blueAccent : Theme.of(context).cardColor,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  content,
                  textAlign: isIncoming ? TextAlign.left : TextAlign.right,
                )
            ),
        ),
      ]
    );
  }
}

class ChatBubbleShimmer extends StatelessWidget {
  const ChatBubbleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: const ChatBubble(content: 'Lorem Ipsum Dolor Amet Sit\nLorem Ipsum Dolor Amet Sit\nLorem Ipsum Dolor Amet Sit', isIncoming: true)
    );
  }

}