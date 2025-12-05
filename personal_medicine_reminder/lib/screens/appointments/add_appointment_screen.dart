import 'package:flutter/material.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add appointment screen'),
      ),
      body: const Center(
        child: Text('add appointment screen'),
      ),
    );
  }
}
