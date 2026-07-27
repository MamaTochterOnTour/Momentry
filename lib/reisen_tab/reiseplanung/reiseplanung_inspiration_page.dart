import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../erstellen_tab/post_detail_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dark_mode_provider.dart';

import 'package:google_fonts/google_fonts.dart';

class TripInspirationPage extends ConsumerWidget {
  final String tripId;

  const TripInspirationPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeAsync = ref.watch(darkModeProvider);

    return isDarkModeAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),

      data: (isDarkMode) {
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final purple = Colors.deepPurple;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,

          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,

            iconTheme: IconThemeData(color: textColor),

            centerTitle: true,

            title: Text(
              "Inspiration",
              style: GoogleFonts.pacifico(color: textColor, fontSize: 26),
            ),
          ),

          body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('trips')
                .doc(tripId)
                .snapshots(),

            builder: (context, tripSnap) {
              if (!tripSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tripData = tripSnap.data!.data() as Map<String, dynamic>?;

              final List savedPosts = tripData?['savedPosts'] ?? [];

              if (savedPosts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.favorite_border, size: 70, color: purple),

                      const SizedBox(height: 20),

                      Text(
                        "Noch keine Inspiration gespeichert",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Speichere Beiträge,\ndie dich für deine Reise inspirieren.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadPosts(savedPosts),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final posts = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(6),

                    itemCount: posts.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),

                    itemBuilder: (context, index) {
                      final post = posts[index];

                      final List mediaUrls = post['mediaUrls'] ?? [];
                      final List mediaTypes = post['mediaTypes'] ?? [];
                      final List thumbnailUrls = post['thumbnailUrls'] ?? [];

                      String? image;

                      bool isVideo = false;

                      if (mediaUrls.isNotEmpty) {
                        final type = mediaTypes.isNotEmpty
                            ? mediaTypes.first
                            : "image";

                        if (type == "video") {
                          isVideo = true;

                          if (thumbnailUrls.isNotEmpty) {
                            image = thumbnailUrls.first;
                          }
                        } else {
                          image = mediaUrls.first;
                        }
                      } else {
                        image = post['image'];
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => PostDetailPage(
                                postId: post['id'],

                                isDarkMode: isDarkMode,
                              ),
                            ),
                          );
                        },

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Stack(
                            children: [
                              if (image != null)
                                Positioned.fill(
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Container(color: purple),

                              if (isVideo)
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
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _loadPosts(List ids) async {
    List<Map<String, dynamic>> posts = [];

    for (final id in ids) {
      final snap = await FirebaseFirestore.instance
          .collection('Posts')
          .doc(id)
          .get();

      if (snap.exists) {
        posts.add({'id': snap.id, ...snap.data()!});
      }
    }

    return posts;
  }
}
