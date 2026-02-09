import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_blog_flutter/screens/profile/profile_screen.dart';
import 'package:simple_blog_flutter/services/auth_provider.dart';
import 'package:simple_blog_flutter/services/profile_provider.dart';
import 'package:simple_blog_flutter/services/profile_storage_service.dart';
import 'package:simple_blog_flutter/shared/styled_snack_bar.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class OwnerLabel extends StatefulWidget {
  const OwnerLabel({
    super.key,
    required this.username,
    required this.userId,
    this.fontSize,
  });

  final String username;
  final String userId;
  final int? fontSize;

  @override
  State<OwnerLabel> createState() => _OwnerLabelState();
}

class _OwnerLabelState extends State<OwnerLabel> {
  String? _ownerImage;

  @override
  void initState() {
    _fetchOwnerImage();
    super.initState();
  }

  Future<void> _fetchOwnerImage() async {
    final profileProvider = context.read<ProfileProvider>();
    final image = await profileProvider.getUserImage(widget.userId);

    if (!mounted) return;

    setState(() {
      _ownerImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StyledText('by: ', fontSize: 12),
        GestureDetector(
          onTap: () {
            if (context.findAncestorWidgetOfExactType<ProfileScreen>() !=
                null) {
              return;
            }

            if (context.read<AuthProvider>().isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userId: widget.userId),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                styledSnackBar(
                  message: 'You have to login to view profiles',
                  isError: true,
                ),
              );
            }
          },
          child: Row(
            children: [
              _ownerImage == null
                  ? Container(
                      height: 25,
                      width: 25,
                      color: AppColors.primary,
                      child: Icon(Icons.person),
                    )
                  : Image.network(
                      ProfileStorageService.getImageUrl(_ownerImage!),
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
              SizedBox(width: 5),
              StyledText(widget.username),
            ],
          ),
        ),
      ],
    );
  }
}
