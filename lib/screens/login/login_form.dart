import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [StyledFilledButton('Login', onPressed: () {})],
      ),
    );
  }
}
