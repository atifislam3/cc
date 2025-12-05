import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about screen'),
      ),
      body: const Center(
        child: Text('about screen'),
      ),
    );
  }
}
