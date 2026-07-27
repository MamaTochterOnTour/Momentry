import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/dark_mode_provider.dart';

import '../../erstellen_tab/post_detail_page.dart';
import '../../profil_tab/travel_diary_page.dart';

class TripMemoriesPage extends ConsumerWidget {
  final String tripId;
  final bool showAppBar;

  const TripMemoriesPage({
    super.key,
    required this.tripId,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(darkModeProvider).value ?? false;

    final background = dark ? Colors.black : Colors.white;
    final textColor = dark ? Colors.white : Colors.black;
    final secondary = dark ? Colors.white70 : Colors.black54;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .snapshots(),

      builder: (context, tripSnap) {
        if (!tripSnap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final tripData = tripSnap.data!.data() as Map<String, dynamic>?;

        if (tripData == null) {
          return const Scaffold(
            body: Center(child: Text("Reise nicht gefunden")),
          );
        }

        final title = tripData['title'] ?? "Reise";

        final start = (tripData['startDate'] as Timestamp?)?.toDate();

        final end = (tripData['endDate'] as Timestamp?)?.toDate();

        return Scaffold(
          backgroundColor: background,

          appBar: showAppBar
              ? AppBar(
                  backgroundColor: background,
                  elevation: 0,
                  centerTitle: true,

                  title: Text(
                    title,
                    style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
                  ),
                )
              : null,

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const SizedBox(height: 10),

                // Zeitraum
                if (start != null && end != null)
                  Text(
                    "${_formatDate(start)} – ${_formatDate(end)}",

                    style: TextStyle(color: secondary, fontSize: 16),
                  ),

                const SizedBox(height: 24),

                // Statistik Bereich
                _buildStatistics(tripId, start, end, textColor, secondary),

                const SizedBox(height: 35),

                // Platzhalter für Timeline
                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Reise-Timeline",

                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildTimeline(tripId, start, end, textColor, secondary, dark),
              ],
            ),
          ),
        );
      },
    );
  }
}

String _formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}."
      "${date.month.toString().padLeft(2, '0')}."
      "${date.year}";
}

int _calculateDays(DateTime start, DateTime end) {
  return end.difference(start).inDays + 1;
}

List<DateTime> _generateDays(DateTime start, DateTime end) {
  final days = <DateTime>[];

  DateTime current = start;

  while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
    days.add(current);

    current = current.add(const Duration(days: 1));
  }

  return days;
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final Color textColor;
  final Color secondary;

  const _StatItem({
    required this.number,
    required this.label,
    required this.textColor,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,

          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(label, style: TextStyle(color: secondary, fontSize: 13)),
      ],
    );
  }
}

Widget _buildTimeline(
  String tripId,
  DateTime? start,
  DateTime? end,
  Color textColor,
  Color secondary,
  bool dark,
) {
  if (start == null || end == null) {
    return const SizedBox();
  }

  final days = _generateDays(start, end);

  return Column(
    children: List.generate(days.length, (index) {
      final date = days[index];

      return Container(
        margin: const EdgeInsets.only(bottom: 24),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(width: 0),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: dark ? Colors.white10 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tag ${index + 1}",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatDate(date),
                      style: TextStyle(color: secondary, fontSize: 13),
                    ),

                    const SizedBox(height: 16),

                    _buildDayContent(
                      tripId,
                      index + 1,
                      textColor,
                      secondary,
                      dark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }),
  );
}

Widget _buildDayContent(
  String tripId,
  int dayNumber,
  Color textColor,
  Color secondary,
  bool dark,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      _buildDiaryCard(tripId, dayNumber, textColor, secondary, dark),

      const SizedBox(height: 12),

      _buildPostsGrid(tripId, dayNumber, dark),
    ],
  );
}

Widget _buildDiaryCard(
  String tripId,
  int dayNumber,
  Color textColor,
  Color secondary,
  bool dark,
) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Reisetagebcher')
        .where('tripId', isEqualTo: tripId)
        .where('tripDayNumber', isEqualTo: dayNumber)
        .snapshots(),

    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const SizedBox();
      }

      final diary = snapshot.data!.docs.first;

      final data = diary.data() as Map<String, dynamic>;

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  TravelDiaryDetailPage(diaryId: diary.id, isDarkMode: dark),
            ),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            color: dark ? Colors.white12 : Colors.white,

            borderRadius: BorderRadius.circular(14),
          ),

          child: Row(
            children: [
              const Icon(Icons.menu_book, color: Colors.deepPurple),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  data['titel'] ?? "Reisetagebuch",

                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.deepPurple),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildPostsGrid(String tripId, int dayNumber, bool dark) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Posts')
        .where('tripId', isEqualTo: tripId)
        .where('tripDayNumber', isEqualTo: dayNumber)
        .snapshots(),

    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const SizedBox();
      }

      final posts = snapshot.data!.docs;

      return SizedBox(
        height: ((posts.length / 4).ceil() * 80).toDouble(),

        child: GridView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: posts.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,

            crossAxisSpacing: 4,

            mainAxisSpacing: 4,
          ),

          itemBuilder: (context, index) {
            final post = posts[index];

            final data = post.data() as Map<String, dynamic>;

            final urls = List<String>.from(data['mediaUrls'] ?? []);

            final thumbs = List<String>.from(data['thumbnailUrls'] ?? []);

            String image = urls.isNotEmpty ? urls.first : "";

            if (thumbs.isNotEmpty && thumbs.first.isNotEmpty) {
              image = thumbs.first;
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        PostDetailPage(postId: post.id, isDarkMode: dark),
                  ),
                );
              },

              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: image.isNotEmpty
                    ? Image.network(image, fit: BoxFit.cover)
                    : Container(color: Colors.grey),
              ),
            );
          },
        ),
      );
    },
  );
}

Widget _buildStatistics(
  String tripId,
  DateTime? start,
  DateTime? end,
  Color textColor,
  Color secondary,
) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Posts')
        .where('tripId', isEqualTo: tripId)
        .snapshots(),

    builder: (context, postSnap) {
      final moments = postSnap.data?.docs.length ?? 0;

      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Reisetagebcher')
            .where('tripId', isEqualTo: tripId)
            .snapshots(),

        builder: (context, diarySnap) {
          final diaries = diarySnap.data?.docs.length ?? 0;

          final days = start != null && end != null
              ? _calculateDays(start, end)
              : 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              _StatItem(
                number: "$days",
                label: "Tage",
                textColor: textColor,
                secondary: secondary,
              ),

              _StatItem(
                number: "$moments",
                label: "Momente",
                textColor: textColor,
                secondary: secondary,
              ),

              _StatItem(
                number: "$diaries",
                label: "Tagebücher",
                textColor: textColor,
                secondary: secondary,
              ),
            ],
          );
        },
      );
    },
  );
}
