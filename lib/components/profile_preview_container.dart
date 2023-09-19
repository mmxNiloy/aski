import 'package:aski/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfilePreviewContainer extends StatelessWidget {
  final UserModel model;
  const ProfilePreviewContainer({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: CircleAvatar(),
            ),
            Text(model.getFullName())
          ],
        ),
      ),
    );
  }

}