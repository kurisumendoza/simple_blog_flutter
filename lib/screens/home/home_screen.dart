import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/create/create_blog_screen.dart';
import 'package:simple_blog_flutter/screens/home/blog_list.dart';
import 'package:simple_blog_flutter/screens/home/page_indicator.dart';
import 'package:simple_blog_flutter/screens/home/user_header.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
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
  int _totalPages = 1;
  int _currentPage = 1;
  int _start = 0;
  int _end = 4;

  @override
  void initState() {
    _loadBlogs();
    super.initState();
  }

  Future<void> _loadBlogs() async {
    await context.read<BlogProvider>().getBlogs(_start, _end);
  }

  @override
  Widget build(BuildContext context) {
    final int count = context.watch<BlogProvider>().count;
    _totalPages = (count / _blogsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(title: StyledHeading('Blogs')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UserHeader(),
            SizedBox(height: 10),
            (_currentPage == 1 && context.watch<BlogProvider>().blogs.isEmpty)
                ? Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Expanded(
                    child: PageView.builder(
                      itemCount: _totalPages,
                      controller: _controller,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index + 1;
                          _start = index * _blogsPerPage;
                          _end = _start + _blogsPerPage - 1;
                        });

                        context.read<BlogProvider>().getBlogs(_start, _end);
                      },
                      itemBuilder: (context, index) {
                        return BlogList();
                      },
                    ),
                  ),
            SizedBox(height: 20),
            PageIndicator(
              currentPage: _currentPage,
              lastPage: _totalPages,
              onPrevious: () {
                if (_currentPage > 1) {
                  _controller.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                }
              },
              onNext: () {
                if (_currentPage < _totalPages) {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                }
              },
            ),
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
    );
  }
}
