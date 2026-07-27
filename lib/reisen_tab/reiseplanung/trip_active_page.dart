import 'package:flutter/material.dart';
import 'trip_planning_page.dart';
import 'trip_memories_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripActivePage extends ConsumerWidget {
  final String tripId;

  const TripActivePage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeAsync = ref.watch(darkModeProvider);

    final tripRef = FirebaseFirestore.instance.collection('trips').doc(tripId);

    return darkModeAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),

      data: (darkMode) {
        final backgroundColor = darkMode ? Colors.black : Colors.white;

        final textColor = darkMode ? Colors.white : Colors.black;

        return DefaultTabController(
          length: 2,

          child: Scaffold(
            backgroundColor: backgroundColor,

            appBar: AppBar(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              elevation: 0,
              centerTitle: true,

              title: StreamBuilder<DocumentSnapshot>(
                stream: tripRef.snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "Reise",
                      style: GoogleFonts.pacifico(
                        fontSize: 26,
                        color: textColor,
                      ),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;

                  final title = data?['title'] ?? "Reise";

                  return Text(
                    title,

                    style: GoogleFonts.pacifico(fontSize: 26, color: textColor),
                  );
                },
              ),

              bottom: TabBar(
                labelColor: textColor,

                unselectedLabelColor: darkMode
                    ? Colors.grey[500]
                    : Colors.grey[600],

                indicatorColor: const Color(0xFF8C77FF),

                tabs: const [
                  Tab(text: "Planung"),

                  Tab(text: "Erinnerungen"),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                TripPlanningPage(tripId: tripId, showAppBar: false),

                TripMemoriesPage(tripId: tripId, showAppBar: false),
              ],
            ),
          ),
        );
      },
    );
  }
}
