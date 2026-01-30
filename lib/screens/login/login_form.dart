import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledFormField(
            label: 'Email',
            isEmail: true,
            onSaved: (value) => _email = value!,
            maxLength: 50,
          ),
          SizedBox(height: 15),
          StyledFormField(
            label: 'Password',
            isPassword: true,
            onSaved: (value) => _password = value!,
            maxLength: 30,
          ),
          SizedBox(height: 15),
          Center(
            child: StyledFilledButton(
              'Login',
              onPressed: () async {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
