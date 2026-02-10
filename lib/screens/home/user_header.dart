import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/models/profile.dart';
import 'package:simple_blog_flutter/screens/login/login_screen.dart';
import 'package:simple_blog_flutter/screens/profile/profile_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_alert_dialog.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  Profile? _profile;

  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final profile = await profileProvider.getUser(authProvider.userId!);

    if (authProvider.isLoggedIn) {
      setState(() {
        _profile = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (auth.isLoggedIn && auth.username != null)
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        _profile?.imagePath == null
                            ? Container(
                                height: 40,
                                width: 40,
                                color: AppColors.primary,
                                child: Icon(Icons.person),
                              )
                            : Image.network(
                                ProfileStorageService.getImageUrl(
                                  _profile!.imagePath!,
                                ),
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(width: 10),
                        StyledHeading('${auth.username}'),
                      ],
                    ),
                  )
                : StyledHeading('Hi, Guest'),
            auth.isLoggedIn
                ? IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => StyledAlertDialog(
                        title: 'Logout',
                        content: StyledText('Do you want to logout?'),
                        mainAction: () async {
                          final (success, message) = await auth.logoutUser();

                          if (success) {
                            ScaffoldMessenger.of(
                              context,
                            ).removeCurrentSnackBar();
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(styledSnackBar(message: message));

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              styledSnackBar(message: message, isError: true),
                            );
                          }
                        },
                        mainActionLabel: 'Logout',
                        mainActionColor: Colors.red[400],
                      ),
                    ),
                    icon: Icon(
                      Icons.logout,
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: StyledHeading('Login'),
                  ),
          ],
        );
      },
    );
  }
}
