import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/screens/profile/profile_screen.dart';
import 'package:simple_blog_flutter/services/user_provider.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          value.username != null
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Container(
                          color: AppColors.primary,
                          child: Icon(Icons.person),
                        ),
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
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(styledSnackBar(message: message));
                    } else {
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
      ),
    );
  }
}
