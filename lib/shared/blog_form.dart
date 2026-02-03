import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/blog/blog_screen.dart';
import 'package:simple_blog_flutter/screens/home/home_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class BlogForm extends StatefulWidget {
  const BlogForm({
    super.key,
    required this.buttonText,
    this.isUpdate = false,
    this.id,
    this.oldTitle,
    this.oldBody,
    this.oldImagePath,
  });

  final String buttonText;
  final bool isUpdate;
  final int? id;
  final String? oldTitle;
  final String? oldBody;
  final String? oldImagePath;

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _title = '';
  String _body = '';
  // String _imagePath = '';

  String _generateSlug() {
    int end = min(_title.length, 30);
    String suffix = Random().nextInt(1000000).toRadixString(36);

    String slug = _title
        .substring(0, end)
        .trim()
        .toLowerCase()
        .split(' ')
        .join('-');

    return '$slug + $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Title',
            initialValue: widget.oldTitle,
            onSaved: (value) => _title = value!,
            maxLength: 60,
            minLength: 5,
            lines: 2,
          ),
          SizedBox(height: 15),
          StyledFormField(
            label: 'Body',
            initialValue: widget.oldBody,
            onSaved: (value) => _body = value!,
            maxLength: 1000,
            minLength: 50,
            lines: 16,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              StyledText('Add an image'),
              SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: StyledText('Choose File'),
              ),
            ],
          ),
          SizedBox(height: 30),
          Center(
            child: StyledFilledButton(
              widget.buttonText,
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                  if (!widget.isUpdate) {
                    context.read<BlogProvider>().createBlog(
                      _title.trim(),
                      _generateSlug(),
                      _body.trim(),
                      context.read<AuthProvider>().username!,
                      context.read<AuthProvider>().userId!,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      styledSnackBar(message: 'Blog posted successfully!'),
                    );
                  }

                  if (widget.isUpdate) {
                    context.read<BlogProvider>().updateBlog(
                      widget.id!,
                      _title.trim(),
                      _body.trim(),
                    );

                    // Navigator.pop(context);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogScreen(id: widget.id),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      styledSnackBar(message: 'Blog updated successfully!'),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
