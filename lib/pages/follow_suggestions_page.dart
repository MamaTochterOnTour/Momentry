import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/user_profil_page.dart';
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
  List<String> _followingIds = [];

  @override
  void initState() {
    super.initState();
    _loadFollowing();
  }

  Future<void> _loadFollowing() async {
    final uid = _auth.currentUser!.uid;

    final snap = await _firestore
        .collection('Follow')
        .where('followerId', isEqualTo: uid)
        .get();

    setState(() {
      _followingIds = snap.docs.map((e) => e['followingId'] as String).toList();
    });
  }

  Future<void> _followUser(String targetUserId) async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('Follow').add({
      'followerId': uid,
      'followingId': targetUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _followingIds.add(targetUserId);
    });
  }

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

    setState(() {
      _followingIds.remove(targetUserId);
    });
  }

  bool _matchesSearch(String username) {
    return username.toLowerCase().contains(_searchQuery.toLowerCase());
  }

  void _openProfile(String uid, bool isDark) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtherUserProfilePage(userId: uid)),
    );
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

          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentUid = _auth.currentUser!.uid;

              final allUsers = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;

                final uid = doc.id;
                final username = (data['username'] ?? '').toString().trim();

                if (username.isEmpty) return false;
                if (uid == currentUid) return false;

                return _matchesSearch(username);
              }).toList();

              // sort: profile picture first
              allUsers.sort((a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;

                final aHasPic = (aData['profilePicture'] ?? '')
                    .toString()
                    .isNotEmpty;
                final bHasPic = (bData['profilePicture'] ?? '')
                    .toString()
                    .isNotEmpty;

                if (aHasPic == bHasPic) return 0;
                return aHasPic ? -1 : 1;
              });

              // nach deiner Filterlogik bleibt das gleich:

              final followingUsers = allUsers
                  .where((doc) => _followingIds.contains(doc.id))
                  .toList();

              final suggestionUsers = allUsers
                  .where((doc) => !_followingIds.contains(doc.id))
                  .toList();

              // sortierung (profilbild zuerst)
              int sortByPic(a, b) {
                final aData = a.data() as Map<String, dynamic>;
                final bData = b.data() as Map<String, dynamic>;

                final aHasPic = (aData['profilePicture'] ?? '')
                    .toString()
                    .isNotEmpty;
                final bHasPic = (bData['profilePicture'] ?? '')
                    .toString()
                    .isNotEmpty;

                if (aHasPic == bHasPic) return 0;
                return aHasPic ? -1 : 1;
              }

              followingUsers.sort(sortByPic);
              suggestionUsers.sort(sortByPic);

              return Column(
                children: [
                  // SEARCH
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
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

                  Expanded(
                    child: ListView(
                      children: [
                        // 🔵 SUGGESTIONS (ALLE NICHT-FOLLOWING USERS)
                        ...suggestionUsers.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final uid = doc.id;
                          final username = data['username'] ?? 'User';
                          final image = data['profilePicture'] ?? '';

                          final isFollowing = _followingIds.contains(uid);

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
                              onTap: () => _openProfile(uid, isDark),
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
                              },
                              child: Text(
                                isFollowing ? "Gefolgt" : "Folgen",
                                style: TextStyle(
                                  color: isFollowing ? textColor : Colors.white,
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

                        // 👇 FOLLOWING USERS
                        ...followingUsers.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final uid = doc.id;
                          final username = data['username'] ?? 'User';
                          final image = data['profilePicture'] ?? '';

                          return ListTile(
                            onTap: () => _openProfile(uid, isDark),

                            leading: CircleAvatar(
                              backgroundImage: image.isNotEmpty
                                  ? NetworkImage(image)
                                  : null,
                              child: image.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),

                            title: Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
