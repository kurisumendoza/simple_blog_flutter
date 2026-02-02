import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/user_provider.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _username = '';
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
            label: 'Username',
            onSaved: (value) => _username = value!,
            maxLength: 12,
            minLength: 3,
          ),
          SizedBox(height: 15),
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
          SizedBox(height: 30),
          Center(
            child: StyledFilledButton(
              'Register',
              onPressed: () async {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                  final (success, message) = await context
                      .read<UserProvider>()
                      .registerUser(_email, _password, _username);

                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(styledSnackBar(message: message));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      styledSnackBar(message: message, isError: true),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
