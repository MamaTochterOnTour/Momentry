import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../einstellungen/settings_page.dart';
import '../pages/premium_verwalten_page.dart';
import '../pages/edit_profile_page.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User? user;
  final bool isDarkMode;
  final String? username;

  const ProfileAppBar({
    super.key,
    required this.user,
    required this.isDarkMode,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,

      // 💎 LINKS
      leading: IconButton(
        icon: Icon(Icons.diamond_outlined, color: textColor),
        onPressed: () {
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PremiumPage(uid: user!.uid)),
            );
          }
        },
      ),

      // 👤 MITTE (Instagram Style)
      title: GestureDetector(
        onTap: () {
          if (username == null || username!.trim().isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          }
        },
        child: Text(
          (username == null || username!.trim().isEmpty)
              ? "Username hinzufügen"
              : username!,
          style: TextStyle(
            color: (username == null || username!.trim().isEmpty)
                ? Colors.redAccent
                : textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ⚙️ RECHTS
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, color: textColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
