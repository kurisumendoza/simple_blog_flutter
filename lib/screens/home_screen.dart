import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/blog_preview.dart';

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
        child: const BlogPreview(),
      ),
    );
  }
}
