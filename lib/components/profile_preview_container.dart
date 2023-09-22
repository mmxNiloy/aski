import 'package:aski/models/user_model.dart';
import 'package:aski/pages/direct_message_page/direct_message_page.dart';
import 'package:flutter/material.dart';

class ProfilePreviewContainer extends StatelessWidget {
  final UserModel model;
  const ProfilePreviewContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Ripple effect and makes the card itself clickable
      child: InkWell(
        onTap: () {
          // Go to DMs
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DirectMessagePage(receiver: model)
              )
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              // Profile pic avatar container.
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: CircleAvatar(),
              ),

              // Profile name
              Text(model.getFullName())
            ],
          ),
        ),
      ),
    );
  }
}