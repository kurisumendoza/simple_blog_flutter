import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(label: 'Username', maxLength: 12, minLength: 3),
          SizedBox(height: 15),
          StyledFormField(label: 'Email', isEmail: true, maxLength: 50),
          SizedBox(height: 15),
          StyledFormField(label: 'Password', isPassword: true, maxLength: 30),
          SizedBox(height: 30),
          Center(
            child: StyledFilledButton(
              'Register',
              onPressed: () {
                _formGlobalKey.currentState!.validate();
              },
            ),
          ),
        ],
      ),
    );
  }
}
