import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/screens/register/register_form.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: StyledTitle('Register'), centerTitle: true),
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
                child: StyledHeading('Register new account', fontSize: 18),
              ),
              SizedBox(height: 20),
              Padding(padding: const EdgeInsets.all(8), child: RegisterForm()),
              SizedBox(height: 30),
              Row(
                children: [
                  StyledText("Already have an account? ", fontSize: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: StyledHeading('Login', color: AppColors.accent),
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
