import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/shared/blog_form.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class UpdateBlogScreen extends StatelessWidget {
  const UpdateBlogScreen(this.blog, {super.key});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Update Blog'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: AppColors.secondary.withValues(alpha: 0.4),
          child: Column(
            children: [
              Center(child: StyledHeading('Update blog post', fontSize: 18)),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlogForm(
                  buttonText: 'Update Blog',
                  isUpdate: true,
                  id: blog.id,
                  oldTitle: blog.title,
                  oldBody: blog.body,
                  oldImagePath: blog.imagePath,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
