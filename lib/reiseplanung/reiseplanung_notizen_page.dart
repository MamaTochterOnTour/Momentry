import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';
import '../providers/premium_provider.dart';
import '../pages/premium_verwalten_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/s.dart';

class TripNotesPage extends ConsumerStatefulWidget {
  final String tripId;

  const TripNotesPage({super.key, required this.tripId});

  @override
  ConsumerState<TripNotesPage> createState() => _TripNotesPageState();
}

class _TripNotesPageState extends ConsumerState<TripNotesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // ---------------- Notiz Bottom Sheet ----------------
  Future<void> _showNoteBottomSheet({
    String? noteId,
    Map<String, dynamic>? data,
    required bool isDark,
  }) async {
    _titleController.text = data?['title'] ?? '';
    _contentController.text = data?['content'] ?? '';

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
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: strings.titleLabel,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),
                        TextField(
                          controller: _contentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: strings.contentLabel,
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
                                if (_titleController.text.trim().isEmpty &&
                                    _contentController.text.trim().isEmpty) {
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
                                          'title': _titleController.text.trim(),
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
                                          'title': _titleController.text.trim(),
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

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final data = note.data()! as Map<String, dynamic>;

                  return GestureDetector(
                    onTap: () => _showNoteBottomSheet(
                      noteId: note.id,
                      data: data,
                      isDark: isDark,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] ?? strings.noTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['content'] ?? '',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
