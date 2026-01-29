import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/home/blog_list.dart';
import 'package:simple_blog_flutter/services/blog_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  final int _blogsPerPage = 5;
  late int _totalPages;

  @override
  void initState() {
    _loadBlogCount();
    super.initState();
  }

  Future<void> _loadBlogCount() async {
    int count = await BlogService.getBlogsCount();
    setState(() {
      _totalPages = (count / _blogsPerPage).ceil();
    });
  }

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
                itemCount: _totalPages,
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
