import 'package:flutter/material.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> with AutomaticKeepAliveClientMixin<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Notifications Tab'),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
