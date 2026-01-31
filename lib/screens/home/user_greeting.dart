import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/services/auth_service.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userName = AuthService.userName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StyledHeading('Hi, ${userName ?? 'Guest'}'),
        userName != null
            ? TextButton(onPressed: () {}, child: StyledHeading('Logout'))
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
  }
}
