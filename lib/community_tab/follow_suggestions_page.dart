import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../profil_tab/other_user_profil_page.dart';
import '../providers/dark_mode_provider.dart';

class FollowSuggestionsPage extends StatefulWidget {
  const FollowSuggestionsPage({super.key});

  @override
  State<FollowSuggestionsPage> createState() => _FollowSuggestionsPageState();
}

class _FollowSuggestionsPageState extends State<FollowSuggestionsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String search = "";

  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  List<String> followingIds = [];
  List<String> followersIds = [];

  @override
  void initState() {
    super.initState();
    loadFollowData();
  }

  Future<void> loadFollowData() async {
    final uid = _auth.currentUser!.uid;

    final following = await _firestore
        .collection("Follow")
        .where("followerId", isEqualTo: uid)
        .get();

    final followers = await _firestore
        .collection("Follow")
        .where("followingId", isEqualTo: uid)
        .get();

    setState(() {
      followingIds = following.docs
          .map((e) => e["followingId"] as String)
          .toList();

      followersIds = followers.docs
          .map((e) => e["followerId"] as String)
          .toList();
    });
  }

  Future<void> followUser(String id) async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection("Follow").add({
      "followerId": uid,
      "followingId": id,
      "timestamp": FieldValue.serverTimestamp(),
    });

    setState(() {
      followingIds.add(id);
    });
  }

  Future<void> unfollowUser(String id) async {
    final uid = _auth.currentUser!.uid;

    final snap = await _firestore
        .collection("Follow")
        .where("followerId", isEqualTo: uid)
        .where("followingId", isEqualTo: id)
        .get();

    for (final doc in snap.docs) {
      await doc.reference.delete();
    }

    setState(() {
      followingIds.remove(id);
    });
  }

  void openProfile(String id) {
    Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => OtherUserProfilePage(userId: id)),
    );
  }

  int sortUsers(DocumentSnapshot a, DocumentSnapshot b) {
    final aData = a.data() as Map<String, dynamic>;
    final bData = b.data() as Map<String, dynamic>;

    final aPic = (aData["profilePicture"] ?? "").toString().isNotEmpty;
    final bPic = (bData["profilePicture"] ?? "").toString().isNotEmpty;

    if (aPic == bPic) {
      return 0;
    }

    return aPic ? -1 : 1;
  }

  String followText(String id) {
    final follows = followingIds.contains(id);

    final followsMe = followersIds.contains(id);

    if (follows && followsMe) {
      return "Verbunden";
    }

    if (follows) {
      return "Gefolgt";
    }

    if (followsMe) {
      return "Auch folgen";
    }

    return "Folgen";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final dark = ref.watch(darkModeProvider).value ?? false;

        final bg = dark ? Colors.black : Colors.white;

        final text = dark ? Colors.white : Colors.black;

        final card = dark ? Colors.grey[900] : Colors.grey[100];

        return Scaffold(
          backgroundColor: bg,

          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            centerTitle: true,

            iconTheme: IconThemeData(color: text),

            title: isSearching
                ? TextField(
                    controller: searchController,

                    autofocus: true,

                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },

                    style: TextStyle(color: text),

                    decoration: InputDecoration(
                      hintText: "Reiseliebhaber suchen...",

                      hintStyle: TextStyle(color: text.withValues(alpha: .5)),

                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    "Personen finden",

                    style: GoogleFonts.pacifico(fontSize: 26, color: text),
                  ),

            actions: [
              IconButton(
                icon: Icon(
                  isSearching ? Icons.close : Icons.search,
                  color: text,
                ),

                onPressed: () {
                  setState(() {
                    if (isSearching) {
                      isSearching = false;

                      search = "";

                      searchController.clear();
                    } else {
                      isSearching = true;
                    }
                  });
                },
              ),
            ],
          ),

          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection("Users").snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final current = _auth.currentUser!.uid;

              final allUsers = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;

                final username = (data["username"] ?? "").toString().trim();

                if (username.isEmpty) {
                  return false;
                }

                if (doc.id == current) {
                  return false;
                }

                return username.toLowerCase().contains(search.toLowerCase());
              }).toList();

              allUsers.sort(sortUsers);

              final discover = allUsers
                  .where((u) => !followingIds.contains(u.id))
                  .toList();

              // Personen, die dir folgen, nach oben sortieren
              discover.sort((a, b) {
                final aFollowsMe = followersIds.contains(a.id);

                final bFollowsMe = followersIds.contains(b.id);

                if (aFollowsMe == bFollowsMe) {
                  // danach weiterhin Profilbild zuerst
                  return sortUsers(a, b);
                }

                return aFollowsMe ? -1 : 1;
              });

              final following = allUsers
                  .where((u) => followingIds.contains(u.id))
                  .toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),

                      children: [
                        sectionTitle("Entdecken", text),

                        ...discover.map((doc) => userCard(doc, card, text)),

                        const SizedBox(height: 25),

                        sectionTitle("Reiseliebhaber, denen du folgst", text),

                        ...following.map((doc) => userCard(doc, card, text)),
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

  Widget sectionTitle(String title, Color text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Text(
        title,

        style: TextStyle(
          color: text,

          fontSize: 18,

          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget userCard(DocumentSnapshot doc, Color? card, Color text) {
    final data = doc.data() as Map<String, dynamic>;

    final uid = doc.id;

    final username = data["username"];

    final bio = data["bio"] ?? "";

    final image = data["profilePicture"] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: card,

        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () => openProfile(uid),

            child: CircleAvatar(
              radius: 32,

              backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,

              child: image.isEmpty ? const Icon(Icons.person) : null,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: GestureDetector(
              onTap: () => openProfile(uid),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    username,

                    style: TextStyle(
                      color: text,

                      fontWeight: FontWeight.bold,

                      fontSize: 17,
                    ),
                  ),

                  if (bio.isNotEmpty)
                    Text(
                      bio,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(color: text.withValues(alpha: .6)),
                    ),
                ],
              ),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  followText(uid) == "Folgen" ||
                      followText(uid) == "Auch folgen"
                  ? const Color(0xFF8C77FF) // euer Lila
                  : Colors.grey.shade300, // Gefolgt / Verbunden
              foregroundColor:
                  followText(uid) == "Folgen" ||
                      followText(uid) == "Auch folgen"
                  ? Colors.white
                  : Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            onPressed: () {
              if (followingIds.contains(uid)) {
                unfollowUser(uid);
              } else {
                followUser(uid);
              }
            },

            child: Text(
              followText(uid),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
