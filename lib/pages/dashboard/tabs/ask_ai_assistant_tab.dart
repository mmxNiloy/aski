import 'package:flutter/material.dart';

class AIAssistantTab extends StatefulWidget {
  const AIAssistantTab({super.key});

  @override
  State<StatefulWidget> createState() => AIAssistantTabState();
}

class AIAssistantTabState extends State<AIAssistantTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<AnimatedListState> _animListKey = GlobalKey();

  late String message;
  final List<String> _messages = [];

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
                        key: _animListKey,
                        itemBuilder: (context, index, animation) {
                          return SlideTransition(
                              position: animation.drive(
                                  Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero
                                  )
                              ),
                            child: ChatBubble(content: _messages[index],),
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

  void sendMessage() {
    // TODO : Make a fetch request
    _messages.add(message);
    _animListKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 20));
  }

}

class ChatBubble extends StatelessWidget {
  final String content;

  const ChatBubble({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(content),
    );
  }
}