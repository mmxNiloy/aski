import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  bool? canGoBack = false;
  MyAppBar({super.key, this.canGoBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('ASKi'),
      actions: [
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder()
            ),
            child: const CircleAvatar(),
          ),
        ),
      ],
    );
  }
}
