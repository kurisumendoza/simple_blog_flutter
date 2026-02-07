import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/blog_form.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CreateBlogScreen extends StatelessWidget {
  const CreateBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledHeading('Create Blog')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: AppColors.secondary.withValues(alpha: 0.4),
          child: Column(
            children: [
              Center(
                child: StyledHeading('Create a new blog post', fontSize: 18),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlogForm(buttonText: 'Create Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
