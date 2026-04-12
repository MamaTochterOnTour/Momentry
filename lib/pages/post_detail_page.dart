// -------------------- Imports --------------------
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'user_profil_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_post_page.dart';
import 'package:logger/logger.dart';
import 'premium_verwalten_page.dart';
import 'package:video_player/video_player.dart';
import '../../l10n/s.dart';
import 'package:share_plus/share_plus.dart';

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
    final logger = Logger();
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
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Posts')
                .doc(postId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;

              return PostCard(
                post: {'id': snapshot.data!.id, ...data},
                userLiked: userLiked,
                isDarkMode: isDarkMode,
                toggleLike: () {
                  logger.i("Toggle Like");
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

    // Fallback für alte Posts
    if ((mediaUrls == null || mediaUrls.isEmpty) &&
        widget.post['image'] != null) {
      final url = widget.post['image'];
      final type = widget.post['mediaType'] ?? 'image';
      return AspectRatio(
        aspectRatio: 3 / 4,
        child: GestureDetector(
          onDoubleTap: _onDoubleTapLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              type == 'video'
                  ? VideoPostPlayer(videoUrl: url)
                  : Image.network(url, fit: BoxFit.cover),
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
      );
    }

    // Keine Medien vorhanden
    if (mediaUrls == null || mediaUrls.isEmpty) return const SizedBox.shrink();

    // Einzel-Medium
    if (mediaUrls.length == 1) {
      final url = mediaUrls[0];
      final type = mediaTypes != null && mediaTypes.isNotEmpty
          ? mediaTypes[0]
          : 'image';
      return AspectRatio(
        aspectRatio: 3 / 4,
        child: GestureDetector(
          onDoubleTap: _onDoubleTapLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              type == 'video'
                  ? VideoPostPlayer(videoUrl: url)
                  : Image.network(url, fit: BoxFit.cover),
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
      );
    }

    // Mehrere Medien → PageView + Punkte + Double-Tap
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: mediaUrls.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final url = mediaUrls[index];
              final type = mediaTypes != null && index < mediaTypes.length
                  ? mediaTypes[index]
                  : 'image';

              return GestureDetector(
                onDoubleTap: _onDoubleTapLike,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    type == 'video'
                        ? VideoPostPlayer(videoUrl: url)
                        : Image.network(url, fit: BoxFit.cover),
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
              );
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

  String _getTimeAgo(Timestamp createdTime) {
    final now = DateTime.now();
    final date = createdTime.toDate();
    final diff = now.difference(date);

    if (diff.inDays >= 7) {
      return '${date.day}.${date.month}.${date.year}';
    } else if (diff.inDays >= 1) {
      return 'vor ${diff.inDays} Tag${diff.inDays > 1 ? 'en' : ''}';
    } else if (diff.inHours >= 1) {
      return 'vor ${diff.inHours} Stunde${diff.inHours > 1 ? 'n' : ''}';
    } else if (diff.inMinutes >= 1) {
      return 'vor ${diff.inMinutes} Minute${diff.inMinutes > 1 ? 'n' : ''}';
    } else {
      return 'gerade eben';
    }
  }

  void _toggleLike() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> hearts = List.from(widget.post['hearts'] ?? []);

    setState(() {
      if (hearts.contains(currentUserId)) {
        hearts.remove(currentUserId);
      } else {
        hearts.add(currentUserId);
      }
      widget.post['hearts'] =
          hearts; // lokal aktualisieren, damit UI sofort reagiert
    });

    // Firestore aktualisieren
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(widget.post['id'])
        .update({'hearts': hearts});
  }

  // Funktion zum Öffnen des Likes-BottomSheets
  void _showLikesSheet(List<dynamic> hearts) {
    final isDarkMode = widget.isDarkMode;
    final strings = S.of(context)!;
    final firstUsername =
        'User'; // Platzhalter, hier solltest du den echten Usernamen holen
    final othersCount = hearts.length - 1;

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
                  strings.likesCount(
                    firstUsername,
                    othersCount,
                  ), // zwei Argumente!
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
                                builder: (_) => OtherUserProfilePage(
                                  userId: uid,
                                  isDarkMode: widget.isDarkMode,
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

  // -------------------- Gefällt mir Text --------------------
  Widget buildLikesText() {
    final strings = S.of(context)!;
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

        final text = strings.likesCount(firstUsername, othersCount);

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
    _toggleLike(); // Herz wird aktualisiert + Firestore
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
                                    userId: widget
                                        .post['uid'], // DIE UID DES POSTS → PROFIL DES USERS
                                    isDarkMode: widget.isDarkMode,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              widget.post['username'] ?? 'User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .blueAccent, // Optional: Macht klar, dass es klickbar ist
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
                              await FirebaseFirestore.instance
                                  .collection('Posts')
                                  .doc(widget.post['id'])
                                  .delete();
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

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(strings.postReported)),
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (_) => isOwnPost
                          ? [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(strings.editPost),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(strings.deletePost),
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

                // Post Media (Bild oder Video) mit Herz-Animation
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
                                  text: ' … mehr lesen',
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
                          onTap: _toggleLike, // <-- vorher widget.toggleLike
                          child: Icon(
                            (widget.post['hearts'] as List<dynamic>?)?.contains(
                                      FirebaseAuth.instance.currentUser!.uid,
                                    ) ??
                                    false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                (widget.post['hearts'] as List<dynamic>?)
                                        ?.contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid,
                                        ) ??
                                    false
                                ? Colors.red
                                : Colors.grey,
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
                                          child: Text(strings.premiumSavePost),
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
                    if (widget.post['createdTime'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _getTimeAgo(widget.post['createdTime']),
                          style: TextStyle(color: secondaryColor, fontSize: 12),
                        ),
                      ),
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
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true)
      ..setVolume(1.0);
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller),

          if (!_controller.value.isPlaying)
            const Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),

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

    await _firestore.collection('Comments').add({
      'postId': widget.postId,
      'userId': user.uid,
      'text': _commentController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'parentCommentId': _replyToCommentId,
    });

    // Kommentaranzahl im Post-Dokument erhöhen
    final postRef = _firestore.collection('Posts').doc(widget.postId);
    await postRef.update({'commentCount': FieldValue.increment(1)});

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
        title: Text(strings.editComment),
        content: TextField(controller: controller, maxLines: null),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
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
                  SnackBar(content: Text('${strings.saveError} $e')),
                );
              }
            },
            child: Text(strings.save),
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

                                        // DialogContext verwenden, um den Dialog sicher zu schließen
                                        if (!context.mounted) return;
                                        Navigator.pop(
                                          context,
                                        ); // oder Navigator.pop(dialogContext) wenn du den Builder-Context benutzt
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${strings.saveError} $e',
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
                                title: Text(strings.deleteComment),
                                content: Text(strings.deleteCommentConfirm),
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
                          '${strings.replyTo} $_replyToUsername',
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
                                  ? strings.writeReply
                                  : strings.writeComment,
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

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final strings = S.of(context)!;

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
                                  isDarkMode: isDarkMode,
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
                        Text(
                          formatTimestamp(comment['createdAt']),
                          style: TextStyle(color: Colors.grey, fontSize: 11),
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
                        // Kommentar melden
                        await FirebaseFirestore.instance
                            .collection('commentReports')
                            .add({
                              'reportedBy':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'reportedCommentId': comment.id,
                              'reason': 'Kommentar melden',
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.reportedSuccess)),
                        );
                      }
                    },
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    itemBuilder: (_) => isOwnComment
                        ? [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                strings.editComment,
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
                                strings.deleteComment,
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
                                                    isDarkMode: isDarkMode,
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
                                      Text(
                                        formatTimestamp(reply['createdAt']),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
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

                                      if (!context.mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            strings.reportedSuccess,
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
                                              strings.editComment,
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
                                              strings.deleteComment,
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
