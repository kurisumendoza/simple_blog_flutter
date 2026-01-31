import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/login/login_form.dart';
import 'package:simple_blog_flutter/screens/register/register_screen.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Login'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: AppColors.secondary.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: StyledHeading('Login to your account', fontSize: 18),
              ),
              SizedBox(height: 20),
              Padding(padding: const EdgeInsets.all(8), child: LoginForm()),
              SizedBox(height: 30),
              Row(
                children: [
                  StyledText("Don't have an account yet? ", fontSize: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: StyledHeading('Register', color: AppColors.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
