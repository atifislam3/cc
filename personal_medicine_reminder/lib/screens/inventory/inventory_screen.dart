import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inventory screen'),
      ),
      body: const Center(
        child: Text('inventory screen'),
      ),
    );
  }
}
