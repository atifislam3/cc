import 'package:flutter/material.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appointment detail screen'),
      ),
      body: const Center(
        child: Text('appointment detail screen'),
      ),
    );
  }
}
