import 'package:flutter/material.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👤 Avatar (CLICKABLE FIXED)
            GestureDetector(
              onTap: () => _openImage(context, profileImage),
              child: CircleAvatar(
                radius: 38,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage)
                    : const AssetImage('assets/images/avatar_placeholder.png')
                          as ImageProvider,
              ),
            ),

            const SizedBox(width: 16),

            // 📊 STATS
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat("Reisen", reisenCount, textColor),
                  _buildStat("Beiträge", beitraegeCount, textColor),
                  GestureDetector(
                    onTap: onFollowersTap,
                    child: _buildStat("Follower", followerCount, textColor),
                  ),
                  GestureDetector(
                    onTap: onFollowingTap,
                    child: _buildStat("Gefolgt", followingCount, textColor),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 📝 BIO
        Text(
          (userData?['bio'] != null &&
                  userData!['bio'].toString().trim().isNotEmpty)
              ? userData!['bio']
              : "Noch keine Bio hinzugefügt",
          style: TextStyle(
            fontSize: 13,
            color: textColor.withValues(alpha: 0.6),
            height: 1.3,
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
