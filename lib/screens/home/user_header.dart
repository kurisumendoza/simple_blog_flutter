import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/screens/profile/profile_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  String? _userImage;

  Future<void> _fetchUserImage(String userId) async {
    final userImage = await context.read<ProfileProvider>().getUserImage(
      userId,
    );

    setState(() {
      _userImage = userImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        if (value.isLoggedIn && _userImage == null) {
          _fetchUserImage(value.userId!);
        } else if (!value.isLoggedIn && _userImage != null) {
          _userImage = null;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            value.username != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        _userImage == null
                            ? Container(
                                height: 40,
                                width: 40,
                                color: AppColors.primary,
                                child: Icon(Icons.person),
                              )
                            : Image.network(
                                ProfileStorageService.getImageUrl(_userImage!),
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(width: 10),
                        StyledHeading('${value.username}'),
                      ],
                    ),
                  )
                : StyledHeading('Hi, Guest'),
            value.isLoggedIn
                ? TextButton(
                    onPressed: () async {
                      final (success, message) = await value.logoutUser();

                      if (success) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(styledSnackBar(message: message));
                      } else {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          styledSnackBar(message: message, isError: true),
                        );
                      }
                    },
                    child: StyledHeading('Logout'),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: StyledHeading('Login'),
                  ),
          ],
        );
      },
    );
  }
}
