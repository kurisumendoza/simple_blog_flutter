import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentEditForm extends StatefulWidget {
  const CommentEditForm({
    super.key,
    required this.id,
    required this.body,
    required this.onEditEnd,
  });

  final int id;
  final String body;
  final void Function() onEditEnd;

  @override
  State<CommentEditForm> createState() => _CommentEditFormState();
}

class _CommentEditFormState extends State<CommentEditForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _newBody = '';
  // String _newImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          SizedBox(height: 6),
          StyledFormField(
            label: 'Update',
            isUpdate: true,
            initialValue: widget.body,
            onSaved: (value) => _newBody = value!,
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
          Row(
            children: [
              StyledFilledButton(
                'Update',
                onPressed: () {
                  if (_formGlobalKey.currentState!.validate()) {
                    _formGlobalKey.currentState!.save();

                    context.read<CommentProvider>().updateComment(
                      widget.id,
                      _newBody,
                    );

                    widget.onEditEnd();
                  }
                },
              ),
              SizedBox(width: 10),
              StyledFilledButton(
                'Cancel',
                onPressed: widget.onEditEnd,
                color: Colors.red[300],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
