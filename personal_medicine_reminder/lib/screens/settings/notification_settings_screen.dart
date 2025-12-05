import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notification settings screen'),
      ),
      body: const Center(
        child: Text('notification settings screen'),
      ),
    );
  }
}
