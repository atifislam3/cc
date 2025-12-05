import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appointments screen'),
      ),
      body: const Center(
        child: Text('appointments screen'),
      ),
    );
  }
}
