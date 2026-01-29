import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/home/blog_list.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  final int _blogsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Blogs'), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledHeading('Hi, Guest'),
                TextButton(onPressed: () {}, child: StyledHeading('Login')),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                itemCount: 10,
                controller: _controller,
                itemBuilder: (context, index) {
                  final start = index * _blogsPerPage;
                  final end = start + _blogsPerPage - 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 0,
                    ),
                    child: BlogList(start: start, end: end),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
