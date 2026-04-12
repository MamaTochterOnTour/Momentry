import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profil_page.dart';
// ignore: unused_import
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: unused_import
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'story_viewer_page.dart';
import 'edit_post_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'premium_verwalten_page.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../l10n/s.dart';
import 'package:share_plus/share_plus.dart';

enum FeedFilter { all, friends, favorites }

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
  // ignore: unused_field
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  // Für Antworten
  final Map<String, TextEditingController> _answerControllers = {};

  FeedFilter _currentFilter = FeedFilter.all;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  // Hilfsfunktion für Premium-Snackbar

  // ---------------- Packliste ----------------

  // ---------------- Countdown ----------------

  // ---------------- Budget ----------------

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

  Stream<QuerySnapshot> _getPostsStream({int limit = 50}) {
    return _firestore
        .collection('Posts')
        .orderBy('createdTime', descending: true)
        .limit(limit)
        .snapshots();
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

  bool _matchesSearchQuestion(
    Map<String, dynamic> questionData,
    List<Map<String, dynamic>> answers,
  ) {
    final query = widget.searchQuery.toLowerCase();
    if (query.isEmpty) return true;

    final questionText = (questionData['question'] ?? '')
        .toString()
        .toLowerCase();

    // Überprüfe, ob die Frage selbst die Suchanfrage enthält
    if (questionText.contains(query)) return true;

    // Überprüfe, ob irgendeine Antwort die Suchanfrage enthält
    for (var answer in answers) {
      final answerText = (answer['answer'] ?? '').toString().toLowerCase();
      if (answerText.contains(query)) return true;
    }

    return false;
  }

  void _toggleLike(String postId, List<dynamic>? hearts) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final currentHearts = hearts ?? [];
    if (currentHearts.contains(userId)) {
      currentHearts.remove(userId);
    } else {
      currentHearts.add(userId);
    }

    await _firestore.collection('Posts').doc(postId).update({
      'hearts': currentHearts,
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            toggleLike: () => _toggleLike(post['id'], hearts),
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
          stream: _getPostsStream(),
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

  Widget buildStoryList({List<String>? filterUIDs}) {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('stories')
          .where('createdAt', isGreaterThan: Timestamp.fromDate(cutoff))
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final stories = snapshot.data!.docs;
        List<String> uids = filterUIDs != null
            ? stories
                  .map((s) => s['userId'] as String)
                  .where((uid) => filterUIDs.contains(uid))
                  .toSet()
                  .toList()
            : stories.map((s) => s['userId'] as String).toSet().toList();

        if (uids.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('Users').doc(uid).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData ||
                      userSnapshot.data!.data() == null) {
                    return const SizedBox.shrink();
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final profilePic = userData['profilePicture'] ?? '';
                  final username = userData['username'] ?? 'User';

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        final storyDoc = stories.firstWhere(
                          (s) => s['userId'] == uid,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoryViewerPage(
                              userId: storyDoc['userId'],
                              isDarkMode: _isDarkMode,
                              startStoryId: storyDoc.id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: profilePic.isNotEmpty
                                ? NetworkImage(profilePic)
                                : null,
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 70,
                            child: Text(
                              username,
                              style: TextStyle(
                                fontSize: 12,
                                color: _isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? Colors.black : Colors.white;
    final secondaryColor = _isDarkMode ? Colors.white70 : Colors.black54;
    final strings = S.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: _isDarkMode ? Colors.black : Colors.white,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: _isDarkMode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,

              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: strings.searchHint,
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    )
                  : Text(
                      strings.tipsAndFavorites,
                      style: GoogleFonts.pacifico(
                        fontSize: 26,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),

              actions: [
                IconButton(
                  icon: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
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
                ),
              ],
            ),
            body: Column(
              children: [
                TabBar(
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: secondaryColor,
                  indicatorColor: Colors.blueAccent,
                  tabs: [
                    GestureDetector(
                      onTapDown: (details) async {
                        final selected = await showMenu<FeedFilter>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                          ),
                          items: [
                            PopupMenuItem(
                              value: FeedFilter.all,
                              child: Text(strings.allFilter),
                            ),
                            PopupMenuItem(
                              value: FeedFilter.friends,
                              child: Text(strings.feedFilterFriends),
                            ),
                            PopupMenuItem(
                              value: FeedFilter.favorites,
                              child: Text(strings.feedFilterFavorites),
                            ),
                          ],
                        );

                        if (selected != null) {
                          setState(() => _currentFilter = selected);
                        }
                      },
                      child: Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentFilter == FeedFilter.all
                                  ? strings.allFilter
                                  : _currentFilter == FeedFilter.friends
                                  ? strings.feedFilterFriends
                                  : strings.feedFilterFavorites,
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const Tab(text: 'Q&A'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Feed-Tab
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          if (_currentFilter != FeedFilter.favorites)
                            _currentFilter == FeedFilter.friends
                                ? FutureBuilder<List<String>>(
                                    future: _getFollowingUIDs(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox.shrink();
                                      }
                                      return buildStoryList(
                                        filterUIDs: snapshot.data,
                                      );
                                    },
                                  )
                                : buildStoryList(),
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
                      Column(
                        children: [
                          // Q&A List
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Questions')
                                  .orderBy('createdTime', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final questions = snapshot.data!.docs;
                                if (questions.isEmpty) {
                                  return Center(
                                    child: Text(
                                      strings.noQuestionsYet,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  itemCount: questions.length,
                                  itemBuilder: (context, index) {
                                    final questionDoc = questions[index];
                                    final questionData =
                                        questionDoc.data()!
                                            as Map<String, dynamic>;
                                    final questionId = questionDoc.id;
                                    final questionUid =
                                        questionData['userId'] as String;
                                    final questionUsername =
                                        questionData['username'] ?? 'User';
                                    final questionProfilePic =
                                        questionData['profilePicture'];

                                    // Antworten laden
                                    return FutureBuilder<QuerySnapshot>(
                                      future: _firestore
                                          .collection('Questions')
                                          .doc(questionId)
                                          .collection('Answers')
                                          .get(),
                                      builder: (context, answerSnapshot) {
                                        final answers =
                                            answerSnapshot.data?.docs
                                                .map(
                                                  (doc) =>
                                                      doc.data()!
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >,
                                                )
                                                .toList() ??
                                            [];

                                        // 🔍 Prüfen, ob Frage oder Antwort die Suchanfrage enthält
                                        if (!_matchesSearchQuestion(
                                          questionData,
                                          answers,
                                        )) {
                                          return const SizedBox.shrink(); // nicht anzeigen, wenn kein Treffer
                                        }

                                        // hier bleibt dein bestehender Container/ExpansionTile unverändert
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _isDarkMode
                                                ? Colors.grey[850]
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _isDarkMode
                                                    ? Colors.black54
                                                    : Colors.grey.withAlpha(
                                                        (0.2 * 255).round(),
                                                      ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              if (questionUid ==
                                                  _auth.currentUser?.uid) {
                                                _showEditDeleteBottomSheet(
                                                  questionId: questionId,
                                                  oldText:
                                                      questionData['question'],
                                                  isQuestion: true,
                                                );
                                              }
                                            },
                                            child: ExpansionTile(
                                              key: ValueKey(questionId),
                                              onExpansionChanged: (expanded) {},
                                              tilePadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              childrenPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              expandedCrossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              title: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    backgroundImage:
                                                        questionProfilePic !=
                                                            null
                                                        ? NetworkImage(
                                                            questionProfilePic,
                                                          )
                                                        : null,
                                                    child:
                                                        questionProfilePic ==
                                                            null
                                                        ? Text(
                                                            avatarLetter(
                                                              questionUsername,
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          )
                                                        : null,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          questionUsername,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: _isDarkMode
                                                                ? Colors.white
                                                                : Colors
                                                                      .black87,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          questionData['question'] ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: _isDarkMode
                                                                ? Colors.white70
                                                                : Colors
                                                                      .black87,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          formatTimestamp(
                                                            questionData['createdTime'],
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: _isDarkMode
                                                                ? Colors.white38
                                                                : Colors
                                                                      .black45,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                ..._buildAnswersStyled(
                                                  questionId,
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                              minHeight: 40,
                                                              maxHeight: 150,
                                                            ),
                                                        child: TextField(
                                                          controller:
                                                              _answerControllers
                                                                  .putIfAbsent(
                                                                    questionId,
                                                                    () =>
                                                                        TextEditingController(),
                                                                  ),
                                                          minLines: 1,
                                                          maxLines: 3,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          style: TextStyle(
                                                            color: _isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                          decoration: InputDecoration(
                                                            hintText: strings
                                                                .writeAnswer,
                                                            hintStyle: TextStyle(
                                                              color: _isDarkMode
                                                                  ? Colors
                                                                        .white54
                                                                  : Colors
                                                                        .black38,
                                                            ),
                                                            filled: true,
                                                            fillColor:
                                                                _isDarkMode
                                                                ? Colors.white12
                                                                : Colors
                                                                      .grey[200],
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                            ),
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 12,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.send,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                      onPressed: () =>
                                                          _postAnswer(
                                                            questionId,
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
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  // BottomSheet-Funktion für Edit/Delete, Dark Mode kompatibel
  void _showEditDeleteBottomSheet({
    required String questionId,
    required String oldText,
    required bool isQuestion, // true = Frage, false = Antwort
    String? answerId,
  }) {
    final strings = S.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                strings.edit,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (isQuestion) {
                  _editQuestion(questionId, oldText);
                } else if (answerId != null) {
                  _editAnswer(questionId, answerId, oldText);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(strings.delete, style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                if (isQuestion) {
                  await _deleteQuestion(
                    questionId,
                  ); // inkl. alle Antworten löschen
                } else if (answerId != null) {
                  await _deleteAnswer(questionId, answerId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswersStyled(String questionId) {
    return [
      StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Questions')
            .doc(questionId)
            .collection('Answers')
            .orderBy('createdTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final answers = snapshot.data!.docs;

          return Column(
            children: answers.map((doc) {
              final answerData = doc.data()! as Map<String, dynamic>;
              final answerId = doc.id;
              final answerUid = answerData['userId'] as String;
              final answerText = answerData['answer'] ?? '';
              final answerUsername = answerData['username'] ?? 'User';
              final answerProfilePic = answerData['profilePicture'] ?? '';

              return GestureDetector(
                onLongPress: () {
                  if (answerUid == _auth.currentUser?.uid) {
                    _showEditDeleteBottomSheet(
                      questionId: questionId,
                      oldText: answerText,
                      isQuestion: false,
                      answerId: answerId,
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _isDarkMode
                            ? Colors.black38
                            : Colors.grey.withAlpha((0.2 * 255).round()),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: answerProfilePic.isNotEmpty
                            ? NetworkImage(answerProfilePic)
                            : null,
                        child: answerProfilePic.isEmpty
                            ? Text(
                                avatarLetter(answerUsername),
                                style: const TextStyle(color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              answerUsername,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              answerText,
                              style: TextStyle(
                                color: _isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatTimestamp(answerData['createdTime']),
                              style: TextStyle(
                                fontSize: 12,
                                color: _isDarkMode
                                    ? Colors.white38
                                    : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    ];
  }

  Future<void> _postAnswer(String questionId) async {
    final controller = _answerControllers[questionId];
    if (controller == null || controller.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('Users').doc(user.uid).get();
    final username = (userDoc.data()?['username'] ?? 'User') as String;

    await _firestore
        .collection('Questions')
        .doc(questionId)
        .collection('Answers')
        .add({
          'answer': controller.text.trim(),
          'userId': user.uid,
          'username': username,
          'createdTime': FieldValue.serverTimestamp(),
        });

    controller.clear();
  }

  String avatarLetter(String? username) {
    if (username == null || username.isEmpty) return 'U';
    return username[0].toUpperCase();
  }

  // Frage bearbeiten
  void _editQuestion(String questionId, String oldText) {
    final controller = TextEditingController(text: oldText);
    final strings = S.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editQuestion),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(hintText: strings.enterNewQuestion),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection('Questions').doc(questionId).update({
                'question': controller.text.trim(),
              });

              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  // Frage löschen + alle Antworten löschen
  Future<void> _deleteQuestion(String questionId) async {
    final questionRef = _firestore.collection('Questions').doc(questionId);

    // 1. Alle Antworten der Frage löschen
    final answersSnapshot = await questionRef.collection('Answers').get();
    for (var doc in answersSnapshot.docs) {
      await doc.reference.delete();
    }

    // 2. Danach die Frage selbst löschen
    await questionRef.delete();
  }

  // Antwort bearbeiten
  void _editAnswer(String questionId, String answerId, String oldText) {
    final controller = TextEditingController(text: oldText);
    final strings = S.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editReplyTitle),
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(hintText: strings.enterNewReply),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestore
                  .collection('Questions')
                  .doc(questionId)
                  .collection('Answers')
                  .doc(answerId)
                  .update({'answer': controller.text.trim()});

              if (!mounted) return; // <-- hier
              Navigator.pop(context);
            },
            child: Text(strings.save),
          ),
        ],
      ),
    );
  }

  // Antwort löschen
  Future<void> _deleteAnswer(String questionId, String answerId) async {
    await _firestore
        .collection('Questions')
        .doc(questionId)
        .collection('Answers')
        .doc(answerId)
        .delete();
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
            VideoPlayer(_controller),
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

class MySearchDelegate extends SearchDelegate<String> {
  final String initialQuery;

  MySearchDelegate({required this.initialQuery}) {
    query = initialQuery; // Startwert setzen
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Suche abbrechen
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Hier gibst du das Ergebnis zurück
    // z.B. einfach den String
    return Center(child: Text('Suchergebnis für "$query"'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Vorschläge während der Eingabe
    final suggestions = query.isEmpty
        ? []
        : ['Beispiel 1', 'Beispiel 2', 'Beispiel 3']
              .where((s) => s.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
