import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/dark_mode_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'trip_planning_page.dart';
import '../tui_reisebuero_page.dart';

import '../guides/guides_mock_page.dart';
import '../mama_tochter_tagebuch_page.dart';
import 'trip_status.dart';
import 'trip_memories_page.dart';
import 'trip_active_page.dart';

class TripsOverviewPage extends ConsumerStatefulWidget {
  final VoidCallback? onAddTrip;

  const TripsOverviewPage({super.key, this.onAddTrip});

  @override
  ConsumerState<TripsOverviewPage> createState() => _TripsOverviewPageState();
}

class _TripsOverviewPageState extends ConsumerState<TripsOverviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    final bg = isDarkMode ? Colors.black : Colors.white;

    final text = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,

        elevation: 0,

        centerTitle: true,

        foregroundColor: text,

        title: Text(
          "Reisen",
          style: GoogleFonts.pacifico(fontSize: 26, color: text),
        ),

        bottom: TabBar(
          controller: _tabController,

          indicatorColor: const Color(0xFF8C77FF),

          labelColor: const Color(0xFF8C77FF),

          unselectedLabelColor: isDarkMode ? Colors.white54 : Colors.black45,

          tabs: const [
            Tab(text: "Meine Reisen"),

            Tab(text: "Reiseguides"),

            Tab(text: "Tagebücher"),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,

              children: [
                // ======================
                // MEINE REISEN
                // ======================
                _MyTripsTab(
                  isDarkMode: isDarkMode,
                  onAddTrip: widget.onAddTrip,
                ),

                // ======================
                // GUIDES
                // ======================
                const GuidesMockPage(),

                // ======================
                // TAGEBÜCHER
                // ======================
                const MamaTochterTagebuchPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyTripsTab extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onAddTrip;

  const _MyTripsTab({required this.isDarkMode, this.onAddTrip});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================
        // DEINE REISEN
        // ==========================
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('trips')
                .where(
                  'userId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                )
                .snapshots(),

            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final trips = snapshot.data!.docs;

              final now = DateTime.now();

              final upcomingTrips = trips.where((trip) {
                final data = trip.data() as Map<String, dynamic>;

                final start = (data['startDate'] as Timestamp).toDate();

                return start.isAfter(now);
              }).toList();

              final currentTrips = trips.where((trip) {
                final data = trip.data() as Map<String, dynamic>;

                final start = (data['startDate'] as Timestamp).toDate();

                final end = (data['endDate'] as Timestamp).toDate();

                return !now.isBefore(start) && !now.isAfter(end);
              }).toList();

              final pastTrips = trips.where((trip) {
                final data = trip.data() as Map<String, dynamic>;

                final end = (data['endDate'] as Timestamp).toDate();

                return now.isAfter(end);
              }).toList();

              upcomingTrips.sort((a, b) {
                final aDate = (a.data() as Map<String, dynamic>)['startDate']
                    .toDate();

                final bDate = (b.data() as Map<String, dynamic>)['startDate']
                    .toDate();

                return aDate.compareTo(bDate);
              });

              pastTrips.sort((a, b) {
                final aDate = (a.data() as Map<String, dynamic>)['startDate']
                    .toDate();

                final bDate = (b.data() as Map<String, dynamic>)['startDate']
                    .toDate();

                return bDate.compareTo(aDate);
              });

              if (trips.isEmpty) {
                return Center(
                  child: GestureDetector(
                    onTap: onAddTrip,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Noch keine Reisen ✈️",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Tippe hier, um deine nächste Reise hinzuzufügen,\n"
                            "deinen Reisecountdown zu starten\n"
                            "und deine Planung zu beginnen 🌍",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8C77FF),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              "Reise hinzufügen",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReisebuerosPage(isDarkMode: isDarkMode),
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 22),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E2FF),

                        borderRadius: BorderRadius.circular(24),

                        border: Border.all(
                          color: const Color(0xFF8C77FF),
                          width: 1,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "TUI Aschaffenburg (Reisebüro)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5E4BC8),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Persönliche Reiseberatung für deine nächste Traumreise.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (currentTrips.isNotEmpty) ...[
                    Text(
                      "Aktuelle Reise",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),

                    ...currentTrips.map((trip) {
                      final data = trip.data() as Map<String, dynamic>;

                      return TripCard(
                        tripId: trip.id,
                        title: data['title'] ?? "Trip",
                        start: (data['startDate'] as Timestamp).toDate(),
                        end: (data['endDate'] as Timestamp).toDate(),
                        isDarkMode: isDarkMode,
                        isCurrent: true,
                      );
                    }),
                  ],

                  if (upcomingTrips.isNotEmpty) ...[
                    Text(
                      "Kommende Reisen",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),

                    ...upcomingTrips.map((trip) {
                      final data = trip.data() as Map<String, dynamic>;

                      return TripCard(
                        tripId: trip.id,
                        title: data['title'] ?? "Trip",
                        start: (data['startDate'] as Timestamp).toDate(),
                        end: (data['endDate'] as Timestamp).toDate(),
                        isDarkMode: isDarkMode,
                      );
                    }),
                  ],

                  if (pastTrips.isNotEmpty) ...[
                    Text(
                      "Vergangene Reisen",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),

                    ...pastTrips.map((trip) {
                      final data = trip.data() as Map<String, dynamic>;

                      return TripCard(
                        tripId: trip.id,
                        title: data['title'] ?? "Trip",
                        start: (data['startDate'] as Timestamp).toDate(),
                        end: (data['endDate'] as Timestamp).toDate(),
                        isDarkMode: isDarkMode,
                        isPast: true,
                      );
                    }),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TripCard extends StatefulWidget {
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isDarkMode;
  final String tripId;
  final bool isCurrent;
  final bool isPast;

  const TripCard({
    super.key,
    required this.tripId,
    required this.title,
    required this.start,
    required this.end,
    required this.isDarkMode,
    this.isCurrent = false,
    this.isPast = false,
  });

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  late Timer timer;

  void _showTripOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Bearbeiten"),
                onTap: () {
                  Navigator.pop(context);
                  _editTrip();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "Löschen",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteTrip();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editTrip() async {
    final titleController = TextEditingController(text: widget.title);

    DateTime startDate = widget.start;
    DateTime endDate = widget.end;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Reise bearbeiten"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Titel"),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            startDate = picked;
                          });
                        }
                      },
                      child: Text(
                        "Start: ${startDate.day}.${startDate.month}.${startDate.year}",
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setDialogState(() {
                            endDate = picked;
                          });
                        }
                      },
                      child: Text(
                        "Ende: ${endDate.day}.${endDate.month}.${endDate.year}",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Abbrechen"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('trips')
                        .doc(widget.tripId)
                        .update({
                          'title': titleController.text.trim(),
                          'startDate': Timestamp.fromDate(startDate),
                          'endDate': Timestamp.fromDate(endDate),
                        });

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Speichern"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTrip() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reise löschen"),
        content: const Text("Möchtest du diese Reise wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await FirebaseFirestore.instance
        .collection('trips')
        .doc(widget.tripId)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    getTripStatus(widget.start, widget.end);

    return GestureDetector(
      onTap: () {
        if (widget.isPast) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripMemoriesPage(tripId: widget.tripId),
            ),
          );
        } else if (widget.isCurrent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripActivePage(tripId: widget.tripId),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripPlanningPage(tripId: widget.tripId),
            ),
          );
        }
      },

      onLongPress: _showTripOptions,

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF211E2B) : const Color(0xFFF0EBFF),

          borderRadius: BorderRadius.circular(26),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔥 TITLE (Mallorca etc.)
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            if (!widget.isCurrent && !widget.isPast)
              Text(
                "Noch ${widget.start.difference(DateTime.now()).inDays} Tage",
                style: const TextStyle(
                  color: Color(0xFF8C77FF),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

            if (widget.isCurrent)
              Text(
                "Tag ${DateTime.now().difference(widget.start).inDays + 1} von ${widget.end.difference(widget.start).inDays + 1}",
                style: const TextStyle(
                  color: Color(0xFF8C77FF),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

            if (widget.isPast)
              Text(
                "${widget.start.day}.${widget.start.month}.${widget.start.year} - ${widget.end.day}.${widget.end.month}.${widget.end.year}",
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  fontSize: 15,
                ),
              ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 6),
                widget.isPast
                    ? const Text(
                        "Erinnerungen öffnen",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      )
                    : widget.isCurrent
                    ? const Text(
                        "Reise & Erinnerungen öffnen",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      )
                    : const Text(
                        "Reiseplanung öffnen",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TripDetailPage extends StatelessWidget {
  final String tripId;

  const TripDetailPage({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Details")),
      body: Center(child: Text("Trip ID: $tripId")),
    );
  }
}
