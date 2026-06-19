// -------------------- Imports --------------------
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'user_profil_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_post_page.dart';
import 'premium_verwalten_page.dart';
import 'package:video_player/video_player.dart';
import '../../l10n/s.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';

// -------------------- Hauptseite --------------------
class PostDetailPage extends StatelessWidget {
  final String postId;
  final bool userLiked;
  final bool isDarkMode;

  const PostDetailPage({
    super.key,
    required this.postId,
    this.userLiked = false,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        title: Text(
          strings.postDetails,
          style: GoogleFonts.pacifico(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Posts')
                .doc(postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;

              return PostCard(
                post: {'id': snapshot.data!.id, ...data},
                userLiked: userLiked,
                isDarkMode: isDarkMode,
                toggleLike: () async {
                  final userId = FirebaseAuth.instance.currentUser!.uid;

                  await PostService().toggleLike(
                    snapshot.data!.id,
                    List<dynamic>.from(data['hearts'] ?? []),
                    userId,
                    data['uid'],
                  );
                },
                showComments: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CommentsBottomSheet(
                      postId: snapshot.data!.id,
                      isDarkMode: isDarkMode,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

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
    final hearts = widget.post['hearts'] as List<dynamic>? ?? [];
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final isLiked = hearts.contains(userId);

    if (!isLiked) {
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
    final hearts = widget.post['hearts'] as List<dynamic>? ?? [];
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final isLiked = hearts.contains(userId);

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
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
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

class VideoPostPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPostPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPostPlayer> createState() => _VideoPostPlayerState();
}

class _VideoPostPlayerState extends State<VideoPostPlayer> {
  late VideoPlayerController _controller;
  bool _isMuted = true;
  bool _isManuallyPaused = false; // <-- NEU

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0); // stumm
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= 0.5) {
          if (!_controller.value.isPlaying && !_isManuallyPaused) {
            _controller.play(); // automatisch starten
            setState(() {}); // damit Play-Button verschwindet
          }
        } else {
          if (_controller.value.isPlaying) {
            _controller.pause();
            setState(() {
              _isManuallyPaused = false; // Reset manuelles Pausieren
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
              _isManuallyPaused = true; // manuell pausiert
            } else {
              _controller.play();
              _isManuallyPaused = false; // wieder abspielen
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            if (!_controller.value.isPlaying && _isManuallyPaused)
              const Icon(
                Icons.play_circle_fill,
                size: 64,
                color: Colors.white70,
              ), // nur bei manuellem Pausieren
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    _controller.setVolume(_isMuted ? 0 : 1);
                  });
                },
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- CommentsBottomSheet ----------------
class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final bool isDarkMode;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    required this.isDarkMode,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  String? _replyToCommentId;
  String? _replyToUsername;

  // ---------------- Kommentar posten ----------------
  Future<void> _postComment() async {
    final user = _auth.currentUser;

    if (user == null || _commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();

    // 1. Kommentar speichern
    final commentRef = await _firestore.collection('Comments').add({
      'postId': widget.postId,
      'userId': user.uid,
      'text': commentText,
      'createdAt': FieldValue.serverTimestamp(),
      'parentCommentId': _replyToCommentId,
      'likesCount': 0,
      'likedBy': [],
    });

    // 2. Post Kommentar Count
    await _firestore.collection('Posts').doc(widget.postId).update({
      'commentCount': FieldValue.increment(1),
    });

    // 3. 🔥 ACTIVITY LOGIK START
    String? toUserId;

    // CASE A: COMMENT (kein Reply)
    if (_replyToCommentId == null) {
      final postSnap = await _firestore
          .collection('Posts')
          .doc(widget.postId)
          .get();

      toUserId = postSnap.data()?['uid'];
    }
    // CASE B: REPLY
    else {
      final parentCommentSnap = await _firestore
          .collection('Comments')
          .doc(_replyToCommentId)
          .get();

      toUserId = parentCommentSnap.data()?['userId'];
    }

    // 4. Activity speichern (nur wenn nicht eigene Aktion)
    if (toUserId != null && toUserId != user.uid) {
      await _firestore.collection('activities').add({
        'type': _replyToCommentId == null ? 'comment' : 'reply',
        'fromUserId': user.uid,
        'toUserId': toUserId,
        'postId': widget.postId,
        'commentId': commentRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // 5. Reset UI
    _commentController.clear();

    setState(() {
      _replyToCommentId = null;
      _replyToUsername = null;
    });
  }

  // ---------------- Kommentar bearbeiten ----------------
  // ignore: unused_element
  Future<void> _editComment(String commentId, String currentText) async {
    final controller = TextEditingController(text: currentText);
    final strings = S.of(context)!;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editContact),
        content: TextField(controller: controller, maxLines: null),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore.collection('Comments').doc(commentId).update({
                  'text': controller.text.trim(),
                });

                // Prüfen, ob Widget noch im Baum ist
                if (!mounted) return;

                Navigator.pop(context); // schließt das Dialog / Screen
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler beim Speichern: $e')),
                );
              }
            },
            child: Text(strings.saveButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final strings = S.of(context)!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                strings.comments,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 8),

              // ---------------- Kommentare ----------------
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Comments')
                      .where('postId', isEqualTo: widget.postId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: textColor),
                      );
                    }

                    final allComments = snapshot.data!.docs;

                    // Hauptkommentare filtern (parentCommentId == null)
                    final rootComments = allComments.where((c) {
                      final data = c.data() as Map<String, dynamic>;
                      return data['parentCommentId'] == null;
                    }).toList();

                    if (rootComments.isEmpty) {
                      return Center(
                        child: Text(
                          strings.noComments,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: rootComments.length,
                      itemBuilder: (context, index) {
                        final comment = rootComments[index];

                        // Replies filtern
                        final replies = allComments.where((c) {
                          final data = c.data() as Map<String, dynamic>;
                          return data['parentCommentId'] == comment.id;
                        }).toList();

                        return CommentTile(
                          comment: comment,
                          replies: replies,
                          isDarkMode: widget.isDarkMode,
                          onReply: (username) {
                            setState(() {
                              _replyToCommentId = comment.id;
                              _replyToUsername = username;
                            });
                          },
                          onEdit: (commentToEdit) async {
                            final controller = TextEditingController(
                              text: commentToEdit['text'],
                            );
                            await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(strings.editComment),
                                content: TextField(
                                  controller: controller,
                                  maxLines: null,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(strings.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _firestore
                                            .collection('Comments')
                                            .doc(commentToEdit.id)
                                            .update({
                                              'text': controller.text.trim(),
                                            });

                                        if (!context.mounted) {
                                          return;
                                        }
                                        Navigator.pop(
                                          context,
                                        ); // Dialog schließen
                                      } catch (e) {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Fehler beim Speichern: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(strings.save),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDelete: (commentToDelete) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(strings.deleteCommentTitle),
                                content: Text(strings.deleteCommentContent),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(strings.no),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(strings.yes),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _firestore
                                  .collection('Comments')
                                  .doc(commentToDelete.id)
                                  .delete();

                              // Kommentaranzahl im Post-Dokument verringern
                              final postRef = _firestore
                                  .collection('Posts')
                                  .doc(commentToDelete['postId']);
                              await postRef.update({
                                'commentCount': FieldValue.increment(-1),
                              });
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // Antwort abbrechen Button oben über TextField
              if (_replyToUsername != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          strings.replyingTo(_replyToUsername ?? 'User'),
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _replyToCommentId = null;
                            _replyToUsername = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // ---------------- Textfeld ----------------
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            minLines: 1, // startet mit 1 Zeile
                            maxLines: 3, // wächst maximal auf 3 Zeilen
                            keyboardType: TextInputType
                                .multiline, // erlaubt Zeilenumbruch mit Enter
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: _replyToUsername != null
                                  ? strings.writeReplyHint
                                  : strings.writeCommentHint,
                              hintStyle: TextStyle(color: secondaryColor),
                              filled: true,
                              fillColor: widget.isDarkMode
                                  ? Colors.white12
                                  : Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                          onPressed: _postComment,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ), // <-- hier der Abstand unter Textfeld + Button
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- CommentTile ----------------
class CommentTile extends StatelessWidget {
  final QueryDocumentSnapshot comment;
  final List<QueryDocumentSnapshot> replies;
  final bool isDarkMode;
  final Function(String username) onReply;
  final Function(QueryDocumentSnapshot comment) onEdit;
  final Function(QueryDocumentSnapshot comment) onDelete;

  const CommentTile({
    super.key,
    required this.comment,
    required this.replies,
    required this.isDarkMode,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
  });

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return timeago.format(dateTime, locale: 'de'); // vor x Stunden/Minuten
  }

  Future<void> _toggleLike(String commentId, List likedBy) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance
        .collection('Comments')
        .doc(commentId);

    final isLiked = likedBy.contains(uid);

    if (isLiked) {
      await ref.update({
        'likedBy': FieldValue.arrayRemove([uid]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await ref.update({
        'likedBy': FieldValue.arrayUnion([uid]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final strings = S.of(context)!;
    final data = comment.data() as Map<String, dynamic>;

    final likesCount = data['likesCount'] ?? 0;
    final likedBy = List<String>.from(data['likedBy'] ?? []);
    final isLiked = likedBy.contains(currentUserId);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(comment['userId'])
          .get(),
      builder: (context, snapshot) {
        String username = 'User';
        String profilePic = '';

        if (snapshot.hasData && snapshot.data!.data() != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          username = data['username'] ?? 'User';
          profilePic = data['profilePicture'] ?? '';
        }

        final isOwnComment =
            comment['userId'] == FirebaseAuth.instance.currentUser?.uid;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Hauptkommentar ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF8C77FF),
                    backgroundImage: profilePic.isNotEmpty
                        ? NetworkImage(profilePic)
                        : null,
                  ),
                  const SizedBox(width: 8),
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
                                  userId: comment['userId'],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor, // wieder normale Farbe
                            ),
                          ),
                        ),
                        Text(
                          comment['text'],
                          style: TextStyle(color: textColor),
                        ),
                        Row(
                          children: [
                            Text(
                              formatTimestamp(comment['createdAt']),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),

                            // ❤️ LIKE BUTTON
                            GestureDetector(
                              onTap: () => _toggleLike(comment.id, likedBy),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    likesCount.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => onReply(username),
                          child: Text(
                            strings.reply,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PopupMenu für eigene und fremde Kommentare
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        onEdit(comment);
                      } else if (value == 'delete') {
                        onDelete(comment);
                      } else if (value == 'report') {
                        await FirebaseFirestore.instance
                            .collection('commentReports')
                            .add({
                              'reportedBy':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'reportedCommentId': comment.id,
                              'reason': 'Kommentar melden',
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        if (!context.mounted) return; // <-- WICHTIG
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.commentReported)),
                        );
                      }
                    },
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    itemBuilder: (_) => isOwnComment
                        ? [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                strings.editAction,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                strings.deleteButton,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ]
                        : [
                            PopupMenuItem(
                              value: 'report',
                              child: Text(
                                strings.report,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                  ),
                ],
              ),

              // ---------------- Replies ----------------
              if (replies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 8),
                  child: Column(
                    children: replies.map((reply) {
                      final replyData = reply.data() as Map<String, dynamic>;
                      final replyLikes = replyData['likesCount'] ?? 0;
                      final replyLikedBy = List<String>.from(
                        replyData['likedBy'] ?? [],
                      );
                      final isReplyLiked = replyLikedBy.contains(currentUserId);
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(reply['userId'])
                            .get(),
                        builder: (context, snap) {
                          String replyUsername = 'User';
                          String replyPic = '';

                          if (snap.hasData && snap.data!.data() != null) {
                            final data =
                                snap.data!.data() as Map<String, dynamic>;
                            replyUsername = data['username'] ?? 'User';
                            replyPic = data['profilePicture'] ?? '';
                          }

                          final isOwnReply = reply['userId'] == currentUserId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF8C77FF),
                                  backgroundImage: replyPic.isNotEmpty
                                      ? NetworkImage(replyPic)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  OtherUserProfilePage(
                                                    userId: reply['userId'],
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          replyUsername,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: textColor, // normale Farbe
                                          ),
                                        ),
                                      ),
                                      Text(
                                        reply['text'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            formatTimestamp(reply['createdAt']),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => _toggleLike(
                                              reply.id,
                                              replyLikedBy,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isReplyLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: 14,
                                                  color: isReplyLiked
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  replyLikes.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      GestureDetector(
                                        onTap: () => onReply(replyUsername),
                                        child: Text(
                                          strings.reply,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ---------------- PopupMenu für Replies ----------------
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      onEdit(reply);
                                    } else if (value == 'delete') {
                                      onDelete(reply);
                                    } else if (value == 'report') {
                                      await FirebaseFirestore.instance
                                          .collection('commentReports')
                                          .add({
                                            'reportedBy': FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                            'reportedCommentId': reply.id,
                                            'reason': 'Kommentar melden',
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
                                          });

                                      if (!context.mounted) {
                                        return; // <- WICHTIG
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            strings.commentReported,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (_) => isOwnReply
                                      ? [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text(
                                              strings.editAction,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              strings.deleteButton,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : [
                                          PopupMenuItem(
                                            value: 'report',
                                            child: Text(
                                              strings.report,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                  color: isDarkMode
                                      ? Colors.grey[900]
                                      : Colors.white,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPostsStream({int limit = 50}) {
    return _firestore
        .collection('Posts')
        .orderBy('createdTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> toggleLike(
    String postId,
    List<dynamic> hearts,
    String userId,
    String postOwnerId,
  ) async {
    final current = List<String>.from(hearts);

    final isLiked = current.contains(userId);

    if (isLiked) {
      current.remove(userId);
    } else {
      current.add(userId);
    }

    await _firestore.collection('Posts').doc(postId).update({
      'hearts': current,
    });
  }
}
