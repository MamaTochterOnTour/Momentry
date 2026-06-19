import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/user_profil_page.dart';
import '../../l10n/s.dart';

void openUserListSheet({
  required BuildContext context,
  required String title,
  required List<String> userIds,
  required bool isFollowerList,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final firestore = FirebaseFirestore.instance;
  final strings = S.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDarkMode ? Colors.black : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        color: isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: userIds.isEmpty
                  ? Center(
                      child: Text(
                        isFollowerList
                            ? strings.noFollowers3
                            : strings.notFollowingAnyone3,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: userIds.length,
                      itemBuilder: (context, index) {
                        final uid = userIds[index];

                        return FutureBuilder<DocumentSnapshot>(
                          future: firestore.collection('Users').doc(uid).get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();

                            final user =
                                snapshot.data!.data() as Map<String, dynamic>?;

                            if (user == null) return const SizedBox();

                            final username = user['username'] ?? 'User';
                            final profilePic = user['profilePicture'];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    profilePic != null && profilePic.isNotEmpty
                                    ? NetworkImage(profilePic)
                                    : const AssetImage(
                                            "assets/images/avatar_placeholder.png",
                                          )
                                          as ImageProvider,
                              ),
                              title: Text(
                                username,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OtherUserProfilePage(userId: uid),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
