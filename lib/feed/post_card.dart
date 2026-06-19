import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../pages/user_profil_page.dart';
import '../pages/edit_post_page.dart';
import '../pages/premium_verwalten_page.dart';
import '../l10n/s.dart';
import 'video_post_payer.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ---------------- PostCard mit Herz-Animation und korrektem Premium Save ----------------
class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final bool userLiked;
  final bool isDarkMode;
  final VoidCallback toggleLike;
  final VoidCallback showComments;

  const PostCard({
    super.key,
    required this.post,
    required this.userLiked,
    required this.isDarkMode,
    required this.toggleLike,
    required this.showComments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool _showHeart = false;
  bool _isExpanded = false; // NEU: steuert Caption/Hashtags einklappen
  late AnimationController _controller;

  PageController? _pageController;
  int _currentPage = 0;

  bool _shouldLoadMedia = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.5,
      upperBound: 1.5,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    _pageController = PageController();
  }

  Widget _buildMedia() {
    final mediaUrls = widget.post['mediaUrls'] as List<dynamic>?;
    final mediaTypes = widget.post['mediaTypes'] as List<dynamic>?;

    // Wrap the media rendering with VisibilityDetector
    return VisibilityDetector(
      key: Key(
        'post_media_${widget.post['id']}',
      ), // Eindeutiger Schlüssel für jeden Post
      onVisibilityChanged: (info) {
        // Laden, wenn mindestens 50% sichtbar sind
        if (info.visibleFraction >= 0.5 && !_shouldLoadMedia) {
          setState(() {
            _shouldLoadMedia = true;
          });
        }
      },
      child: _shouldLoadMedia
          ? AspectRatio(
              aspectRatio: 3 / 4,
              child: GestureDetector(
                onDoubleTap: _onDoubleTapLike,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Fallback für alte Posts mit einzelnem Bild/Video
                    if ((mediaUrls == null || mediaUrls.isEmpty) &&
                        widget.post['image'] != null)
                      _buildSingleMediaContent(
                        widget.post['image'],
                        widget.post['mediaType'] ?? 'image',
                      ),
                    // Einzelnes Medium (moderne Posts)
                    if (mediaUrls != null && mediaUrls.length == 1)
                      _buildSingleMediaContent(
                        mediaUrls[0],
                        mediaTypes != null && mediaTypes.isNotEmpty
                            ? mediaTypes[0]
                            : 'image',
                      ),
                    // Mehrere Medien → PageView + Punkte
                    if (mediaUrls != null && mediaUrls.length > 1)
                      _buildMultiMediaContent(mediaUrls, mediaTypes),
                    if (_showHeart)
                      ScaleTransition(
                        scale: _controller,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                  ],
                ),
              ),
            )
          : const SizedBox(
              height: 300, // Platzhalterhöhe, kann angepasst werden
              child: Center(
                child: CircularProgressIndicator(),
              ), // Ladeindikator oder leeres Widget
            ),
    );
  }

  // Helper method for single media content
  Widget _buildSingleMediaContent(String url, String type) {
    return type == 'video'
        ? VideoPostPlayer(videoUrl: url)
        : Image.network(url, fit: BoxFit.cover);
  }

  // Helper method for multiple media content (PageView)
  Widget _buildMultiMediaContent(
    List<dynamic> mediaUrls,
    List<dynamic>? mediaTypes,
  ) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: mediaUrls.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final url = mediaUrls[index];
              final type = mediaTypes != null && index < mediaTypes.length
                  ? mediaTypes[index]
                  : 'image';
              return _buildSingleMediaContent(
                url,
                type,
              ); // Wiederverwendung des Single Media Builders
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(mediaUrls.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.purple : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  // NEU: Text kürzen ohne Wort zu schneiden
  // ignore: unused_element
  String _shortenText(String text, {int limit = 50}) {
    if (text.length <= limit) return text;
    final truncated = text.substring(0, limit);
    final lastSpace = truncated.lastIndexOf(' ');
    if (lastSpace == -1) return truncated;
    return truncated.substring(0, lastSpace);
  }

  // String _getTimeAgo(Timestamp createdTime) {
  //  final now = DateTime.now();
  //  final now = DateTime.now();
  // final date = createdTime.toDate();
  // final diff = now.difference(date);

  // final strings = S.of(context)!; // generierte Strings

  // if (diff.inDays >= 7) {
  //   return '${date.day}.${date.month}.${date.year}'; // immer noch Datum, kein Text
  // } else if (diff.inDays >= 1) {
  //   return strings.timeAgoDays(diff.inDays);
  // } else if (diff.inHours >= 1) {
  //   return strings.timeAgoHours(diff.inHours);
  // } else if (diff.inMinutes >= 1) {
  //   return strings.timeAgoMinutes(diff.inMinutes);
  // } else {
  //   return strings.timeAgoJustNow;
  // }
  // }

  // Funktion zum Öffnen des Likes-BottomSheets
  void _showLikesSheet(List<dynamic> hearts) {
    final isDarkMode = widget.isDarkMode;
    final strings = S.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white24 : Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  strings.likesCount2(hearts.length),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),

              const Divider(height: 1),

              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: hearts.length,
                  itemBuilder: (context, index) {
                    final uid = hearts[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data!.data() == null) {
                          return const SizedBox.shrink();
                        }

                        final user =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final username = user['username'] ?? 'User';
                        final profilePic = user['profilePicture'] ?? '';

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.deepPurple,
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : null,
                          ),
                          title: Text(
                            username,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
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

  // -------------------- Gefällt mir Text --------------------
  Widget buildLikesText() {
    final hearts = widget.post['hearts'] as List<dynamic>? ?? [];
    if (hearts.isEmpty) {
      return const SizedBox.shrink(); // nichts anzeigen, wenn niemand geliked hat
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(hearts.first)
          .get(), // ersten User holen
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const SizedBox.shrink();
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final firstUsername = userData['username'] ?? 'User';
        final profilePic = userData['profilePicture'] ?? '';
        final othersCount = hearts.length - 1;

        final strings = S.of(context)!;
        String text;

        if (othersCount > 0) {
          text = strings.likesTextMultiple(firstUsername, othersCount);
        } else {
          text = strings.likesTextSingle(firstUsername);
        }

        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: GestureDetector(
            onTap: () => _showLikesSheet(hearts),
            child: Row(
              children: [
                // Profilbild des ersten Users
                CircleAvatar(
                  radius: 10,
                  backgroundImage: profilePic.isNotEmpty
                      ? NetworkImage(profilePic)
                      : const AssetImage(
                              'assets/images/avatar_placeholder_purple.png',
                            )
                            as ImageProvider,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: widget.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getShortCaption(String caption, {int limit = 50}) {
    if (caption.length <= limit) return caption;
    final truncated = caption.substring(0, limit);
    final lastSpace = truncated.lastIndexOf(' ');
    return lastSpace == -1 ? truncated : truncated.substring(0, lastSpace);
  }

  void _onDoubleTapLike() {
    if (!(widget.userLiked)) {
      widget.toggleLike();
    }
    setState(() => _showHeart = true);
    _controller.forward(from: 0.5);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _showHeart = false);
    });
  }

  Future<int> _getSavedCount(String postId) async {
    final querySnap = await FirebaseFirestore.instance
        .collection('Users')
        .where('savedPosts', arrayContains: postId)
        .get();
    return querySnap.docs.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final postOwnerId = widget.post['uid'];
    final isOwnPost = currentUserId == postOwnerId;
    final strings = S.of(context)!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.post['uid'])
          .snapshots(),
      builder: (context, userSnapshot) {
        String? profilePic;
        if (userSnapshot.hasData && userSnapshot.data!.data() != null) {
          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          profilePic = userData['profilePicture'];
        }

        return Card(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profil + Username + Location
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          profilePic != null && profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : const AssetImage(
                                  'assets/images/avatar_placeholder.png',
                                )
                                as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtherUserProfilePage(
                                    userId: widget.post['uid'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              userSnapshot.hasData &&
                                      userSnapshot.data!.data() != null
                                  ? (userSnapshot.data!.data()
                                            as Map<
                                              String,
                                              dynamic
                                            >)['username'] ??
                                        'User'
                                  : 'User',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          if (widget.post['location'] != null)
                            Text(
                              widget.post['location'],
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // ✅ PopupMenuButton für die drei Punkte
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      onSelected: (value) async {
                        if (isOwnPost) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPostPage(
                                  postId: widget.post['id'],
                                  isDarkMode: widget.isDarkMode,
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(strings.deletePost),
                                content: Text(strings.deletePostConfirm),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(strings.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(strings.delete),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed ?? false) {
                              final postId = widget.post['id'];
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;

                              // 1. Post-Dokument löschen
                              await FirebaseFirestore.instance
                                  .collection('Posts')
                                  .doc(postId)
                                  .delete();

                              // 2. Storage Dateien löschen (Media + Thumbnails)
                              final storageRef = FirebaseStorage.instance
                                  .ref()
                                  .child('users/$uid/posts/$postId');

                              try {
                                final listResult = await storageRef.listAll();

                                // alle Dateien löschen
                                for (var file in listResult.items) {
                                  await file.delete();
                                }

                                // auch Unterordner (z.B. thumbnails)
                                for (var prefix in listResult.prefixes) {
                                  final subList = await prefix.listAll();
                                  for (var file in subList.items) {
                                    await file.delete();
                                  }
                                }
                              } catch (e) {
                                debugPrint('Storage delete error: $e');
                              }
                            }
                          }
                        } else {
                          if (value == 'report') {
                            // Meldungs-Dialog für fremde Posts
                            String? reason = await showDialog<String>(
                              context: context,
                              builder: (context) {
                                String input = '';
                                return AlertDialog(
                                  title: Text(strings.reportPost),
                                  content: TextField(
                                    onChanged: (val) => input = val,
                                    decoration: InputDecoration(
                                      hintText: strings.reportReason,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(strings.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, input),
                                      child: Text(strings.send),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (reason != null && reason.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('postReports')
                                  .add({
                                    'reportedBy': currentUserId,
                                    'reportedPostId': widget.post['id'],
                                    'reason': reason,
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });

                              if (!context.mounted) return; // <-- richtig
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(strings.reportedSuccess),
                                ),
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => isOwnPost
                          ? [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(strings.edit),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(strings.delete),
                              ),
                            ]
                          : [
                              PopupMenuItem(
                                value: 'report',
                                child: Text(strings.reportPost),
                              ),
                            ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Post Image mit Herz-Animation
                // Alte und neue Posts
                if ((widget.post['image'] != null) ||
                    (widget.post['mediaUrls'] != null &&
                        (widget.post['mediaUrls'] as List).isNotEmpty))
                  GestureDetector(
                    onDoubleTap: _onDoubleTapLike,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildMedia(),
                        ),
                        if (_showHeart)
                          ScaleTransition(
                            scale: _controller,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 100,
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),

                // Caption + Hashtags
                if (widget.post['caption'] != null &&
                    (widget.post['caption'] as String).isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded; // einklappen/aufklappen
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: textColor, fontSize: 16),
                            children: [
                              TextSpan(
                                text: _isExpanded
                                    ? widget.post['caption']
                                    : _getShortCaption(widget.post['caption']),
                              ),
                              if (!_isExpanded &&
                                  widget.post['caption'].length > 50)
                                TextSpan(
                                  text: strings.readMore,
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                            ],
                          ),
                        ),
                        if (widget.post['hashtag'] != null &&
                            (widget.post['hashtag'] as List).isNotEmpty &&
                            _isExpanded) // oder immer anzeigen, je nach Wunsch
                          Wrap(
                            spacing: 8,
                            children: (widget.post['hashtag'] as List)
                                .map<Widget>((tag) {
                                  return Text(
                                    '$tag',
                                    style: TextStyle(color: Colors.blueAccent),
                                  );
                                })
                                .toList(),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // -------------------- Herz, Kommentar, Lesezeichen + Zeit --------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Herz-Button
                        GestureDetector(
                          onTap: widget.toggleLike,
                          child: Icon(
                            widget.userLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.userLiked ? Colors.red : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(widget.post['hearts'] as List<dynamic>?)?.length ?? 0}',
                          style: TextStyle(color: textColor),
                        ),
                        const SizedBox(width: 16),

                        // Kommentar-Button + Kommentaranzahl
                        GestureDetector(
                          onTap: widget.showComments,
                          child: Row(
                            children: [
                              Icon(Icons.comment, color: Colors.blueAccent),
                              const SizedBox(width: 4),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Posts')
                                    .doc(widget.post['id'])
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const Text('0');
                                  final commentCount =
                                      snapshot.data!['commentCount'] ?? 0;
                                  return Text(
                                    '$commentCount',
                                    style: TextStyle(color: textColor),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Speichern-/Lesezeichen-Button
                        // Speichern-/Lesezeichen-Button
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get(),
                          builder: (context, snapshot) {
                            bool isPremium = false;
                            List<dynamic> userSavedPosts = [];
                            if (snapshot.hasData &&
                                snapshot.data!.data() != null) {
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              isPremium = userData['isPremium'] ?? false;
                              userSavedPosts = userData['savedPosts'] ?? [];
                            }
                            final isSaved = userSavedPosts.contains(
                              widget.post['id'],
                            );

                            return FutureBuilder<int>(
                              future: _getSavedCount(widget.post['id']),
                              builder: (context, savedSnapshot) {
                                int savedCount = savedSnapshot.data ?? 0;
                                return GestureDetector(
                                  onTap: () async {
                                    if (!isPremium) {
                                      // ❌ Kein Premium → SnackBar mit Navigation zu Premium
                                      final snackBar = SnackBar(
                                        content: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PremiumPage(
                                                  uid: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            strings.premiumSaveWarning,
                                          ),
                                        ),
                                        backgroundColor: const Color(
                                          0xFF7B4DE8,
                                        ), // lila
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                        duration: const Duration(seconds: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(snackBar);
                                      return;
                                    }

                                    // ✅ Premium → speichern
                                    final userDoc = FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        );

                                    if (isSaved) {
                                      userSavedPosts.remove(widget.post['id']);
                                    } else {
                                      userSavedPosts.add(widget.post['id']);
                                    }

                                    await userDoc.update({
                                      'savedPosts': userSavedPosts,
                                    });
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isSaved
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '$savedCount',
                                        style: TextStyle(
                                          color: widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 14),
                        // Teilen-Button
                        GestureDetector(
                          onTap: () {
                            final postId = widget.post['id'];
                            final link =
                                'https://www.mamatochterontour.de/p/$postId';

                            SharePlus.instance.share(
                              ShareParams(
                                text: 'Schau dir diesen Post an:\n$link',
                                subject: 'MamaTochterOnTour Post',
                              ),
                            );
                          },
                          child: Icon(
                            Icons.ios_share,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),

                    buildLikesText(),

                    // Zeit unter der Row
                    // if (widget.post['createdTime'] != null)
                    //  Padding(
                    //  padding: const EdgeInsets.only(top: 4),
                    //   child: Text(
                    //    _getTimeAgo(widget.post['createdTime']),
                    //      style: TextStyle(color: secondaryColor, fontSize: 12),
                    //    ),
                    //  ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
