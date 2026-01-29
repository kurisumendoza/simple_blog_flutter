import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/home/blog_list.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Blogs'), centerTitle: true),
      body: Container(padding: const EdgeInsets.all(16), child: BlogList()),
    );
  }
}
