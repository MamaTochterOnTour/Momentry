import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';
import 'main_navigation.dart';
import '../../l10n/s.dart';

class NewTravelDiaryPage extends ConsumerStatefulWidget {
  const NewTravelDiaryPage({super.key});

  @override
  ConsumerState<NewTravelDiaryPage> createState() => _NewTravelDiaryPageState();
}

class _NewTravelDiaryPageState extends ConsumerState<NewTravelDiaryPage> {
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  final List<File> _mediaFiles = [];
  final List<String> _mediaTypes = []; // 'image' oder 'video'

  bool _isUploading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool get _isFormValid =>
      _titleController.text.trim().isNotEmpty &&
      _entryController.text.trim().isNotEmpty;

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final strings = S.of(context)!;

    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(strings.selectImage),
            onTap: () => Navigator.pop(context, 'image'),
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: Text(strings.selectVideo),
            onTap: () => Navigator.pop(context, 'video'),
          ),
        ],
      ),
    );

    if (result == null) return;

    if (result == 'image') {
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          for (final file in pickedFiles) {
            _mediaFiles.add(File(file.path));
            _mediaTypes.add('image');
          }
        });
      }
    } else if (result == 'video') {
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _mediaFiles.add(File(pickedFile.path));
          _mediaTypes.add('video');
        });
      }
    }
  }

  Future<void> _saveDiary() async {
    final strings = S.of(context)!;
    if (!_isFormValid) return;

    if (!mounted) return;
    setState(() => _isUploading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      List<Map<String, String>> uploadedMedia = [];
      for (int i = 0; i < _mediaFiles.length; i++) {
        final file = _mediaFiles[i];
        final type = _mediaTypes[i];

        final extension = type == 'image' ? 'jpg' : 'mp4';
        final ref = _storage.ref().child(
          'users/${user.uid}/uploads/${DateTime.now().millisecondsSinceEpoch}_$i.$extension',
        );

        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        uploadedMedia.add({'url': url, 'type': type});
      }

      await _firestore.collection('Reisetagebcher').doc().set({
        'titel': _titleController.text.trim(),
        'beschreibung': _entryController.text.trim(),
        'images': uploadedMedia,
        'uid': user.uid,
        'createdTime': Timestamp.now(),
      });

      if (!mounted) return;

      // Hier ändern wir die Navigation:
      // Nach dem Speichern
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationPage(), // 0 = Tagebuch Tab
        ),
        (route) => false, // entfernt alle vorherigen Seiten aus dem Stack
      );
    } catch (e) {
      debugPrint('Fehler beim Speichern: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.saveError(e))), // <<< hier e übergeben
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
      _mediaTypes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeAsync = ref.watch(darkModeProvider);

    final isDarkMode = isDarkModeAsync.value ?? false; // default false

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black54;
    final accentColor = const Color(0xFF8C77FF); // optional
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    final buttonEnabled = _isFormValid && !_isUploading;
    final strings = S.of(context)!;

    // Hintergrundfarbe
    final buttonColor = buttonEnabled
        ? Colors.deepPurple
        : Colors.deepPurple.withAlpha((0.5 * 255).toInt());

    // Textfarbe
    final buttonTextColor = isDarkMode
        ? Colors.white
        : buttonEnabled
        ? Colors
              .white // aktiviert im Light Mode -> weiß
        : Colors.black38; // deaktiviert im Light Mode -> dunkler Ton

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          strings.newTravelDiary,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        leading: BackButton(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _titleController,
              label: strings.tripTitle,
              textColor: textColor,
              labelColor: labelColor,
              accentColor: accentColor,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _entryController,
              label: strings.diaryEntry,
              textColor: textColor,
              labelColor: labelColor,
              accentColor: accentColor,
              isDarkMode: isDarkMode,
              maxLines: 10,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                for (int i = 0; i < _mediaFiles.length; i++)
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: _mediaTypes[i] == 'image'
                              ? DecorationImage(
                                  image: FileImage(_mediaFiles[i]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.grey[800],
                        ),
                        child: _mediaTypes[i] == 'video'
                            ? const Center(
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(i),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                GestureDetector(
                  onTap: _pickMedia,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 40),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: buttonEnabled ? _saveDiary : null,
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        strings.saveDiary,
                        style: TextStyle(
                          color: buttonTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required Color labelColor,
    required Color accentColor,
    required bool isDarkMode,
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}), // Button rebuilden
      style: TextStyle(color: textColor),
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : Colors.black26,
          ),
        ),
      ),
      cursorColor: accentColor,
    );
  }
}
