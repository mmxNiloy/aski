import 'package:aski/components/chat_ui.dart';
import 'package:aski/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DirectMessagePage extends StatefulWidget {
  final UserModel receiver;
  const DirectMessagePage({super.key, required this.receiver});

  @override
  State<StatefulWidget> createState() => DirectMessagePageState();
}

class DirectMessagePageState extends State<DirectMessagePage> {
  String message = '';
  late List<String> _participants;

  @override
  void initState() {
    super.initState();

    setState(() {
      _participants = [];
    });

    _participants.add(FirebaseAuth.instance.currentUser!.uid);
    _participants.add(widget.receiver.uid);
    _participants.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar containing profile name, profile pic, and other options.
      appBar: AppBar(
        // Back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: Row(
          children: [

            // Profile pic avatar container.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CircleAvatar(
                backgroundImage: _renderAvatar(),
              ),
            ),

            // Profile name
            Text(widget.receiver.getFullName())
          ],
        ),

        // TODO: Add more actions here if necessary.
      ),
      body: Center(
        child: ChatUI(
            heightFactor: 0.5,
            widthFactor: 0.8,
            maxChatBoxLines: 3,
            participants: _participants,
        ),
      ),
    );
  }

  ImageProvider? _renderAvatar() {
    if(widget.receiver.profilePicUri != null && widget.receiver.profilePicUri!.isNotEmpty) {
      return NetworkImage(widget.receiver.profilePicUri!);
    }

    return const AssetImage('images/profile_image.jpg');
  }
}