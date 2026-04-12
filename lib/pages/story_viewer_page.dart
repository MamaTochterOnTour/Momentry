import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_profil_page.dart';
import '../l10n/s.dart'; // Lokalisierte Strings

class StoryViewerPage extends StatefulWidget {
  final String userId;
  final bool isDarkMode;
  final String? startStoryId;

  const StoryViewerPage({
    super.key,
    required this.userId,
    required this.isDarkMode,
    this.startStoryId,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  List<Map<String, dynamic>> stories = [];
  int currentIndex = 0;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  bool mediaLoaded = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadAllData().then((_) => _markStoryAsViewed());
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    await _loadUserData();
    await _loadStories();
    setState(() => isLoading = false);
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get();
    if (doc.exists && doc.data() != null) userData = doc.data()!;
  }

  Future<void> _loadStories() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('stories')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('createdAt', descending: false)
        .get();

    stories = querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    if (widget.startStoryId != null) {
      final startIndex = stories.indexWhere(
        (s) => s['id'] == widget.startStoryId,
      );
      if (startIndex != -1) currentIndex = startIndex;
    }

    if (stories.isNotEmpty) _initCurrentMedia();
  }

  Future<void> _markStoryAsViewed() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || stories.isEmpty) return;

    final currentStory = stories[currentIndex];
    final alreadyViewed = await FirebaseFirestore.instance
        .collection('storyViews')
        .where('storyId', isEqualTo: currentStory['id'])
        .where('userId', isEqualTo: currentUser.uid)
        .get();

    if (alreadyViewed.docs.isEmpty) {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();
      final currentUserData = userDoc.data();
      await FirebaseFirestore.instance.collection('storyViews').add({
        'storyId': currentStory['id'],
        'userId': currentUser.uid,
        'username': currentUserData?['username'] ?? 'User',
        'profilePicture': currentUserData?['profilePicture'] ?? '',
        'viewedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _initCurrentMedia() {
    setState(() => mediaLoaded = false);

    if (stories.isEmpty) return;

    final currentStory = stories[currentIndex];
    final mediaUrl = currentStory['mediaUrl'] as String? ?? '';
    final mediaType = currentStory['mediaType'] as String? ?? 'image';

    if (mediaType == 'video') {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(Uri.parse(mediaUrl))
        ..initialize().then((_) {
          setState(() => mediaLoaded = true);
          _videoController!
            ..setLooping(true)
            ..play();
        });
    } else {
      _videoController?.dispose();
      _videoController = null;
      final image = Image.network(mediaUrl);
      image.image
          .resolve(const ImageConfiguration())
          .addListener(
            ImageStreamListener((_, _) => setState(() => mediaLoaded = true)),
          );
    }
  }

  void _nextStory() {
    if (currentIndex < stories.length - 1) {
      setState(() => currentIndex++);
      _initCurrentMedia();
      _markStoryAsViewed();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _initCurrentMedia();
      _markStoryAsViewed();
    }
  }

  ColorFilter _getFilter(String? filter) {
    switch (filter) {
      case 'B&W':
        return const ColorFilter.mode(Colors.white, BlendMode.saturation);
      case 'Sepia':
        return const ColorFilter.mode(Color(0xFF704214), BlendMode.modulate);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.multiply);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;

    if (isLoading) {
      return Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (stories.isEmpty) {
      return Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        body: Center(
          child: Text(
            strings.noStories, // lokalisiert
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final currentStory = stories[currentIndex];
    final texts = currentStory['texts'] as List<dynamic>? ?? [];
    final createdAt = currentStory['createdAt'] as Timestamp?;

    return GestureDetector(
      onTapDown: (details) {
        final width = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < width / 2) {
          _previousStory();
        } else {
          _nextStory();
        }
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 10) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: mediaLoaded
                  ? ColorFiltered(
                      colorFilter: _getFilter(currentStory['filter']),
                      child:
                          currentStory['mediaType'] == 'video' &&
                              _videoController != null &&
                              _videoController!.value.isInitialized
                          ? VideoPlayer(_videoController!)
                          : Image.network(
                              currentStory['mediaUrl'],
                              fit: BoxFit.cover,
                            ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
            ),
            // Texte Overlay
            for (var t in texts)
              Positioned(
                left: (t['position']['dx'] as num?)?.toDouble() ?? 0,
                top: (t['position']['dy'] as num?)?.toDouble() ?? 0,
                child: Text(
                  t['text'] ?? '',
                  style: GoogleFonts.getFont(
                    t['font'] ?? 'Roboto',
                    fontSize: (t['size'] as num?)?.toDouble() ?? 24,
                    color: Color((t['color'] as int?) ?? 0xFFFFFFFF),
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            // Story Progress + Profil
            if (mediaLoaded)
              Column(
                children: [
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: stories
                          .asMap()
                          .entries
                          .map(
                            (e) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                height: 4,
                                decoration: BoxDecoration(
                                  color: e.key <= currentIndex
                                      ? Colors.white
                                      : Colors.white38,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OtherUserProfilePage(userId: widget.userId),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: userData?['profilePicture'] != null
                                ? NetworkImage(userData!['profilePicture'])
                                : null,
                            backgroundColor: Colors.blueAccent,
                            child: userData?['profilePicture'] == null
                                ? Text(
                                    avatarLetter(userData?['username']),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData?['username'] ?? 'User',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (createdAt != null)
                                Text(
                                  formatTimestamp(createdAt, strings),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String avatarLetter(String? username) {
    if (username == null || username.isEmpty) return 'U';
    return username[0].toUpperCase();
  }

  String formatTimestamp(Timestamp timestamp, S strings) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return strings.justNow;
    if (diff.inMinutes < 60) return strings.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return strings.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return strings.daysAgo(diff.inDays);

    return DateFormat('dd.MM.yyyy').format(date);
  }
}
