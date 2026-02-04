import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(this.profile, {super.key});

  final Profile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _location = '';
  String _bio = '';
  File? _image;

  String _generateImagePath() {
    String ext = _image!.path.split('.').last;
    String pathName = Random().nextInt(1000000).toRadixString(36);

    return 'public/$pathName.$ext';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedImage != null) {
      String ext = pickedImage.path.split('.').last.toLowerCase();

      if (ext != 'jpg' && ext != 'jpeg' && ext != 'png') {
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackBar(
            isError: true,
            message: 'Please pick a PNG or JPG image!',
          ),
        );
        return;
      }

      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

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
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(
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
                        StyledHeading(widget.profile.user),
                        SizedBox(height: 8),
                        StyledText('join date:'),
                        StyledHeading(widget.profile.formattedDate),
                        SizedBox(height: 8),
                        _image != null
                            ? StyledFilledButton(
                                'Remove photo',
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                color: Colors.red[400],
                              )
                            : StyledFilledButton(
                                'Upload a photo',
                                onPressed: () {
                                  pickImage();
                                },
                              ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'General Location',
                  initialValue: widget.profile.location,
                  onSaved: (value) => _location = value!,
                  maxLength: 30,
                  minLength: 5,
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'Update your bio',
                  initialValue: widget.profile.bio,
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
