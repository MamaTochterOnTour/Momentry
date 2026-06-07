import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/dark_mode_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trip_planning_page.dart';
import '../partner/tui_reisebuero_page.dart';

class TripsOverviewPage extends ConsumerStatefulWidget {
  const TripsOverviewPage({super.key});

  @override
  ConsumerState<TripsOverviewPage> createState() => _TripsOverviewPageState();
}

class _TripsOverviewPageState extends ConsumerState<TripsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkModeAsync = ref.watch(darkModeProvider);

    return isDarkModeAsync.when(
      data: (isDarkMode) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,

          // 🔥 APPBAR
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            foregroundColor: isDarkMode ? Colors.white : Colors.black,
            title: Text(
              "Reiseplanung",
              style: GoogleFonts.pacifico(fontSize: 26),
            ),
          ),

          body: Column(
            children: [
              // 🔥 PARTNER BOX (hier richtig eingebaut)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReisebuerosPage(isDarkMode: isDarkMode),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]
                          : const Color(0xFFE6E0F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF8C77FF),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E0F8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // 👈 wichtig für Höhe
                        children: [
                          Text(
                            "TUI Aschaffenburg (Reisebüro)",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Dein Ansprechpartner für unvergessliche Urlaube - persönlich kompetent, herzlich.",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 🔥 REST (StreamBuilder bleibt wie vorher)
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

                    if (trips.isEmpty) {
                      return Center(
                        child: Text(
                          "Noch keine Reisen ✈️",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final data =
                            trips[index].data() as Map<String, dynamic>;

                        final start = (data['startDate'] as Timestamp).toDate();
                        final end = (data['endDate'] as Timestamp).toDate();

                        return TripCard(
                          tripId: trips[index].id,
                          title: data['title'] ?? 'Trip',
                          start: start,
                          end: end,
                          isDarkMode: isDarkMode,
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }
}

class TripCard extends StatefulWidget {
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isDarkMode;
  final String tripId;

  const TripCard({
    super.key,
    required this.tripId,
    required this.title,
    required this.start,
    required this.end,
    required this.isDarkMode,
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

  Map<String, int> getTimeLeft(DateTime target) {
    final now = DateTime.now();

    if (target.isBefore(now)) {
      return {
        "years": 0,
        "months": 0,
        "days": 0,
        "hours": 0,
        "minutes": 0,
        "seconds": 0,
      };
    }

    int years = target.year - now.year;
    int months = target.month - now.month;
    int days = target.day - now.day;
    int hours = target.hour - now.hour;
    int minutes = target.minute - now.minute;
    int seconds = target.second - now.second;

    if (seconds < 0) {
      seconds += 60;
      minutes--;
    }
    if (minutes < 0) {
      minutes += 60;
      hours--;
    }
    if (hours < 0) {
      hours += 24;
      days--;
    }
    if (days < 0) {
      months--;
      final prevMonth = DateTime(target.year, target.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      months += 12;
      years--;
    }

    return {
      "years": years,
      "months": months,
      "days": days,
      "hours": hours,
      "minutes": minutes,
    };
  }

  Widget _box(String value, String label, bool isDark) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE9D5FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final time = getTimeLeft(widget.start);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripPlanningPage(tripId: widget.tripId),
          ),
        );
      },

      onLongPress: _showTripOptions,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔥 TITLE (Mallorca etc.)
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 6),

            // 🔥 DATE RANGE
            Text(
              "${widget.start.day}.${widget.start.month}.${widget.start.year} "
              "- "
              "${widget.end.day}.${widget.end.month}.${widget.end.year}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 COUNTDOWN BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _box("${time['years']}", "J", isDark),
                const SizedBox(width: 6),
                _box("${time['months']}", "M", isDark),
                const SizedBox(width: 6),
                _box("${time['days']}", "T", isDark),
                const SizedBox(width: 6),
                _box("${time['hours']}", "Std", isDark),
                const SizedBox(width: 6),
                _box("${time['minutes']}", "Min", isDark),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 18,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 6),
                Text(
                  "für Planung tippen",
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
