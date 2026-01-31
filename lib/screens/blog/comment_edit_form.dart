import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class CommentEditForm extends StatelessWidget {
  CommentEditForm({super.key, required this.onEditEnd});

  final _formGlobalKey = GlobalKey<FormState>();
  final void Function() onEditEnd;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          SizedBox(height: 6),
          StyledFormField(
            label: 'Update',
            onSaved: (value) {},
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
              StyledFilledButton('Update', onPressed: () {}),
              SizedBox(width: 10),
              StyledFilledButton(
                'Cancel',
                onPressed: onEditEnd,
                color: Colors.red[300],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
