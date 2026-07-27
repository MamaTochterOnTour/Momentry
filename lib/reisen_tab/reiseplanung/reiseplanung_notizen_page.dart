import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dark_mode_provider.dart';
import '../../providers/premium_provider.dart';
import '../../profil_tab/premium_verwalten_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../l10n/s.dart';

class TripNotesPage extends ConsumerStatefulWidget {
  final String tripId;

  const TripNotesPage({super.key, required this.tripId});

  @override
  ConsumerState<TripNotesPage> createState() => _TripNotesPageState();
}

class _TripNotesPageState extends ConsumerState<TripNotesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  String _selectedCategory = "Allgemein";

  final List<String> _categories = [
    "Allgemein",
    "Essen",
    "Unterkunft",
    "Idee",
    "Ort",
    "Wichtig",
    "Sonstiges",
  ];

  // ---------------- Notiz Bottom Sheet ----------------
  Future<void> _showNoteBottomSheet({
    String? noteId,
    Map<String, dynamic>? data,
    required bool isDark,
  }) async {
    _contentController.text = data?['content'] ?? '';

    _selectedCategory = data?['category'] ?? "Allgemein";

    _customCategoryController.text = data?['customCategory'] ?? "";

    // Premium prüfen
    final isPremiumAsync = ref.watch(premiumProvider);
    final strings = S.of(context)!;

    isPremiumAsync.when(
      data: (isPremium) async {
        // Limit prüfen nur für Nicht-Premium-User und neue Notizen
        if (!isPremium && noteId == null) {
          final snapshot = await _firestore
              .collection('trips')
              .doc(widget.tripId)
              .collection('notes')
              .get();

          if (snapshot.docs.length >= 2) {
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GestureDetector(
                  onTap: () {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PremiumPage(uid: uid)),
                    );
                  },
                  child: Text(strings.noteLimitPremium), // hier L10n-String
                ),
                backgroundColor: const Color(0xFF7B4DE8),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );

            return; // BottomSheet nicht öffnen
          }
        }

        // BottomSheet öffnen (für Premium oder freie Slots)
        if (!mounted) return;
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            String? errorText;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          noteId == null ? strings.newNote : strings.editNote,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            final result = await showModalBottomSheet<String>(
                              context: context,
                              backgroundColor: isDark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              builder: (_) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(20),
                                  children: _categories.map((category) {
                                    return ListTile(
                                      title: Text(
                                        category,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context, category);
                                      },
                                    );
                                  }).toList(),
                                );
                              },
                            );

                            if (result != null) {
                              setModalState(() {
                                _selectedCategory = result;

                                if (_selectedCategory != "Sonstiges") {
                                  _customCategoryController.clear();
                                }
                              });
                            }
                          },

                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: isDark
                                  ? Colors.grey[850]
                                  : Colors.grey[200],
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kategorie: $_selectedCategory",
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),

                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),

                        if (_selectedCategory == "Sonstiges")
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: _customCategoryController,

                              decoration: InputDecoration(
                                labelText: "Eigene Kategorie",
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),
                        TextField(
                          controller: _contentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "Notiz",
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        if (errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (noteId != null)
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await _firestore
                                        .collection('trips')
                                        .doc(widget.tripId)
                                        .collection('notes')
                                        .doc(noteId)
                                        .delete();

                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          strings.noteDeleteError,
                                        ), // L10n-String
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  strings.deleteButton,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              onPressed: () async {
                                if (_contentController.text.trim().isEmpty ||
                                    (_selectedCategory == "Sonstiges" &&
                                        _customCategoryController.text
                                            .trim()
                                            .isEmpty)) {
                                  setModalState(() {
                                    errorText =
                                        strings.noteEmptyError; // L10n-String
                                  });
                                  return;
                                }

                                try {
                                  if (noteId == null) {
                                    await _firestore
                                        .collection('trips')
                                        .doc(widget.tripId)
                                        .collection('notes')
                                        .add({
                                          'category': _selectedCategory,

                                          'customCategory':
                                              _selectedCategory == "Sonstiges"
                                              ? _customCategoryController.text
                                                    .trim()
                                              : "",

                                          'content': _contentController.text
                                              .trim(),

                                          'createdAt':
                                              FieldValue.serverTimestamp(),
                                        });
                                  } else {
                                    await _firestore
                                        .collection('trips')
                                        .doc(widget.tripId)
                                        .collection('notes')
                                        .doc(noteId)
                                        .update({
                                          'category': _selectedCategory,

                                          'customCategory':
                                              _selectedCategory == "Sonstiges"
                                              ? _customCategoryController.text
                                                    .trim()
                                              : "",

                                          'content': _contentController.text
                                              .trim(),
                                        });
                                  }

                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        strings.noteSaveError,
                                      ), // L10n-String
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                strings.saveButton,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () {},
      error: (err, stack) => debugPrint("Premium Error: $err"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final strings = S.of(context)!;

    return darkModeAsync.when(
      data: (isDark) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              strings.tripNotesTitle,
              style: GoogleFonts.pacifico(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 28,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: Colors.deepPurple),
                onPressed: () => _showNoteBottomSheet(isDark: isDark),
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('trips')
                .doc(widget.tripId)
                .collection('notes')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    strings.emptyNotesPlaceholder,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                );
              }

              final notes = snapshot.data!.docs;

              final groupedNotes = <String, List<QueryDocumentSnapshot>>{};

              for (final note in notes) {
                final data = note.data() as Map<String, dynamic>;

                final category = data['category'] ?? "Allgemein";

                groupedNotes.putIfAbsent(category, () => []).add(note);
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: groupedNotes.entries.map((entry) {
                  final category = entry.key;
                  final categoryNotes = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),

                      ...categoryNotes.map((note) {
                        final data = note.data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () => _showNoteBottomSheet(
                            noteId: note.id,
                            data: data,
                            isDark: isDark,
                          ),

                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[850] : Colors.white,

                              borderRadius: BorderRadius.circular(16),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),

                                  blurRadius: 6,

                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (category == "Sonstiges" &&
                                    data['customCategory'] != null &&
                                    data['customCategory']
                                        .toString()
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text(
                                      data['customCategory'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.deepPurple[200]
                                            : Colors.deepPurple,
                                      ),
                                    ),
                                  ),

                                Text(
                                  data['content'] ?? '',

                                  style: TextStyle(
                                    fontSize: 16,

                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text("Fehler: $err"))),
    );
  }
}
