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

  String? selectedTripId;
  int? selectedTripDayNumber;

  String? selectedForumRegion;
  String? selectedForumCountry;
  String? selectedForumTopic;

  bool _isUploading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool get _isFormValid =>
      _titleController.text.trim().isNotEmpty &&
      _entryController.text.trim().isNotEmpty;

  bool get _isForumSelectionValid {
    final values = [
      selectedForumRegion,
      selectedForumCountry,
      selectedForumTopic,
    ];

    final filled = values.where((e) => e != null).length;

    if (filled == 0) return true;

    return filled == 3;
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final strings = S.of(context)!;

    if (!_isForumSelectionValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Bitte Region, Land und Thema vollständig auswählen oder die Forum-Auswahl leer lassen.",
          ),
        ),
      );
      return;
    }

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

  Widget _selectForumCard(Color textColor, Color subColor) {
    const regions = [
      "Europa",
      "Asien",
      "Afrika",
      "Nordamerika",
      "Südamerika",
      "Zentralamerika",
      "Karibik",
      "Australien & Pazifik",
      "Naher Osten",
      "Polarregionen",
    ];

    const countriesByRegion = {
      "Europa": [
        "Deutschland",
        "Spanien",
        "Italien",
        "Frankreich",
        "Portugal",
        "Griechenland",
        "Österreich",
        "Schweiz",
        "Niederlande",
        "Belgien",
        "Luxemburg",
        "Dänemark",
        "Schweden",
        "Norwegen",
        "Finnland",
        "Island",
        "Irland",
        "Großbritannien",
        "Polen",
        "Tschechien",
        "Slowakei",
        "Ungarn",
        "Slowenien",
        "Kroatien",
        "Montenegro",
        "Albanien",
        "Bosnien und Herzegowina",
        "Serbien",
        "Bulgarien",
        "Rumänien",
        "Estland",
        "Lettland",
        "Litauen",
        "Malta",
        "Zypern",
        "Türkei",
      ],
      "Asien": [
        "Japan",
        "China",
        "Südkorea",
        "Taiwan",
        "Thailand",
        "Vietnam",
        "Kambodscha",
        "Laos",
        "Myanmar",
        "Indonesien",
        "Malaysia",
        "Singapur",
        "Philippinen",
        "Brunei",
        "Indien",
        "Sri Lanka",
        "Nepal",
        "Bhutan",
        "Bangladesch",
        "Malediven",
        "Mongolei",
        "Kasachstan",
        "Usbekistan",
        "Kirgisistan",
        "Georgien",
        "Armenien",
        "Aserbaidschan",
      ],
      "Afrika": [
        "Südafrika",
        "Namibia",
        "Botswana",
        "Simbabwe",
        "Sambia",
        "Mosambik",
        "Tansania",
        "Kenia",
        "Uganda",
        "Ruanda",
        "Äthiopien",
        "Ghana",
        "Senegal",
        "Marokko",
        "Tunesien",
        "Ägypten",
        "Madagaskar",
        "Mauritius",
        "Seychellen",
        "Kap Verde",
      ],
      "Nordamerika": ["USA", "Kanada", "Mexiko"],
      "Zentralamerika": [
        "Costa Rica",
        "Panama",
        "Guatemala",
        "Belize",
        "Honduras",
        "Nicaragua",
        "El Salvador",
      ],
      "Karibik": [
        "Dominikanische Republik",
        "Kuba",
        "Jamaika",
        "Bahamas",
        "Barbados",
        "Aruba",
        "Curaçao",
        "Puerto Rico",
        "Trinidad und Tobago",
        "St. Lucia",
        "Grenada",
        "Antigua und Barbuda",
        "Dominica",
      ],
      "Südamerika": [
        "Brasilien",
        "Argentinien",
        "Chile",
        "Peru",
        "Kolumbien",
        "Bolivien",
        "Ecuador",
        "Uruguay",
        "Paraguay",
        "Venezuela",
        "Guyana",
        "Suriname",
      ],
      "Australien & Pazifik": [
        "Australien",
        "Neuseeland",
        "Fidschi",
        "Samoa",
        "Tonga",
        "Vanuatu",
        "Französisch-Polynesien",
        "Cookinseln",
        "Palau",
        "Neukaledonien",
        "Papua-Neuguinea",
        "Salomonen",
      ],
      "Naher Osten": [
        "Vereinigte Arabische Emirate",
        "Saudi-Arabien",
        "Oman",
        "Katar",
        "Jordanien",
        "Israel",
        "Bahrain",
        "Kuwait",
        "Libanon",
      ],
      "Polarregionen": ["Antarktis", "Grönland", "Spitzbergen"],
    };

    final topics = [
      "Sehenswürdigkeiten & Natur",
      "Erlebnisse & Aktivitäten",
      "Essen & Trinken",
      "Unterkünfte",
      "Transport & Apps",
      "Einreise & Visa",
      "Kosten & Preise",
      "Beste Reisezeit & Wetter",
      "Sicherheit",
      "Kultur & Verhalten",
      "Geheimtipps & Orte",
      "Reisestile",
      "Erfahrungen & Reiseberichte",
      "Fragen & Hilfe",
    ];

    final countries = selectedForumRegion == null
        ? <String>[]
        : countriesByRegion[selectedForumRegion] ?? <String>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Im Reiseforum veröffentlichen (optional)",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),

          const SizedBox(height: 12),

          DropdownButton<String>(
            value: selectedForumRegion,
            hint: Text("Region", style: TextStyle(color: subColor)),
            isExpanded: true,
            items: regions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedForumRegion = value;
                selectedForumCountry = null;
                selectedForumTopic = null;
              });
            },
          ),

          if (selectedForumRegion != null)
            DropdownButton<String>(
              value: selectedForumCountry,
              hint: Text("Land", style: TextStyle(color: subColor)),
              isExpanded: true,
              items: countries
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedForumCountry = value;
                  selectedForumTopic = null;
                });
              },
            ),

          if (selectedForumCountry != null)
            DropdownButton<String>(
              value: selectedForumTopic,
              hint: Text("Thema", style: TextStyle(color: subColor)),
              isExpanded: true,
              items: topics
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedForumTopic = value;
                });
              },
            ),
        ],
      ),
    );
  }

  Future<void> _showTripDaySelector() async {
    if (selectedTripId == null) return;

    final tripDoc = await FirebaseFirestore.instance
        .collection('trips')
        .doc(selectedTripId)
        .get();

    if (!mounted) return;

    if (!tripDoc.exists) return;

    final data = tripDoc.data();

    if (data == null) return;

    final start = (data['startDate'] as Timestamp?)?.toDate();

    final end = (data['endDate'] as Timestamp?)?.toDate();

    if (start == null || end == null) return;

    final days = <DateTime>[];

    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);

      current = current.add(const Duration(days: 1));
    }

    if (!mounted) return;

    final selectedDay = await showModalBottomSheet<int>(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,

            children: [
              const Padding(
                padding: EdgeInsets.all(20),

                child: Text(
                  "Welcher Reisetag?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              ...days.asMap().entries.map((entry) {
                final index = entry.key;

                final date = entry.value;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,

                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  title: Text("Tag ${index + 1}"),

                  subtitle: Text("${date.day}.${date.month}.${date.year}"),

                  onTap: () {
                    Navigator.pop(sheetContext, index + 1);
                  },
                );
              }),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (selectedDay != null) {
      setState(() {
        selectedTripDayNumber = selectedDay;
      });
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
        'tripId': selectedTripId,
        'tripDayNumber': selectedTripDayNumber,
        'forumRegion': selectedForumRegion,
        'forumCountry': selectedForumCountry,
        'forumTopic': selectedForumTopic,
      });

      if (!mounted) return;

      // Hier ändern wir die Navigation:
      // Nach dem Speichern
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationPage(
            initialIndex: 4, // Profil Tab
            profileInitialTab: 1, // Journals Tab
          ),
        ),
        (route) => false,
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

  Widget _selectTripCard(Color textColor, Color subColor) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),

      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox();
        }

        final trips = snap.data!.docs;

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.withValues(alpha: 0.15),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Zur Reise hinzufügen (optional)",
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),

              DropdownButton<String>(
                value: selectedTripId,

                hint: Text(
                  "Keine Reise auswählen",
                  style: TextStyle(color: subColor),
                ),

                isExpanded: true,

                items: trips.map((trip) {
                  final data = trip.data() as Map<String, dynamic>;

                  return DropdownMenuItem(
                    value: trip.id,

                    child: Text(data['title'] ?? "Reise"),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedTripId = value;

                    selectedTripDayNumber = null;
                  });

                  _showTripDaySelector();
                },
              ),
            ],
          ),
        );
      },
    );
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

            _selectTripCard(textColor, labelColor),

            const SizedBox(height: 20),

            _selectForumCard(textColor, labelColor),

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
