import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart';
import 'travel_diary_page.dart';
import 'post_detail_page.dart';
import 'premium_verwalten_page.dart';
import '../einstellungen/settings_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reiseplanung/reiseplanung_page.dart';
import 'user_profil_page.dart'; // <<< WICHTIG: anpassen falls anderer Name
import '../l10n/s.dart';

class ProfilePage extends StatefulWidget {
  final int initialTabIndex; // <<< NEU

  const ProfilePage({
    super.key,
    this.initialTabIndex = 0,
  }); // default = 0 = erster Tab

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _reisen = [];
  List<Map<String, dynamic>> _beitraege = [];

  bool _isLoading = true;

  int _followerCount = 0;
  int _followingCount = 0;
  List<String> _followerIds = [];
  List<String> _followingIds = [];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();

    // TabController später im DefaultTabController init
    // Wird weiter unten beim DefaultTabController benutzt
  }

  Widget _emptyState({
    required String title,
    required String message,
    required bool isDarkMode,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 60, color: textColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchUserData() async {
    if (_user == null) return;
    setState(() => _isLoading = true);

    try {
      final userDoc = await _firestore
          .collection('Users')
          .doc(_user!.uid)
          .get();
      _userData = userDoc.data();

      final reisenSnap = await _firestore
          .collection('Reisetagebcher')
          .where('uid', isEqualTo: _user!.uid)
          .orderBy('createdTime', descending: true)
          .get();
      _reisen = reisenSnap.docs.map((e) => {...e.data(), 'id': e.id}).toList();

      final beitraegeSnap = await _firestore
          .collection('Posts')
          .where('uid', isEqualTo: _user!.uid)
          .orderBy('createdTime', descending: true)
          .get();
      _beitraege = beitraegeSnap.docs
          .map((e) => {...e.data(), 'id': e.id})
          .toList();

      final followRef = _firestore.collection('Follow');

      final followerSnap = await followRef
          .where('followingId', isEqualTo: _user!.uid)
          .get();
      _followerCount = followerSnap.docs.length;
      _followerIds = followerSnap.docs
          .map((doc) => doc['followerId'] as String)
          .toList();

      final followingSnap = await followRef
          .where('followerId', isEqualTo: _user!.uid)
          .get();
      _followingCount = followingSnap.docs.length;
      _followingIds = followingSnap.docs
          .map((doc) => doc['followingId'] as String)
          .toList();
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openUserListSheet({
    required String title,
    required List<String> userIds,
    required bool isFollowerList,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                              ? "Du hast noch keine Follower."
                              : "Du folgst noch niemandem.",
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
                            future: _firestore
                                .collection('Users')
                                .doc(uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const SizedBox();
                              final user =
                                  snapshot.data!.data()
                                      as Map<String, dynamic>?;
                              if (user == null) return const SizedBox();
                              final username = user['username'] ?? 'User';
                              final profilePic = user['profilePicture'];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      profilePic != null &&
                                          profilePic.isNotEmpty
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
                                      builder: (_) => OtherUserProfilePage(
                                        userId: uid,
                                        isDarkMode: isDarkMode,
                                      ),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final purple = const Color(0xFF8C77FF);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: Icon(Icons.diamond, color: textColor, size: 28),
          onPressed: () {
            if (_user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PremiumPage(uid: _user!.uid)),
              );
            }
          },
        ),

        title: Text(
          S.of(context)!.myProfile,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: textColor, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: purple))
          : RefreshIndicator(
              color: purple,
              onRefresh: _fetchUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:
                          kToolbarHeight + MediaQuery.of(context).padding.top,
                    ),

                    // Profil Header
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _userData?['profilePicture'] != null
                              ? NetworkImage(_userData!['profilePicture'])
                              : const AssetImage(
                                      'assets/images/avatar_placeholder.png',
                                    )
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _userData?['username'] ?? 'User',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userData?['bio'] ?? S.of(context)!.noBio,
                                style: TextStyle(color: textColor),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        S.of(context)!.travel,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${_reisen.length}",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        S.of(context)!.contributions,
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${_beitraege.length}",
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => _openUserListSheet(
                                      title: S.of(context)!.followers,
                                      userIds: _followerIds,
                                      isFollowerList: true,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          S.of(context)!.followers,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$_followerCount",
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _openUserListSheet(
                                      title: S.of(context)!.following,
                                      userIds: _followingIds,
                                      isFollowerList: false,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          S.of(context)!.following,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$_followingCount",
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfilePage(),
                                ),
                              );
                            },
                            child: Text(S.of(context)!.editProfile),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    DefaultTabController(
                      length: 3,
                      initialIndex: widget
                          .initialTabIndex, // <<< hier den Parameter nutzen
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: purple,
                            unselectedLabelColor: textColor,
                            indicatorColor: purple,
                            tabs: [
                              Tab(text: S.of(context)!.journals),
                              Tab(text: S.of(context)!.posts),
                              Tab(text: S.of(context)!.planning),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                // Reisetagebücher
                                _reisen.isEmpty
                                    ? _emptyState(
                                        title: S.of(context)!.noJournal,
                                        message: S
                                            .of(context)!
                                            .noJournalMessage,
                                        isDarkMode: isDarkMode,
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: _reisen.length,
                                        itemBuilder: (_, index) {
                                          final item = _reisen[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      TravelDiaryDetailPage(
                                                        diaryId: item['id'],
                                                        isDarkMode: isDarkMode,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: purple,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (item['image'] != null)
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  12,
                                                                ),
                                                          ),
                                                      child: Image.network(
                                                        item['image'],
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    child: Text(
                                                      item['titel'] ?? 'Titel',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                // Beiträge
                                _beitraege.isEmpty
                                    ? _emptyState(
                                        title: S.of(context)!.noPost,
                                        message: S.of(context)!.noPostMessage,
                                        isDarkMode: isDarkMode,
                                      )
                                    : GridView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: _beitraege.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 6,
                                              mainAxisSpacing: 6,
                                              childAspectRatio: 1,
                                            ),
                                        itemBuilder: (_, index) {
                                          final item = _beitraege[index];

                                          // =========================
                                          // 🔹 NEUES FORMAT
                                          // =========================
                                          final List mediaUrls =
                                              item['mediaUrls'] ?? [];
                                          final List mediaTypes =
                                              item['mediaTypes'] ?? [];

                                          // =========================
                                          // 🔹 ALTES FORMAT
                                          // =========================
                                          final String? legacyImage =
                                              item['image'];
                                          final String? legacyVideo =
                                              item['videoUrl'];

                                          // =========================
                                          // 🔹 FALL 1: NEUES FORMAT
                                          // =========================
                                          if (mediaUrls.isNotEmpty) {
                                            final String coverType =
                                                mediaTypes.isNotEmpty
                                                ? mediaTypes.first
                                                : 'image';
                                            final List thumbnailUrls =
                                                item['thumbnailUrls'] ?? [];

                                            final String coverUrl =
                                                (coverType == 'video' &&
                                                    thumbnailUrls.isNotEmpty &&
                                                    thumbnailUrls
                                                        .first
                                                        .isNotEmpty)
                                                ? thumbnailUrls.first
                                                : mediaUrls.first;

                                            final bool isMulti =
                                                mediaUrls.length > 1;

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        PostDetailPage(
                                                          postId: item['id'],
                                                          isDarkMode:
                                                              isDarkMode,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: purple,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Image.network(
                                                        coverUrl,
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      ),
                                                    ),
                                                    if (coverType == 'video')
                                                      const Center(
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_fill,
                                                          color: Colors.white,
                                                          size: 48,
                                                        ),
                                                      ),
                                                    if (isMulti)
                                                      Positioned(
                                                        right: 8,
                                                        top: 8,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors.black54,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: const Icon(
                                                            Icons.collections,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          // =========================
                                          // 🔹 FALL 2: ALTES FORMAT
                                          // =========================
                                          if (legacyImage != null &&
                                              legacyImage.isNotEmpty) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        PostDetailPage(
                                                          postId: item['id'],
                                                          isDarkMode:
                                                              isDarkMode,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: purple,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    legacyImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          if (legacyVideo != null &&
                                              legacyVideo.isNotEmpty) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        PostDetailPage(
                                                          postId: item['id'],
                                                          isDarkMode:
                                                              isDarkMode,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: purple,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // (Falls du kein Thumbnail hast, bleibt es lila – wie früher)
                                                    Container(color: purple),
                                                    const Center(
                                                      child: Icon(
                                                        Icons.play_circle_fill,
                                                        color: Colors.white,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          // =========================
                                          // 🔹 SICHERHEIT
                                          // =========================
                                          return Container(color: purple);
                                        },
                                      ),
                                // Urlaubsplanung (neues Layout)
                                TripsOverviewPage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
