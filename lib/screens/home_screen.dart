import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Text('Home Screen'),
      ),
    );
  }
}
