import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/blog.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentForm extends StatefulWidget {
  const CommentForm({super.key});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _body = '';
  // String _imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Leave a comment',
            onSaved: (value) => _body = value!,
            maxLength: 100,
            lines: 3,
          ),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          StyledFilledButton(
            'Post Comment',
            onPressed: () {
              if (_formGlobalKey.currentState!.validate()) {
                _formGlobalKey.currentState!.save();

                context.read<CommentProvider>().createComment(
                  _body.trim(),
                  context.read<AuthProvider>().username!,
                  context.read<AuthProvider>().userId!,
                  context.read<Blog>().id,
                );

                _formGlobalKey.currentState!.reset();
              }
            },
          ),
        ],
      ),
    );
  }
}
