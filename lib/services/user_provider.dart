import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  User? get user => AuthService.user;
  String? get username => AuthService.username;
  bool get isLoggedIn => user != null;

  Future<void> loginUser(String email, String password) async {
    await AuthService.loginUser(email, password);
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await AuthService.logoutUser();
    notifyListeners();
  }

  Future<(bool, String)> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      await AuthService.registerUser(email, password, username);
      notifyListeners();

      return (true, 'Welcome, $username!');
    } catch (e) {
      return (false, 'Failed to register!');
    }
  }
}
