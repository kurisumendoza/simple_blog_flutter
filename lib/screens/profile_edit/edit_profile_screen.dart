import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _location = '';
  String _bio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Edit Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          color: AppColors.secondary.withValues(alpha: 0.4),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: StyledTitle('Edit your profile details')),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      color: AppColors.primary,
                      child: Icon(Icons.person, size: 150),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText('username:'),
                        StyledHeading('Maki'),
                        SizedBox(height: 8),
                        StyledText('join date:'),
                        StyledHeading('Yesterday'),
                        SizedBox(height: 8),
                        StyledFilledButton('Upload a photo', onPressed: () {}),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'General Location',
                  onSaved: (value) => _location = value!,
                  maxLength: 30,
                  minLength: 5,
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'Update your bio',
                  onSaved: (value) => _bio = value!,
                  maxLength: 100,
                  minLength: 5,
                  lines: 5,
                ),
                SizedBox(height: 20),
                StyledFilledButton(
                  'Save',
                  onPressed: () {},
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
