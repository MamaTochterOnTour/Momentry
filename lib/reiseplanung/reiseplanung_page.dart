import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/dark_mode_provider.dart'; // dein Provider importieren
import 'reiseplanung_packliste_detail_page.dart';
import 'reiseplanung_todo_page.dart';
import 'reiseplanung_budget_page.dart';
import 'reiseplanung_notizen_page.dart';
import 'reiseplanung_kontakte_page.dart';
import '../../l10n/s.dart';

// ---------------- TRIPS OVERVIEW PAGE ----------------

class TripsOverviewPage extends ConsumerStatefulWidget {
  const TripsOverviewPage({super.key});

  @override
  ConsumerState<TripsOverviewPage> createState() => _TripsOverviewPageState();
}

class _TripsOverviewPageState extends ConsumerState<TripsOverviewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final strings = S.of(context)!;

    return darkModeAsync.when(
      data: (isDark) => Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('trips')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  strings.noTripsPlanned,
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            }

            final trips = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final data = trip.data() as Map<String, dynamic>;

                final start = (data['startDate'] as Timestamp).toDate();
                final end = (data['endDate'] as Timestamp).toDate();
                final title = data['title'] ?? strings.noTitle;

                return TripCard(
                  title: title,
                  startDate: start,
                  endDate: end,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TripDetailPage(tripId: trip.id, tripData: data),
                      ),
                    );
                  },
                  isDark: isDark,
                );
              },
            );
          },
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text(strings.error(err.toString())))),
    );
  }
}

// ---------------- TripCard ----------------

class TripCard extends StatefulWidget {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onTap;
  final bool isDark;

  const TripCard({
    super.key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = widget.startDate.difference(now);
      if (_timeLeft.isNegative) _timeLeft = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Map<String, int> _getTimeParts(Duration duration) {
    int totalSeconds = duration.inSeconds;
    int years = totalSeconds ~/ (365 * 24 * 3600);
    totalSeconds %= 365 * 24 * 3600;
    int days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= 24 * 3600;
    int hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return {
      "years": years,
      "days": days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds,
    };
  }

  Widget _buildTimeBox(String label, int value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: widget.isDark ? Colors.white70 : Colors.black87,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeParts = _getTimeParts(_timeLeft);
    final strings = S.of(context)!;

    return Card(
      color: widget.isDark ? Colors.grey[900] : Color(0xFFF5F0FF),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.deepPurple.withAlpha(60),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                        fontSize: 20,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: widget.isDark ? Colors.white : Colors.deepPurple,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.startDate.day}.${widget.startDate.month}.${widget.startDate.year} – "
                "${widget.endDate.day}.${widget.endDate.month}.${widget.endDate.year}",
                style: TextStyle(
                  color: widget.isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeBox(strings.years, timeParts["years"]!),
                  _buildTimeBox(strings.days, timeParts["days"]!),
                  _buildTimeBox(strings.hoursShort, timeParts["hours"]!),
                  _buildTimeBox(strings.minutesShort, timeParts["minutes"]!),
                  _buildTimeBox(strings.secondsShort, timeParts["seconds"]!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- TRIP DETAIL PAGE ----------------

class TripDetailPage extends ConsumerStatefulWidget {
  final String tripId;
  final Map<String, dynamic>? tripData;

  const TripDetailPage({super.key, required this.tripId, this.tripData});

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage> {
  Map<String, dynamic>? tripData;
  bool loading = true;
  late Color tripColor;
  late GoogleMapController mapController;
  String selectedSection = 'dailyPlan';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color _parseTripColor(Map<String, dynamic>? data) {
    final rawColor = data?['color'];

    if (rawColor is String && rawColor.startsWith('#')) {
      return Color(int.parse(rawColor.replaceAll('#', '0xff')));
    }

    // Fallback, falls keine Farbe existiert
    return Colors.deepPurple;
  }

  @override
  void initState() {
    super.initState();

    if (widget.tripData != null) {
      tripData = widget.tripData;
      tripColor = _parseTripColor(tripData);
      loading = false;
    } else {
      _fetchTrip();
    }
  }

  Widget _buildContacts(bool isDark) {
    final contacts = (tripData!['contacts'] ?? []) as List;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final c = contacts[index] as Map<String, dynamic>;
              return Card(
                color: isDark ? Colors.grey[900] : Colors.white,
                child: ListTile(
                  leading: Icon(
                    c['emergency'] == true ? Icons.warning_amber : Icons.person,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    c['name'] ?? '',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    "${c['role'] ?? ''}\n${c['phone'] ?? ''}",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(bool isDark) {
    final notes = (tripData!['notes'] ?? []) as List;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index] as Map<String, dynamic>;
              return Card(
                color: isDark ? Colors.grey[900] : Colors.white,
                child: ListTile(
                  title: Text(
                    note['title'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    note['content'] ?? '',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Öffnet das Bearbeiten-Dialog
  void _openEditTripDialog(BuildContext context, bool isDark) {
    final titleController = TextEditingController(text: tripData!['title']);
    final strings = S.of(context)!;
    DateTime startDate = (tripData!['startDate'] as Timestamp).toDate();
    DateTime endDate = (tripData!['endDate'] as Timestamp).toDate();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.editTrip,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Titel bearbeiten
                  TextField(
                    controller: titleController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: strings.tripName,
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Startdatum
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: isDark ? ThemeData.dark() : ThemeData.light(),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null && picked != startDate) {
                        setState(() => startDate = picked);
                        // Enddatum anpassen, falls es vorher kleiner war
                        if (endDate.isBefore(startDate)) {
                          endDate = startDate;
                        }
                      }
                    },
                    child: Text(
                      "${strings.startDate}: ${startDate.day}.${startDate.month}.${startDate.year}",
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Enddatum
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: isDark ? ThemeData.dark() : ThemeData.light(),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                    child: Text(
                      "${strings.endDate}: ${endDate.day}.${endDate.month}.${endDate.year}",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(strings.cancel),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final navigator = Navigator.of(context);

                            await FirebaseFirestore.instance
                                .collection('trips')
                                .doc(widget.tripId)
                                .update({
                                  'title': titleController.text.trim(),
                                  'startDate': Timestamp.fromDate(startDate),
                                  'endDate': Timestamp.fromDate(endDate),
                                });

                            if (!mounted) return;

                            navigator.pop();
                            _fetchTrip();
                          },
                          child: Text(strings.save),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Löscht die Reise
  Future<void> _deleteTrip() async {
    final strings = S.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteTripTitle),
        content: Text(strings.deleteTripMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId)
          .delete();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _fetchTrip() async {
    final strings = S.of(context)!;
    try {
      final doc = await _firestore.collection("trips").doc(widget.tripId).get();

      if (!doc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(strings.tripNotFound)));
          Navigator.pop(context);
        }
        return;
      }

      if (mounted) {
        setState(() {
          tripData = doc.data();
          tripColor = _parseTripColor(tripData);
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading trip: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final darkModeAsync = ref.watch(darkModeProvider);

    return darkModeAsync.when(
      data: (isDark) {
        if (loading) {
          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              tripData!['title'],
              style: GoogleFonts.pacifico(
                fontSize: 24,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _openEditTripDialog(context, isDark);
                  } else if (value == 'delete') {
                    _deleteTrip();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(strings.edit)),
                  PopupMenuItem(value: 'delete', child: Text(strings.delete)),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Grid mit Kacheln – immer zwei pro Reihe
                _buildSectionTiles(isDark),

                const SizedBox(height: 16),

                // Vertikal scrollbarer Bereich für die ausgewählte Sektion
                Builder(
                  builder: (_) {
                    switch (selectedSection) {
                      case 'todos':
                        return SizedBox(
                          height: 400,
                          child: _buildTodos(isDark),
                        );
                      case 'packing':
                        return SizedBox(
                          height: 400,
                          child: _buildPackingList(isDark),
                        );
                      case 'budget':
                        return SizedBox(
                          height: 400,
                          child: _buildBudget(isDark),
                        );
                      case 'notes':
                        return SizedBox(
                          height: 400,
                          child: _buildNotes(isDark),
                        );
                      case 'contacts':
                        return SizedBox(
                          height: 400,
                          child: _buildContacts(isDark),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text(strings.error(err.toString())))),
    );
  }

  Widget _buildSectionTiles(bool isDark) {
    final lightPurple = const Color(0xFFE6E0F8);
    final iconColor = Colors.deepPurple;
    final strings = S.of(context)!;

    final sections = [
      {'key': 'todos', 'label': strings.todos, 'icon': Icons.check_box},
      {'key': 'packing', 'label': strings.packingList, 'icon': Icons.backpack},
      {'key': 'budget', 'label': strings.budget, 'icon': Icons.attach_money},
      {'key': 'notes', 'label': strings.notes, 'icon': Icons.note},
      {'key': 'contacts', 'label': strings.contacts, 'icon': Icons.people},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: sections.map((section) {
          final key = section['key'] as String;

          return GestureDetector(
            onTap: () async {
              if (key == 'todos') {
                final todosRef = _firestore
                    .collection('trips')
                    .doc(widget.tripId)
                    .collection('todos');

                try {
                  final snapshot = await todosRef.limit(1).get();

                  if (snapshot.docs.isEmpty) {
                    // Subcollection existiert noch nicht -> erstes leeres To-Do anlegen
                    await todosRef.doc().set({
                      'title': '', // noch kein Eintrag
                      'done': false, // Checkbox nicht angekreuzt
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                  }
                } catch (e) {
                  debugPrint(
                    'Fehler beim Erstellen der To-Do-Subcollection: $e',
                  );
                }

                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TodoPage(tripId: widget.tripId),
                    ),
                  );
                }
              } else if (key == 'packing') {
                // Packlisten-ID und Name vorbereiten
                final packlistId =
                    tripData?['packlistId'] ??
                    _firestore.collection('trips').doc().id;
                final packlistName =
                    tripData?['packlistName'] ??
                    tripData?['title'] ??
                    strings.myPackingList;

                // Falls Packliste noch nicht existiert im Trip-Dokument, einmalig updaten
                if (tripData?['packlistId'] == null) {
                  await _firestore
                      .collection('trips')
                      .doc(widget.tripId)
                      .update({
                        'packlistId': packlistId,
                        'packlistName': packlistName,
                      });

                  setState(() {
                    tripData!['packlistId'] = packlistId;
                    tripData!['packlistName'] = packlistName;
                  });
                }
                if (!mounted) return;

                // Navigation zur Packliste
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PacklisteDetailPage(
                      packlisteId: packlistId,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      tripId: widget.tripId,
                      color: tripColor,
                      title: packlistName,
                      isPremium: tripData?['isPremium'] ?? false,
                      onUpdate: () => _fetchTrip(),
                    ),
                  ),
                );
              } else if (key == 'budget') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BudgetPage(
                      userId: FirebaseAuth
                          .instance
                          .currentUser!
                          .uid, // oder widget.userId, je nachdem
                      tripId: widget.tripId, // unbedingt übergeben!
                    ),
                  ),
                );
              } else if (key == 'notes') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TripNotesPage(tripId: widget.tripId),
                  ),
                );
              } else if (key == 'contacts') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TripContactsPage(tripId: widget.tripId),
                  ),
                );
              } else {
                // Alle anderen Kacheln wie bisher auswählen
                setState(() => selectedSection = key);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.1,
                    ), // ✅ ersetzt withOpacity
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(section['icon'] as IconData, size: 40, color: iconColor),
                  const SizedBox(height: 12),
                  Text(
                    section['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Tagesplanung

  Widget _buildTodos(bool isDark) {
    final todos = (tripData!['todos'] ?? []) as List;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: todos.map((todo) {
        final t = todo as Map<String, dynamic>;
        return CheckboxListTile(
          value: t['done'] ?? false,
          title: Text(
            t['title'] ?? '',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          onChanged: (v) async {
            t['done'] = v;
            await _firestore.collection("trips").doc(widget.tripId).update({
              'todos': todos,
            });
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  Widget _buildPackingList(bool isDark) {
    final packing = (tripData!['packingList'] ?? []) as List;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: packing.map((item) {
        final p = item as Map<String, dynamic>;
        return CheckboxListTile(
          value: p['done'] ?? false,
          title: Text(
            "${p['item'] ?? ''} (${p['category'] ?? ''})",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          onChanged: (v) async {
            p['done'] = v;
            await _firestore.collection("trips").doc(widget.tripId).update({
              'packingList': packing,
            });
            setState(() {});
          },
        );
      }).toList(),
    );
  }

  Widget _buildBudget(bool isDark) {
    final budget = (tripData!['budget'] ?? []) as List;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: budget.map((b) {
        final bu = b as Map<String, dynamic>;
        return ListTile(
          title: Text(
            "${bu['item'] ?? ''} (${bu['category'] ?? ''})",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          trailing: Text(
            "${bu['amount'] ?? 0} €",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
        );
      }).toList(),
    );
  }
}
