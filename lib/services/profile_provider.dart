import 'package:flutter/material.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  Future<Profile> getUser(String userId) async {
    final profile = await ProfileService.getUser(userId);

    notifyListeners();
    return profile[0];
  }

  Future<String?> getUserImage(String userId) async {
    final profile = await ProfileService.getUser(userId);

    return profile[0].imagePath;
  }

  Future<void> createProfile({
    required String username,
    required String userId,
  }) async {
    await ProfileService.createProfile(username: username, userId: userId);
  }

  Future<void> updateProfile({
    required int id,
    required String username,
    String? location,
    String? bio,
    String? imagePath,
  }) async {
    await ProfileService.updateProfile(
      id: id,
      username: username,
      location: location,
      bio: bio,
      imagePath: imagePath,
    );
  }

  Future<bool> userExists(String username) async {
    return await ProfileService.userExists(username);
  }
}
