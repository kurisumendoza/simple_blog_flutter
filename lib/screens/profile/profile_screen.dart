import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/profile_edit/edit_profile_screen.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Profile'), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                        StyledHeading('Maki'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.cake, color: AppColors.accent),
                        SizedBox(width: 10),
                        StyledHeading('Yesterday'),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.pin_drop, color: AppColors.accent),
                        SizedBox(width: 10),
                        StyledHeading('Bulacan'),
                      ],
                    ),
                    SizedBox(height: 10),
                    StyledFilledButton(
                      'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
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
                  StyledText('Hello, world!'),
                ],
              ),
            ),
            SizedBox(height: 16),

            Expanded(
              child: Column(
                children: [
                  StyledTitle('Recent Posts'), SizedBox(height: 16),
                  // add blog posts here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
