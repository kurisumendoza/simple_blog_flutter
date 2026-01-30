import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: StyledTitle('Login')));
  }
}
