import 'package:flutter/material.dart';
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

  String _comment = '';
  String _image = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Leave a comment',
            onSaved: (newValue) {},
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

          StyledFilledButton('Post Comment', onPressed: () {}),
        ],
      ),
    );
  }
}
