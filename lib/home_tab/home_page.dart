import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'feed_app_bar.dart';
import 'feed_post_card.dart';
import 'feed_comments_bottom_seet.dart';
import 'feed_post_service.dart';
import '../erstellen_tab/main_navigation.dart';
import 'feed_loading_skeleton.dart';

import 'inspirations_card.dart';
import 'inspiration_service.dart';
import '../erstellen_tab/upload_post_page.dart';
import '../community_tab/follow_suggestions_page.dart';
import '../profil_tab/premium_verwalten_page.dart';
import '../reisen_tab/tagebuecher/aida_kreuzfahrten_page.dart';
import '../reisen_tab/tagebuecher/fernreisen_page.dart';
import '../reisen_tab/tagebuecher/roadtrip_europa_page.dart';
import '../reisen_tab/tagebuecher/staedtereisen_page.dart';
import '../erstellen_tab/new_travel_diary_page.dart';

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onAddTrip;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onAddTrip,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _searchController = TextEditingController();

  final PostService _postService = PostService();

  bool _isSearching = false;

  String _searchQuery = '';

  final PageController _homeCardsController = PageController();

  late List<Map<String, dynamic>> _inspirationCards;

  @override
  void initState() {
    super.initState();

    _inspirationCards = InspirationService.getCards();
    _inspirationCards.shuffle();
  }

  @override
  void dispose() {
    _searchController.dispose();

    _homeCardsController.dispose();

    super.dispose();
  }

  void _openComments(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (_) {
        return CommentsBottomSheet(
          postId: postId,
          isDarkMode: widget.isDarkMode,
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getNextTrip() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final snapshot = await _firestore
        .collection('trips')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    List<Map<String, dynamic>> upcomingTrips = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final Timestamp timestamp = data['startDate'];

      final startDate = timestamp.toDate();

      final tripDay = DateTime(startDate.year, startDate.month, startDate.day);

      // Nur Reisen ab heute berücksichtigen
      if (!tripDay.isBefore(today)) {
        upcomingTrips.add(data);
      }
    }

    if (upcomingTrips.isEmpty) {
      return null;
    }

    // kleinsten Starttag finden (= nächste Reise)
    upcomingTrips.sort((a, b) {
      final dateA = (a['startDate'] as Timestamp).toDate();
      final dateB = (b['startDate'] as Timestamp).toDate();

      return dateA.compareTo(dateB);
    });

    return upcomingTrips.first;
  }

  bool _matchesSearch(Map<String, dynamic> post) {
    final query = _searchQuery.toLowerCase().trim();

    if (query.isEmpty) return true;

    final caption = (post['caption'] ?? '').toString().toLowerCase();

    final location = (post['location'] ?? '').toString().toLowerCase();

    final username = (post['username'] ?? '').toString().toLowerCase();

    final hashtags =
        (post['hashtag'] as List<dynamic>?)
            ?.map((e) => e.toString().toLowerCase())
            .toList() ??
        [];

    if (caption.contains(query) ||
        location.contains(query) ||
        username.contains(query)) {
      return true;
    }

    for (final tag in hashtags) {
      if (tag.contains(query)) {
        return true;
      }
    }

    return false;
  }

  Widget _buildTripCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),

        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),

        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? const Color(0xFF191522)
              : const Color(0xFFF1ECFF),

          borderRadius: BorderRadius.circular(22),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 8),
            ],

            Text(
              subtitle,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                color: widget.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeCards() {
    final cards = <Widget>[
      FutureBuilder<Map<String, dynamic>?>(
        future: _getNextTrip(),
        builder: (context, snapshot) {
          String title = "Keine Reise geplant";
          String subtitle =
              "Tippe hier, um deine nächste Reise hinzuzufügen ✈️";

          bool canAddTrip = true;

          if (snapshot.hasData && snapshot.data != null) {
            final trip = snapshot.data!;

            final startDate = (trip['startDate'] as Timestamp).toDate();

            final today = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

            final tripDay = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );

            final difference = tripDay.difference(today).inDays;

            final tripTitle = trip['title'] ?? "deine Reise";

            if (difference > 0) {
              canAddTrip = false;

              title = "Deine nächste Reise";

              subtitle =
                  "Noch $difference Tage bis zu deiner Reise nach $tripTitle";
            } else if (difference == 0) {
              canAddTrip = false;

              title = "Heute beginnt dein Abenteuer";

              subtitle =
                  "Deine Reise nach $tripTitle beginnt heute.\nWir wünschen dir viel Spaß!";
            } else {
              title = "Bereit für die nächste Reise?";

              subtitle =
                  "Deine letzte Reise ist vorbei.\nTippe hier und plane deine nächste Reise.";
            }
          }

          return _buildTripCard(
            title: title,
            subtitle: subtitle,
            onTap: canAddTrip ? widget.onAddTrip : () {},
          );
        },
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _homeCardsController,

            itemCount: cards.length,

            onPageChanged: (index) {
              setState(() {});
            },

            itemBuilder: (_, index) {
              return Center(child: cards[index]);
            },
          ),
        ),
      ],
    );
  }

  void _openInspiration(String type) {
    switch (type) {
      // =========================
      // COMMUNITY
      // =========================

      case "create_post":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UploadPostPage()),
        );
        break;

      case "follow":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FollowSuggestionsPage()),
        );
        break;

      case "qa":
        MainNavigationPage.openCommunityQA(context);
        break;

      case "travel_groups":
        MainNavigationPage.openCommunityGroups(context);
        break;

      // =========================
      // REISEPLANUNG
      // =========================

      case "trip_plan":
        widget.onAddTrip();
        break;

      // =========================
      // REISETAGEBÜCHER
      // =========================

      case "create_diary":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewTravelDiaryPage()),
        );
        break;

      case "diary_cruises":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AidaKreuzfahrtenPage(
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
        break;

      case "diary_citytrips":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StaedtereisenPage(
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
        break;

      case "diary_roadtrips":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RoadtripEuropaPage(
              userId: FirebaseAuth.instance.currentUser!.uid,
            ),
          ),
        );
        break;

      case "diary_longdistance":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FernreisenPage(userId: FirebaseAuth.instance.currentUser!.uid),
          ),
        );
        break;

      // =========================
      // PREMIUM
      // =========================

      case "premium":
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PremiumPage(uid: user.uid)),
          );
        }
        break;

      default:
        debugPrint("Keine Navigation für InspirationCard: $type");
    }
  }

  Widget _buildFeedSliver() {
    return StreamBuilder<QuerySnapshot>(
      stream: _postService.getPostsStream(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return FeedLoadingSkeleton(isDarkMode: widget.isDarkMode);
        }

        final posts = snapshot.data!.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .where((post) => _matchesSearch(post))
            .toList();

        if (posts.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text("🌍 Noch keine Reisebeiträge gefunden.")),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // Alle 6 Beiträge eine Inspirationskarte anzeigen
            if (index != 0 && index % 6 == 0) {
              final inspirationIndex = (index ~/ 6) % _inspirationCards.length;

              final card = _inspirationCards[inspirationIndex];

              return InspirationCard(
                emoji: card["emoji"],
                title: card["title"],
                subtitle: card["subtitle"],
                onTap: () {
                  _openInspiration(card["type"]);
                },
                isDarkMode: widget.isDarkMode,
              );
            }

            final postIndex = index - (index ~/ 6);

            final post = posts[postIndex];

            final hearts =
                (post['hearts'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [];

            final userLiked =
                _auth.currentUser != null &&
                hearts.contains(_auth.currentUser!.uid);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: PostCard(
                post: post,
                userLiked: userLiked,
                isDarkMode: widget.isDarkMode,

                toggleLike: () {
                  _postService.toggleLike(
                    post['id'],
                    hearts,
                    _auth.currentUser!.uid,
                    post['uid'],
                  );
                },

                showComments: () {
                  _openComments(post['id']);
                },
              ),
            );
          }, childCount: posts.length + (posts.length ~/ 6)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,

      appBar: FeedAppBar(
        isDarkMode: widget.isDarkMode,

        isSearching: _isSearching,

        searchController: _searchController,

        onSearchChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },

        onSearchToggle: () {
          setState(() {
            _isSearching = !_isSearching;

            if (!_isSearching) {
              _searchQuery = '';
              _searchController.clear();
            }
          });
        },

        title: "Home",
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHomeCards()),

          SliverToBoxAdapter(child: const SizedBox(height: 16)),

          _buildFeedSliver(),
        ],
      ),
    );
  }
}
