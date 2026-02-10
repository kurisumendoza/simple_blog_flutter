import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/screens/home/blog_card.dart';
import 'package:simple_blog_flutter/screens/profile_edit/edit_profile_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/blog_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.userId});

  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userId;
  bool _isOwner = true;
  bool _isLoading = true;
  Profile? _profile;

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final blogProvider = context.read<BlogProvider>();

    _userId = widget.userId ?? authProvider.userId;
    _isOwner = _userId == authProvider.userId;

    setState(() {
      _isLoading = true;
      _profile = null;
    });

    if (_userId != null) {
      final profile = await profileProvider.getUser(_userId!.trim());
      await blogProvider.getUserBlogs(_userId!);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogs = context.read<BlogProvider>().userBlogs;

    return Scaffold(
      appBar: AppBar(title: StyledHeading('Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: _profile == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _profile?.imagePath != null
                                ? Image.network(
                                    ProfileStorageService.getImageUrl(
                                      _profile!.imagePath!,
                                    ),
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
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person, color: AppColors.accent),
                                    SizedBox(width: 10),
                                    StyledHeading(_profile!.user),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.cake, color: AppColors.accent),
                                    SizedBox(width: 10),
                                    StyledHeading(_profile!.formattedDate),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.pin_drop,
                                      color: AppColors.accent,
                                    ),
                                    SizedBox(width: 10),
                                    StyledHeading(
                                      _profile?.location ?? 'Not set',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (_isOwner)
                                  StyledFilledButton(
                                    'Edit Profile',
                                    onPressed: () async {
                                      bool isChanged = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileScreen(_profile!),
                                        ),
                                      );

                                      if (isChanged) {
                                        setState(() {
                                          _isLoading = true;
                                        });

                                        _loadProfile();
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          color: AppColors.secondary.withAlpha(150),
                          height: 180,
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StyledHeading('Bio'),
                              SizedBox(height: 10),
                              StyledText(_profile?.bio ?? 'Not set'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Flexible(
                          child: Column(
                            children: [
                              StyledTitle('Recent Posts'),
                              SizedBox(height: 16),
                              Expanded(
                                child: blogs.isEmpty
                                    ? StyledText('No post yet')
                                    : ListView.builder(
                                        itemCount: blogs.length,
                                        itemBuilder: ((context, index) {
                                          return BlogCard(
                                            key: ValueKey(blogs[index].id),
                                            blog: blogs[index],
                                          );
                                        }),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
