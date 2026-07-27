import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reiseplanung_packliste_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reiseplanung_budget_page.dart';
import 'reiseplanung_notizen_page.dart';
import 'reiseplanung_todo_page.dart';
import 'reiseplanung_inspiration_page.dart';

class TripPlanningPage extends ConsumerWidget {
  final String tripId;
  final bool showAppBar;

  const TripPlanningPage({
    super.key,
    required this.tripId,
    this.showAppBar = true,
  });

  Widget _buildTripStats(
    Color card,
    Color text,
    Color subtext,
    DateTime? start,
    DateTime? end,
  ) {
    int days = 0;

    if (start != null && end != null) {
      days = end.difference(start).inDays + 1;
    }

    return Text(
      "$days Tage",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: text),
    );
  }

  Future<bool> _hasAnyPreviousPacklists() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final trips = await FirebaseFirestore.instance
        .collection('trips')
        .where('userId', isEqualTo: user.uid)
        .get();

    for (final trip in trips.docs) {
      final lists = await FirebaseFirestore.instance
          .collection('trips')
          .doc(trip.id)
          .collection('packlisten')
          .get();

      if (lists.docs.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  Future<void> _createNewPacklist(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final packlisteRef = FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('packlisten')
        .doc();

    await packlisteRef.set({
      'title': 'Packliste',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PacklisteDetailPage(
          packlisteId: packlisteRef.id,
          userId: user.uid,
          tripId: tripId,
          title: "Packliste",
          isPremium: false,
          onUpdate: () {},
        ),
      ),
    );
  }

  Future<void> _importPacklist(
    BuildContext context,
    String oldTripId,
    String oldPacklistId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newPacklistRef = FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('packlisten')
        .doc();

    await newPacklistRef.set({
      'title': 'Packliste',
      'createdAt': FieldValue.serverTimestamp(),
      'importedFrom': oldTripId,
    });

    final oldItems = await FirebaseFirestore.instance
        .collection('trips')
        .doc(oldTripId)
        .collection('packlisten')
        .doc(oldPacklistId)
        .collection('items')
        .get();

    for (final item in oldItems.docs) {
      final data = item.data();

      await newPacklistRef.collection('items').add({
        'name': data['name'] ?? '',

        'category': data['category'] ?? 'Sonstiges',

        'quantity': data['quantity'] ?? 1,

        // WICHTIG:
        // niemals alten Status übernehmen
        'completed': false,
      });
    }

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PacklisteDetailPage(
          packlisteId: newPacklistRef.id,
          userId: user.uid,
          tripId: tripId,
          title: "Packliste",
          isPremium: false,
          onUpdate: () {},
        ),
      ),
    );
  }

  Future<void> _showPacklistChoice(BuildContext context) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Du hast bereits Packlisten\nvon früheren Reisen.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Was möchtest du machen?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "new");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Neue Packliste erstellen"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, "import");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Von früherer Reise übernehmen"),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
    if (!context.mounted) return;

    if (choice == "new") {
      await _createNewPacklist(context);
    }
    if (!context.mounted) return;

    if (choice == "import") {
      _showPreviousTrips(context);
    }
  }

  Future<void> _showPreviousTrips(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final trips = await FirebaseFirestore.instance
        .collection('trips')
        .where('userId', isEqualTo: user.uid)
        .get();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Packliste auswählen",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Flexible(
                child: ListView(
                  shrinkWrap: true,

                  children: trips.docs.map((trip) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('trips')
                          .doc(trip.id)
                          .collection('packlisten')
                          .get(),

                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const SizedBox();
                        }

                        final packlist = snapshot.data!.docs.first;

                        final data = trip.data();

                        final start = (data['startDate'] as Timestamp?)
                            ?.toDate();

                        final end = (data['endDate'] as Timestamp?)?.toDate();

                        String dateText = "";

                        if (start != null && end != null) {
                          dateText =
                              "${start.day}.${start.month}.${start.year}"
                              " - "
                              "${end.day}.${end.month}.${end.year}";
                        }

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),

                          title: Text(
                            data['title'] ?? "Reise",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),

                          subtitle: Text(dateText),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),

                          onTap: () {
                            Navigator.pop(context);

                            _importPacklist(context, trip.id, packlist.id);
                          },
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

  Widget _buildTripStatus(
    Color text,
    Color subtext,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    if (startDate == null) {
      return const SizedBox();
    }

    final now = DateTime.now();

    String status;

    if (now.isBefore(startDate)) {
      final countdown = startDate.difference(now).inDays;
      status = "Noch $countdown Tage bis zum Start ✈️";
    } else if (endDate != null && now.isBefore(endDate)) {
      status = "Deine Reise läuft gerade ✈️";
    } else {
      status = "Reise abgeschlossen";
    }

    return Text(status, style: TextStyle(color: subtext, fontSize: 14));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeAsync = ref.watch(darkModeProvider);
    final tripRef = FirebaseFirestore.instance.collection('trips').doc(tripId);

    return isDarkModeAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),

      data: (isDarkMode) {
        final bg = isDarkMode ? Colors.black : Colors.white;
        final card = isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF7F7F7); // 👈 wichtig
        final text = isDarkMode ? Colors.white : Colors.black;
        final subtext = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

        return Scaffold(
          backgroundColor: bg,

          appBar: showAppBar
              ? AppBar(
                  backgroundColor: bg,
                  foregroundColor: text,
                  elevation: 0,
                  centerTitle: true,

                  title: StreamBuilder<DocumentSnapshot>(
                    stream: tripRef.snapshots(),
                    builder: (context, snapshot) {
                      final trip =
                          snapshot.data?.data() as Map<String, dynamic>?;

                      final title = trip?['title'] ?? 'Trip';

                      return Text(
                        title,
                        style: GoogleFonts.pacifico(fontSize: 26, color: text),
                      );
                    },
                  ),
                )
              : null,

          body: StreamBuilder<DocumentSnapshot>(
            stream: tripRef.snapshots(),
            builder: (context, tripSnap) {
              if (!tripSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final trip = tripSnap.data!.data() as Map<String, dynamic>?;

              final startDate = (trip?['startDate'] as Timestamp?)?.toDate();
              final endDate = (trip?['endDate'] as Timestamp?)?.toDate();

              return Container(
                color: bg,
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // =========================
                    // DATE
                    // =========================
                    if (startDate != null && endDate != null)
                      Text(
                        "${startDate.day}.${startDate.month}.${startDate.year} - "
                        "${endDate.day}.${endDate.month}.${endDate.year}",
                        style: TextStyle(color: subtext),
                      ),

                    const SizedBox(height: 20),

                    _buildTripStats(card, text, subtext, startDate, endDate),

                    const SizedBox(height: 8),

                    _buildTripStatus(text, subtext, startDate, endDate),

                    const SizedBox(height: 20),

                    // =========================
                    // LIST
                    // =========================
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            "Reiseübersicht",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: text,
                            ),
                          ),

                          const SizedBox(height: 12),
                          _buildPacklists(card, text, subtext),

                          _buildTodos(card, text, subtext),

                          _buildInspiration(card, text, subtext),

                          _buildBudget(card, text, subtext),

                          _buildNotes(card, text, subtext),

                          const SizedBox(height: 35),

                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Text(
                                "Deine Reiseerinnerungen entstehen hier.\n\n"
                                "Sobald deine Reise startet, kannst du hier Tagebuch führen, Orte speichern und besondere Momente festhalten.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subtext,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // =========================================================
  // TODOS
  // =========================================================
  Widget _buildTodos(Color card, Color text, Color subtext) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('todos')
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        final total = docs.length;
        final done = docs.where((d) {
          final data = d.data() as Map<String, dynamic>;
          return data['done'] == true;
        }).length;

        final subtitle = total == 0
            ? "Noch keine To-Dos → starte jetzt"
            : "$done von $total erledigt";

        return _DashboardTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TodoPage(tripId: tripId)),
            );
          },
          cardColor: card,
          textColor: text,
          subtextColor: subtext,
          title: "Aufgaben",
          subtitle: subtitle,
          icon: Icons.check_circle,
          color: Colors.green,
        );
      },
    );
  }

  Widget _buildInspiration(Color card, Color text, Color subtext) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .snapshots(),

      builder: (context, snap) {
        final data = snap.data?.data() as Map<String, dynamic>?;

        final count = (data?['savedPosts'] ?? []).length;

        return _DashboardTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripInspirationPage(tripId: tripId),
              ),
            );
          },

          cardColor: card,
          textColor: text,
          subtextColor: subtext,

          title: "Inspiration",

          subtitle: "$count gespeicherte Beiträge",

          icon: Icons.favorite,

          color: Colors.pink,
        );
      },
    );
  }

  // =========================================================
  // PACKLISTE
  // =========================================================
  Widget _buildPacklists(Color card, Color text, Color subtext) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('packlisten')
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox();
        }

        final lists = snap.data!.docs;

        if (lists.isEmpty) {
          return _DashboardTile(
            onTap: () async {
              final hasPrevious = await _hasAnyPreviousPacklists();
              if (!context.mounted) return;
              if (hasPrevious) {
                await _showPacklistChoice(context);
              } else {
                await _createNewPacklist(context);
              }
            },
            cardColor: card,
            textColor: text,
            subtextColor: subtext,
            title: "Packliste",
            subtitle: "Du hast noch nicht angefangen zu packen → starte jetzt",
            icon: Icons.luggage,
            color: Colors.orange,
          );
        }

        final firstListId = lists.first.id;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('trips')
              .doc(tripId)
              .collection('packlisten')
              .doc(firstListId)
              .collection('items')
              .snapshots(),
          builder: (context, itemSnap) {
            final items = itemSnap.data?.docs ?? [];

            final total = items.length;

            final packed = items.where((i) {
              final data = i.data() as Map<String, dynamic>;
              return data['completed'] == true;
            }).length;

            final subtitle = total == 0
                ? "Packliste leer → starte jetzt"
                : "$packed von $total gepackt";

            return _DashboardTile(
              onTap: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PacklisteDetailPage(
                      packlisteId: firstListId,
                      userId: user.uid,
                      tripId: tripId,
                      title: "Packliste",
                      isPremium: false,
                      onUpdate: () {},
                    ),
                  ),
                );
              },
              cardColor: card,
              textColor: text,
              subtextColor: subtext,
              title: "Packliste",
              subtitle: subtitle,
              icon: Icons.luggage,
              color: Colors.orange,
            );
          },
        );
      },
    );
  }

  // =========================================================
  Widget _buildNotes(Color card, Color text, Color subtext) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('notes')
          .snapshots(),
      builder: (context, snap) {
        final count = snap.data?.docs.length ?? 0;

        return _DashboardTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TripNotesPage(tripId: tripId)),
            );
          },
          cardColor: card,
          textColor: text,
          subtextColor: subtext,
          title: "Notizen",
          subtitle: "$count Einträge",
          icon: Icons.note_alt,
          color: Colors.blue,
        );
      },
    );
  }

  Widget _buildBudget(Color card, Color text, Color subtext) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('budget')
          .snapshots(),
      builder: (context, snap) {
        final budgets = snap.data?.docs ?? [];

        double spent = 0;
        double target = 0;

        for (var b in budgets) {
          final data = b.data() as Map<String, dynamic>;
          spent += (data['spent'] ?? 0).toDouble();
          target += (data['target'] ?? 0).toDouble();
        }

        final percent = target == 0 ? 0.0 : spent / target;

        return _DashboardTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BudgetPage(
                  tripId: tripId,
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
            );
          },
          cardColor: card,
          textColor: text,
          subtextColor: subtext,
          title: "Budget",
          subtitle:
              "${spent.toStringAsFixed(0)}€ / ${target.toStringAsFixed(0)}€",
          icon: Icons.savings,
          color: Colors.red,
          progress: percent,
        );
      },
    );
  }
}

// =========================================================
// CARD
// =========================================================
class _DashboardTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double? progress;

  final Color cardColor;
  final Color textColor;
  final Color subtextColor;

  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.cardColor,
    required this.textColor,
    required this.subtextColor,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: subtextColor)),
                ],
              ),
            ),

            if (progress != null)
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  color: color,
                ),
              ),

            const SizedBox(width: 8),

            Icon(Icons.chevron_right, color: subtextColor, size: 26),
          ],
        ),
      ),
    );
  }
}
