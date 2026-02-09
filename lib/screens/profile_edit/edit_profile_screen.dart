import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/services/comment_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';
import 'package:simple_blog_flutter/utils/generate_image_path.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(this.profile, {super.key});

  final Profile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String? _username;
  String? _location;
  String? _bio;
  String? _imagePath;
  Uint8List? _image;
  String? _ext;
  bool _isSubmitting = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _ext = pickedImage.name.split('.').last.toLowerCase();

      XFile? imageFile = XFile(pickedImage.path);
      _image = await imageFile.readAsBytes();

      if (!mounted) return;

      if (_ext != 'jpg' && _ext != 'jpeg' && _ext != 'png') {
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackBar(
            isError: true,
            message: 'Please pick a PNG or JPG image!',
          ),
        );
        return;
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    if (widget.profile.imagePath != null) {
      _imagePath = widget.profile.imagePath;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledHeading('Edit Profile')),
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
                    _image == null && _imagePath == null
                        ? Container(
                            width: 150,
                            height: 150,
                            color: AppColors.primary,
                            child: Icon(Icons.person, size: 150),
                          )
                        : _imagePath == null
                        ? Image.memory(
                            _image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            ProfileStorageService.getImageUrl(_imagePath!),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
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
                        _image == null && _imagePath == null
                            ? StyledFilledButton(
                                'Upload a photo',
                                onPressed: () {
                                  pickImage();
                                },
                              )
                            : StyledFilledButton(
                                'Remove photo',
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                    _imagePath = null;
                                  });
                                },
                                color: Colors.red[400],
                              ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'Username',
                  initialValue: widget.profile.user,
                  onSaved: (value) =>
                      _username = (value != null && value.trim().isNotEmpty)
                      ? value.trim()
                      : widget.profile.user,
                  maxLength: 15,
                  minLength: 3,
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'General Location',
                  initialValue: widget.profile.location,
                  isOptional: true,
                  onSaved: (value) =>
                      _location = (value != null && value.trim().isNotEmpty)
                      ? value.trim()
                      : null,
                  maxLength: 15,
                  minLength: 0,
                ),
                SizedBox(height: 20),
                StyledFormField(
                  label: 'Update your bio',
                  initialValue: widget.profile.bio,
                  isOptional: true,
                  onSaved: (value) =>
                      _bio = (value != null && value.trim().isNotEmpty)
                      ? value.trim()
                      : null,
                  maxLength: 100,
                  minLength: 0,
                  lines: 5,
                ),
                SizedBox(height: 20),
                StyledFilledButton(
                  _isSubmitting ? 'Saving...' : 'Save',
                  onPressed: _isSubmitting
                      ? () {
                          if (_isSubmitting) return;
                        }
                      : () async {
                          if (_formGlobalKey.currentState!.validate()) {
                            _formGlobalKey.currentState!.save();

                            setState(() {
                              _isSubmitting = true;
                            });

                            final authProvider = context.read<AuthProvider>();
                            final profileProvider = context
                                .read<ProfileProvider>();
                            final blogProvider = context.read<BlogProvider>();
                            final commentProvider = context
                                .read<CommentProvider>();
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);

                            if (_username != widget.profile.user &&
                                await profileProvider.userExists(_username!)) {
                              messenger.showSnackBar(
                                styledSnackBar(
                                  message: 'Username already exists!',
                                  isError: true,
                                ),
                              );

                              setState(() {
                                _isSubmitting = false;
                              });

                              return;
                            }

                            String? imagePath = widget.profile.imagePath;

                            if (_image != null) {
                              imagePath = generateImagePath(_ext!);
                              await ProfileStorageService.addImage(
                                imagePath,
                                _image!,
                              );

                              if (widget.profile.imagePath != null) {
                                await ProfileStorageService.deleteImage(
                                  widget.profile.imagePath!,
                                );
                              }
                            }

                            if (_image == null &&
                                _imagePath == null &&
                                widget.profile.imagePath != null) {
                              imagePath = null;
                              await ProfileStorageService.deleteImage(
                                widget.profile.imagePath!,
                              );
                            }

                            String username = _username != null
                                ? _username!
                                : widget.profile.user;

                            await authProvider.updateUser(username);
                            await profileProvider.updateProfile(
                              id: widget.profile.id,
                              username: username,
                              location: _location,
                              bio: _bio,
                              imagePath: imagePath,
                            );
                            await blogProvider.updateBlogsUser(
                              userId: widget.profile.userId,
                              user: username,
                            );
                            await commentProvider.updateCommentsUser(
                              userId: widget.profile.userId,
                              user: username,
                            );

                            setState(() {
                              _image = null;
                              _isSubmitting = false;
                            });

                            navigator.pop();

                            messenger.showSnackBar(
                              styledSnackBar(message: 'Profile updated!'),
                            );
                          }
                        },
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
