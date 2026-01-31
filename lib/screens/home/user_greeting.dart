import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/services/user_provider.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class UserGreeting extends StatefulWidget {
  const UserGreeting({super.key});

  @override
  State<UserGreeting> createState() => _UserGreetingState();
}

class _UserGreetingState extends State<UserGreeting> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StyledHeading('Hi, ${value.username ?? 'Guest'}'),
          value.username != null
              ? TextButton(
                  onPressed: () {
                    // replace with profile page later
                    value.logoutUser();
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
