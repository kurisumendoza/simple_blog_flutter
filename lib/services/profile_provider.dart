import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/services/profile_services.dart';

class ProfileProvider extends ChangeNotifier {
  Future<void> createProfile({
    required String username,
    required String userId,
  }) async {
    await ProfileServices.createProfile(username: username, userId: userId);
  }
}
