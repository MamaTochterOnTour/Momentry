import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../feed/post_card.dart';
import 'package:intl/intl.dart';
import '../feed/feed_filter.dart';
import '../feed/feed_app_bar.dart';
import '../../l10n/s.dart';
import '../feed/feed_tab_bar.dart';
import '../feed/qa_tab.dart';
import '../feed/post_service.dart';
import '../feed/comments_bottom_seet.dart';

class FeedPage extends StatefulWidget {
  final String? userId;
  final String searchQuery;
  final bool isDarkMode;

  const FeedPage({
    super.key,
    this.userId,
    this.searchQuery = '',
    required this.isDarkMode,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PostService _postService = PostService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  FeedFilter _currentFilter = FeedFilter.all;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final doc = await _firestore.collection('Users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        _isDarkMode = doc.data()?['isDarkMode'] ?? false;
      });
    }
  }

  Future<List<String>> _getFollowingUIDs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final querySnap = await _firestore
        .collection('Follow')
        .where('followerId', isEqualTo: userId)
        .get();

    return querySnap.docs.map((doc) => doc['followingId'] as String).toList();
  }

  bool _matchesSearch(Map<String, dynamic> postData) {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) return true;

    final caption = (postData['caption'] ?? '').toString().toLowerCase();
    final location = (postData['location'] ?? '').toString().toLowerCase();

    final hashtags =
        (postData['hashtag'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];

    // Suche nach Teilwörtern in Caption & Location
    if (caption.contains(query) || location.contains(query)) {
      return true;
    }

    // Suche nach Teilwörtern in Hashtags
    for (var tag in hashtags) {
      if (tag.contains(query)) return true;
    }

    return false;
  }

  void _showCommentsSheet(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          CommentsBottomSheet(postId: postId, isDarkMode: _isDarkMode),
    );
  }

  Widget _buildPostList(List<Map<String, dynamic>> posts) {
    return RefreshIndicator(
      onRefresh: () async => setState(() {}),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 6,
          bottom: 100, // 👈 sorgt dafür, dass der letzte Post höher sitzt
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final hearts =
              (post['hearts'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];
          final userLiked =
              _auth.currentUser != null &&
              hearts.contains(_auth.currentUser!.uid);

          return PostCard(
            post: post,
            userLiked: userLiked,
            isDarkMode: _isDarkMode,
            toggleLike: () => _postService.toggleLike(
              post['id'],
              hearts,
              _auth.currentUser!.uid,
              post['uid'], // 👈 DAS FEHLT
            ),
            showComments: () => _showCommentsSheet(post['id']),
          );
        },
      ),
    );
  }

  Widget buildFeedStream({
    required bool showOnlyFriends,
    bool showFavorites = false,
  }) {
    final userId = _auth.currentUser?.uid;

    return FutureBuilder<List<String>>(
      future: showOnlyFriends ? _getFollowingUIDs() : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final followingUIDs = snapshot.data ?? [];
        final strings = S.of(context)!;

        return StreamBuilder<QuerySnapshot>(
          stream: _postService.getPostsStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Map<String, dynamic>> posts = snapshot.data!.docs
                .map(
                  (doc) => {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  },
                )
                .where((post) {
                  if (!_matchesSearch(post)) {
                    return false;
                  }

                  if (showFavorites) {
                    return false;
                  }

                  if (showOnlyFriends) {
                    return followingUIDs.contains(post['uid']);
                  }

                  return true;
                })
                .toList();

            if (showFavorites && userId != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('Users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData ||
                      userSnapshot.data!.data() == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final savedPostIds =
                      (userData['savedPosts'] as List<dynamic>?)
                          ?.cast<String>() ??
                      [];

                  // Favorite-Posts filtern
                  final favoritePosts = snapshot.data!.docs
                      .map(
                        (doc) => {
                          'id': doc.id,
                          ...doc.data() as Map<String, dynamic>,
                        },
                      )
                      .where(
                        (post) =>
                            savedPostIds.contains(post['id']) &&
                            _matchesSearch(post),
                      )
                      .toList();

                  if (favoritePosts.isEmpty) {
                    return Center(child: Text(strings.noPostsFound));
                  }

                  return _buildPostList(favoritePosts);
                },
              );
            }

            if (posts.isEmpty) {
              return Center(child: Text(strings.noPostsFound));
            }

            return _buildPostList(posts);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? Colors.black : Colors.white;
    final strings = S.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: FeedAppBar(
              isDarkMode: _isDarkMode,
              isSearching: _isSearching,
              searchController: _searchController,
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onSearchToggle: () {
                setState(() {
                  if (_isSearching) {
                    _isSearching = false;
                    _searchQuery = '';
                    _searchController.clear();
                  } else {
                    _isSearching = true;
                  }
                });
              },
              title: strings.tipsAndFavorites,
            ),
            body: Column(
              children: [
                FeedTabBar(
                  currentFilter: _currentFilter,
                  allText: strings.allFilter,
                  friendsText: strings.feedFilterFriends,
                  favoritesText: strings.feedFilterFavorites,
                  onFilterChanged: (value) {
                    setState(() {
                      _currentFilter = value;
                    });
                  },
                  onQATap: () {
                    // später Q&A Action
                  },
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Feed-Tab
                      Column(
                        children: [
                          Expanded(
                            child: buildFeedStream(
                              showOnlyFriends:
                                  _currentFilter == FeedFilter.friends,
                              showFavorites:
                                  _currentFilter == FeedFilter.favorites,
                            ),
                          ),
                        ],
                      ),
                      // --- Q&A Tab ---
                      QATab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String avatarLetter(String? username) {
    if (username == null || username.isEmpty) return 'U';
    return username[0].toUpperCase();
  }

  // Funktion für "vor x Minuten/Stunden/Tagen" oder Datum
  String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime time;
    if (timestamp is Timestamp) {
      time = timestamp.toDate();
    } else if (timestamp is DateTime) {
      time = timestamp;
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(time);

    final strings = S.of(context)!; // generierte Strings

    if (difference.inMinutes < 1) {
      return strings.timeAgoJustNow;
    }
    if (difference.inMinutes < 60) {
      return strings.timeAgoMinutes(difference.inMinutes);
    }
    if (difference.inHours < 24) {
      return strings.timeAgoHours(difference.inHours);
    }
    if (difference.inDays < 7) {
      return strings.timeAgoDays(difference.inDays);
    }

    return DateFormat('dd.MM.yyyy').format(time);
  }
}
