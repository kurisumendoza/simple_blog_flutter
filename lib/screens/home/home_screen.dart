import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/create/create_blog_screen.dart';
import 'package:simple_blog_flutter/screens/home/blog_list.dart';
import 'package:simple_blog_flutter/screens/home/page_indicator.dart';
import 'package:simple_blog_flutter/screens/home/user_header.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  final int _blogsPerPage = 5;
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    _loadBlogCount();
    super.initState();
  }

  Future<void> _loadBlogCount() async {
    await context.read<BlogProvider>().getBlogsCount();

    setState(() {
      _totalPages = (context.read<BlogProvider>().count / _blogsPerPage).ceil();
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
            UserHeader(),
            SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                itemCount: _totalPages,
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentPage = index + 1);
                },
                itemBuilder: (context, index) {
                  final start = index * _blogsPerPage;
                  final end = start + _blogsPerPage - 1;
                  return BlogList(start: start, end: end);
                },
              ),
            ),
            SizedBox(height: 20),
            PageIndicator(currentPage: _currentPage, lastPage: _totalPages),
            SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: context.watch<AuthProvider>().isLoggedIn
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateBlogScreen()),
                );
              },
              child: Icon(Icons.add, color: AppColors.accent, size: 40),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
