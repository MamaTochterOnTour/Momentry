import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/user_profil_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';

class FollowSuggestionsPage extends StatefulWidget {
  const FollowSuggestionsPage({super.key});

  @override
  State<FollowSuggestionsPage> createState() => _FollowSuggestionsPageState();
}

class _FollowSuggestionsPageState extends State<FollowSuggestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _searchQuery = '';

  Future<void> _unfollowUser(String targetUserId) async {
    final uid = _auth.currentUser!.uid;

    final snap = await _firestore
        .collection('Follow')
        .where('followerId', isEqualTo: uid)
        .where('followingId', isEqualTo: targetUserId)
        .get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> _getFollowingIds() async {
    final uid = _auth.currentUser!.uid;

    final snap = await _firestore
        .collection('Follow')
        .where('followerId', isEqualTo: uid)
        .get();

    return snap.docs.map((e) => e['followingId'] as String).toList();
  }

  bool _matchesSearch(String username) {
    return username.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  Future<void> _followUser(String targetUserId) async {
    final uid = _auth.currentUser!.uid;

    final followRef = _firestore.collection('Follow');

    await followRef.add({
      'followerId': uid,
      'followingId': targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDark = ref.watch(darkModeProvider).value ?? false;

        final bg = isDark ? Colors.black : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;
        final hintColor = isDark ? Colors.white54 : Colors.black45;
        final cardColor = isDark ? Colors.grey[900] : Colors.grey[200];

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            centerTitle: true,
            title: Text(
              "Personen finden",
              style: GoogleFonts.pacifico(fontSize: 26, color: textColor),
            ),
            iconTheme: IconThemeData(color: textColor),
          ),

          body: FutureBuilder<List<String>>(
            future: _getFollowingIds(),
            builder: (context, followingSnap) {
              if (!followingSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final followingIds = followingSnap.data!;

              return StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final users = snapshot.data!.docs;

                  final filteredUsers = users.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final uid = doc.id;

                    final username = (data['username'] ?? '').toString().trim();
                    (data['profilePicture'] ?? '').toString();

                    final isMe = uid == _auth.currentUser!.uid;
                    final isAlreadyFollowing = followingIds.contains(uid);

                    final matchesSearch = _matchesSearch(username);

                    // ❌ KEIN Username → raus
                    if (username.isEmpty) return false;

                    // ❌ ich selbst → raus
                    if (isMe) return false;

                    // ❌ schon gefolgt → wichtig für dein Verhalten

                    if (isAlreadyFollowing) return false;

                    return matchesSearch;
                  }).toList();

                  filteredUsers.sort((a, b) {
                    final aData = a.data() as Map<String, dynamic>;
                    final bData = b.data() as Map<String, dynamic>;

                    final aHasPic = (aData['profilePicture'] ?? '')
                        .toString()
                        .isNotEmpty;
                    final bHasPic = (bData['profilePicture'] ?? '')
                        .toString()
                        .isNotEmpty;

                    if (aHasPic == bHasPic) return 0;
                    if (aHasPic) return -1;
                    return 1;
                  });

                  return Column(
                    children: [
                      // 🔎 SEARCH BAR
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "User suchen...",
                            hintStyle: TextStyle(color: hintColor),
                            prefixIcon: Icon(Icons.search, color: hintColor),
                            filled: true,
                            fillColor: cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      // LISTE
                      Expanded(
                        child: ListView(
                          children: [
                            // 🔵 USERS LIST
                            ...filteredUsers.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final uid = doc.id;
                              final username = data['username'] ?? 'User';
                              final image = data['profilePicture'] ?? '';

                              final isFollowing = followingIds.contains(uid);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: image.isNotEmpty
                                      ? NetworkImage(image)
                                      : null,
                                  child: image.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),

                                title: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OtherUserProfilePage(
                                          userId: uid,
                                          isDarkMode: isDark,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ),

                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFollowing
                                        ? (isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[300])
                                        : const Color(0xFF8C77FF),
                                  ),
                                  onPressed: () async {
                                    if (isFollowing) {
                                      await _unfollowUser(uid);
                                    } else {
                                      await _followUser(uid);
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    isFollowing ? "Gefolgt" : "Folgen",
                                    style: TextStyle(
                                      color: isFollowing
                                          ? textColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            const SizedBox(height: 20),
                            const Divider(),

                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                "Personen, denen ich folge",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),

                            FutureBuilder<List<String>>(
                              future: _getFollowingIds(),
                              builder: (context, snap) {
                                if (!snap.hasData) return const SizedBox();

                                final ids = snap.data!;

                                return StreamBuilder<QuerySnapshot>(
                                  stream: _firestore
                                      .collection('Users')
                                      .snapshots(),
                                  builder: (context, userSnap) {
                                    if (!userSnap.hasData) {
                                      return const SizedBox();
                                    }

                                    final users = userSnap.data!.docs.where((
                                      doc,
                                    ) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;

                                      final username = (data['username'] ?? '')
                                          .toString();

                                      final isInFollowing = ids.contains(
                                        doc.id,
                                      );

                                      if (!isInFollowing) return false;

                                      return _matchesSearch(username);
                                    }).toList();

                                    return Column(
                                      children: users.map((doc) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;

                                        return ListTile(
                                          title: Text(
                                            data['username'] ?? 'User',
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                (data['profilePicture'] ?? '')
                                                    .toString()
                                                    .isNotEmpty
                                                ? NetworkImage(
                                                    data['profilePicture'],
                                                  )
                                                : null,
                                            child:
                                                (data['profilePicture'] ?? '')
                                                    .toString()
                                                    .isEmpty
                                                ? const Icon(Icons.person)
                                                : null,
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
