import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reiseplanung_packliste_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reiseplanung_budget_page.dart';
import 'reiseplanung_kontakte_page.dart';
import 'reiseplanung_notizen_page.dart';
import 'reiseplanung_todo_page.dart';

class TripPlanningPage extends ConsumerWidget {
  final String tripId;

  const TripPlanningPage({super.key, required this.tripId});

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

          // =========================
          // APP BAR
          // =========================
          appBar: AppBar(
            backgroundColor: bg,
            foregroundColor: text,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            title: StreamBuilder<DocumentSnapshot>(
              stream: tripRef.snapshots(),
              builder: (context, snapshot) {
                final trip = snapshot.data?.data() as Map<String, dynamic>?;

                final title = trip?['title'] ?? 'Trip';

                return Text(
                  title,
                  style: GoogleFonts.pacifico(fontSize: 26, color: text),
                );
              },
            ),
          ),

          // =========================
          // BODY
          // =========================
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
                    const SizedBox(height: 12),

                    // =========================
                    // DATE
                    // =========================
                    if (startDate != null && endDate != null)
                      Text(
                        "${startDate.day}.${startDate.month}.${startDate.year} - "
                        "${endDate.day}.${endDate.month}.${endDate.year}",
                        style: TextStyle(color: subtext),
                      ),

                    const SizedBox(height: 16),

                    // =========================
                    // LIST
                    // =========================
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildTodos(card, text, subtext),
                          _buildPacklists(card, text, subtext),
                          _buildNotes(card, text, subtext),
                          _buildContacts(card, text, subtext),
                          _buildBudget(card, text, subtext),
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
          title: "To-Dos",
          subtitle: subtitle,
          icon: Icons.check_circle,
          color: Colors.green,
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

  Widget _buildContacts(Color card, Color text, Color subtext) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('contacts')
          .snapshots(),
      builder: (context, snap) {
        final count = snap.data?.docs.length ?? 0;

        return _DashboardTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripContactsPage(tripId: tripId),
              ),
            );
          },
          cardColor: card,
          textColor: text,
          subtextColor: subtext,
          title: "Kontakte",
          subtitle: "$count Personen",
          icon: Icons.people,
          color: Colors.purple,
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
          ],
        ),
      ),
    );
  }
}
