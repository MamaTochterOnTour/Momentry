import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/s.dart';
import 'post_detail_page.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherUserProfilePage extends ConsumerStatefulWidget {
  final String userId;

  const OtherUserProfilePage({super.key, required this.userId});

  @override
  ConsumerState<OtherUserProfilePage> createState() =>
      _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends ConsumerState<OtherUserProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _beitraege = [];
  bool _isLoading = true;
  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _checkBlockedStatus();
  }

  Future<void> _checkBlockedStatus() async {
    final currentUid = _auth.currentUser!.uid;
    final doc = await _firestore
        .collection('blockedUsers')
        .doc(currentUid)
        .collection('blocked')
        .doc(widget.userId)
        .get();

    setState(() {
      _isBlocked = doc.exists;
    });
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    final currentUid = _auth.currentUser!.uid;

    try {
      final userDoc = await _firestore
          .collection('Users')
          .doc(widget.userId)
          .get();
      _userData = userDoc.data();

      final beitraegeSnap = await _firestore
          .collection('Posts')
          .where('uid', isEqualTo: widget.userId)
          .orderBy('createdTime', descending: true)
          .get();

      _beitraege = beitraegeSnap.docs
          .map((e) => {...e.data(), 'id': e.id})
          .toList();

      final followRef = _firestore.collection('Follow');

      final followQuery = await followRef
          .where('followerId', isEqualTo: currentUid)
          .where('followingId', isEqualTo: widget.userId)
          .get();
      _isFollowing = followQuery.docs.isNotEmpty;

      final followerQuery = await followRef
          .where('followingId', isEqualTo: widget.userId)
          .get();
      _followerCount = followerQuery.docs.length;

      final followingQuery = await followRef
          .where('followerId', isEqualTo: widget.userId)
          .get();
      _followingCount = followingQuery.docs.length;
    } catch (e) {
      debugPrint("Fehler: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _reportUser() async {
    final strings = S.of(context)!;
    final currentUid = _auth.currentUser!.uid;

    String? reason = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: Text(strings.reportUser),
          content: TextField(
            onChanged: (val) => input = val,
            decoration: InputDecoration(hintText: strings.reportReason),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, input),
              child: Text(strings.send),
            ),
          ],
        );
      },
    );

    if (reason != null && reason.isNotEmpty) {
      await _firestore.collection('userReports').add({
        'reportedBy': currentUid,
        'reportedUserId': widget.userId,
        'reason': reason,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.userReported)));
    }
  }

  Future<void> _blockUser() async {
    final currentUid = _auth.currentUser!.uid;
    final blockRef = _firestore
        .collection('blockedUsers')
        .doc(currentUid)
        .collection('blocked')
        .doc(widget.userId);

    final followRef = _firestore.collection('Follow');

    try {
      final followDocs = await followRef
          .where('followerId', isEqualTo: currentUid)
          .where('followingId', isEqualTo: widget.userId)
          .get();
      for (var doc in followDocs.docs) {
        await doc.reference.delete();
      }

      final followedByDocs = await followRef
          .where('followerId', isEqualTo: widget.userId)
          .where('followingId', isEqualTo: currentUid)
          .get();
      for (var doc in followedByDocs.docs) {
        await doc.reference.delete();
      }

      await blockRef.set({'blockedAt': FieldValue.serverTimestamp()});

      setState(() {
        _isBlocked = true;
        _isFollowing = false;
        _followerCount--;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.userBlocked)));
    } catch (e) {
      debugPrint("Fehler beim Blockieren: $e");
    }
  }

  Future<void> _unblockUser() async {
    await _firestore
        .collection('blockedUsers')
        .doc(_auth.currentUser!.uid)
        .collection('blocked')
        .doc(widget.userId)
        .delete();

    setState(() => _isBlocked = false);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context)!.userUnblocked)));
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Future<void> _toggleFollow() async {
    final currentUid = _auth.currentUser!.uid;
    final followRef = _firestore.collection('Follow');

    try {
      if (_isFollowing) {
        final query = await followRef
            .where('followerId', isEqualTo: currentUid)
            .where('followingId', isEqualTo: widget.userId)
            .get();
        for (var doc in query.docs) {
          await doc.reference.delete();
        }
        setState(() {
          _isFollowing = false;
          _followerCount--;
        });
      } else {
        await followRef.add({
          'followerId': currentUid,
          'followingId': widget.userId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // ⭐ NEU: Activity für den Profilinhaber
        await _firestore.collection('activities').add({
          'type': 'follow',
          'fromUserId': currentUid,
          'toUserId': widget.userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        setState(() {
          _isFollowing = true;
          _followerCount++;
        });
      }
    } catch (e) {
      debugPrint("Follow/Unfollow Fehler: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.followError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final purpleButtonColor = const Color(0xFF8C77FF);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: textColor),
        centerTitle: true,
        title: Text(
          _userData?['username'] ?? strings.user,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
        toolbarHeight: 80,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textColor),
            onSelected: (value) {
              if (value == 'report') {
                _reportUser();
              } else if (value == 'block_unblock') {
                _isBlocked ? _unblockUser() : _blockUser();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'report', child: Text(strings.report)),
              PopupMenuItem(
                value: 'block_unblock',
                child: Text(_isBlocked ? strings.unblock : strings.block),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    _userData?['profilePicture'] != null
                                    ? NetworkImage(_userData!['profilePicture'])
                                    : const AssetImage(
                                            'assets/images/avatar_placeholder.png',
                                          )
                                          as ImageProvider,
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildStatColumn(
                                      strings.posts,
                                      "${_beitraege.length}",
                                    ),
                                    _buildStatColumn(
                                      strings.followers,
                                      "$_followerCount",
                                    ),
                                    _buildStatColumn(
                                      strings.following,
                                      "$_followingCount",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // BIO unter Avatar, links bündig
                          SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (_userData?['bio']?.toString().isNotEmpty ??
                                        false)
                                    ? _userData!['bio']
                                    : strings.noBio,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _toggleFollow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purpleButtonColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        _isFollowing ? strings.followingBtn : strings.followBtn,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      strings.posts,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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

                      final List mediaUrls = item['mediaUrls'] ?? [];
                      final List mediaTypes = item['mediaTypes'] ?? [];
                      final String? legacyImage = item['image'];
                      final String? legacyVideo = item['videoUrl'];

                      if (mediaUrls.isNotEmpty) {
                        final String coverType = mediaTypes.isNotEmpty
                            ? mediaTypes.first
                            : 'image';
                        final List thumbnailUrls = item['thumbnailUrls'] ?? [];
                        final String coverUrl =
                            (coverType == 'video' &&
                                thumbnailUrls.isNotEmpty &&
                                thumbnailUrls.first.isNotEmpty)
                            ? thumbnailUrls.first
                            : mediaUrls.first;
                        final bool isMulti = mediaUrls.length > 1;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailPage(
                                  postId: item['id'],
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF8C77FF),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                if (isMulti)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(6),
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

                      if (legacyImage != null && legacyImage.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailPage(
                                  postId: item['id'],
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF8C77FF),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                legacyImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }

                      if (legacyVideo != null && legacyVideo.isNotEmpty) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailPage(
                                  postId: item['id'],
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF8C77FF),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF8C77FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
