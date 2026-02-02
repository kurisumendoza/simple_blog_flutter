import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/shared/styled_button.dart';
import 'package:simple_blog_flutter/shared/styled_form_field.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';

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
                  final (success, message) = await context
                      .read<AuthProvider>()
                      .loginUser(_email, _password);

                  if (success) {
                    Navigator.pop(context);
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
