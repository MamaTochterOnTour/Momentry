import 'package:flutter/material.dart';
import '../../l10n/s.dart';
import '../pages/edit_profile_page.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final int reisenCount;
  final int beitraegeCount;
  final int followerCount;
  final int followingCount;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;
  final bool isDarkMode;

  const ProfileHeader({
    super.key,
    required this.userData,
    required this.reisenCount,
    required this.beitraegeCount,
    required this.followerCount,
    required this.followingCount,
    required this.onFollowersTap,
    required this.onFollowingTap,
    required this.isDarkMode,
  });

  void _openImage(BuildContext context, String? url) {
    if (url == null) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final profileImage = userData?['profilePicture'];
    final strings = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👤 Avatar (CLICKABLE FIXED)
            GestureDetector(
              onTap: profileImage == null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    }
                  : () => _openImage(context, profileImage),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage)
                        : const AssetImage(
                                'assets/images/avatar_placeholder.png',
                              )
                              as ImageProvider,
                  ),

                  if (profileImage == null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 📊 STATS
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(strings.trips3, reisenCount, textColor),
                  _buildStat(strings.posts3, beitraegeCount, textColor),
                  GestureDetector(
                    onTap: onFollowersTap,
                    child: _buildStat(
                      strings.followers3,
                      followerCount,
                      textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: onFollowingTap,
                    child: _buildStat(
                      strings.following3,
                      followingCount,
                      textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 📝 BIO
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          },
          child: Text(
            (userData?['bio'] != null &&
                    userData!['bio'].toString().trim().isNotEmpty)
                ? userData!['bio']
                : "✏️ Biografie hinzufügen",
            style: TextStyle(
              fontSize: 13,
              color:
                  (userData?['bio'] == null ||
                      userData!['bio'].toString().trim().isEmpty)
                  ? Colors.redAccent
                  : textColor.withValues(alpha: 0.6),
              fontWeight:
                  (userData?['bio'] == null ||
                      userData!['bio'].toString().trim().isEmpty)
                  ? FontWeight.w600
                  : FontWeight.normal,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}
