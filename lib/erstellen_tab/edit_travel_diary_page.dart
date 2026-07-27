import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/s.dart';

class EditTravelDiaryPage extends StatefulWidget {
  final String diaryId;
  final bool isDarkMode;

  const EditTravelDiaryPage({
    super.key,
    required this.diaryId,
    required this.isDarkMode,
  });

  @override
  State<EditTravelDiaryPage> createState() => _EditTravelDiaryPageState();
}

class _EditTravelDiaryPageState extends State<EditTravelDiaryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? selectedForumRegion;
  String? selectedForumCountry;
  String? selectedForumTopic;

  String? selectedTripId;
  String? selectedTripTitle;
  int? selectedTripDayNumber;

  final List<File> _newMediaFiles = [];
  final List<String> _newMediaTypes = []; // image | video
  List<Map<String, dynamic>> _existingMedia = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    try {
      final doc = await _firestore
          .collection('Reisetagebcher')
          .doc(widget.diaryId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _titleController.text = data['titel'] ?? '';
        _descriptionController.text = data['beschreibung'] ?? '';
        selectedTripId = data['tripId'];

        selectedForumRegion = data['forumRegion'];
        selectedForumCountry = data['forumCountry'];
        selectedForumTopic = data['forumTopic'];
        final images = data['images'] ?? [];

        _existingMedia = images.map<Map<String, dynamic>>((item) {
          if (item is String) return {'url': item, 'type': 'image'};
          return {'url': item['url'], 'type': item['type'] ?? 'image'};
        }).toList();
      }
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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

    final data = tripDoc.data()!;

    final start = (data['startDate'] as Timestamp?)?.toDate();

    final end = (data['endDate'] as Timestamp?)?.toDate();

    if (start == null || end == null) return;

    final days = <DateTime>[];

    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);

      current = current.add(const Duration(days: 1));
    }

    final selectedDay = await showModalBottomSheet<int>(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (_) {
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
                    Navigator.pop(context, index + 1);
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

                  final trip = trips.firstWhere((e) => e.id == value);
                  selectedTripTitle =
                      (trip.data() as Map<String, dynamic>)['title'];
                },
              ),
            ],
          ),
        );
      },
    );
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
      final picked = await picker.pickMultiImage();
      for (final f in picked) {
        _newMediaFiles.add(File(f.path));
        _newMediaTypes.add('image');
      }
    } else {
      final picked = await picker.pickVideo(source: ImageSource.gallery);
      if (picked != null) {
        _newMediaFiles.add(File(picked.path));
        _newMediaTypes.add('video');
      }
    }

    setState(() {});
  }

  void _removeExistingMedia(int index) =>
      setState(() => _existingMedia.removeAt(index));
  void _removeNewMedia(int index) => setState(() {
    _newMediaFiles.removeAt(index);
    _newMediaTypes.removeAt(index);
  });

  Future<void> _saveDiary() async {
    final strings = S.of(context)!;

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final List<Map<String, dynamic>> uploadedMedia = [];

      for (int i = 0; i < _newMediaFiles.length; i++) {
        final type = _newMediaTypes[i];
        final ext = type == 'image' ? 'jpg' : 'mp4';
        final ref = _storage.ref().child(
          "users/${user.uid}/uploads/${DateTime.now().millisecondsSinceEpoch}_$i.$ext",
        );

        await ref.putFile(_newMediaFiles[i]);
        final url = await ref.getDownloadURL();
        uploadedMedia.add({'url': url, 'type': type});
      }

      final allMedia = [..._existingMedia, ...uploadedMedia];

      await _firestore.collection('Reisetagebcher').doc(widget.diaryId).update({
        'titel': _titleController.text.trim(),
        'beschreibung': _descriptionController.text.trim(),
        'images': allMedia,

        'tripId': selectedTripId,
        'tripDayNumber': selectedTripDayNumber,

        'forumRegion': selectedForumRegion,
        'forumCountry': selectedForumCountry,
        'forumTopic': selectedForumTopic,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.diaryUpdated)));
        Navigator.of(context).pop(true);
      }
    } catch (e, st) {
      debugPrint('Fehler beim Speichern: $e\n$st');
      if (mounted) {
        final strings = S.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${strings.saveError}: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final textSecondaryColor = widget.isDarkMode
        ? Colors.white70
        : Colors.black54;
    final iconColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          strings.editTravelDiaryTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 24),
        ),
        leading: BackButton(color: iconColor),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: iconColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: strings.tripTitle,
                      labelStyle: TextStyle(color: textSecondaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    style: TextStyle(color: textColor),
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: strings.diaryEntry,
                      labelStyle: TextStyle(color: textSecondaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (int i = 0; i < _existingMedia.length; i++)
                        _mediaPreview(
                          _existingMedia[i]['url'],
                          _existingMedia[i]['type'],
                          () => _removeExistingMedia(i),
                        ),
                      for (int i = 0; i < _newMediaFiles.length; i++)
                        _mediaPreviewFile(
                          _newMediaFiles[i],
                          _newMediaTypes[i],
                          () => _removeNewMedia(i),
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
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _selectTripCard(textColor, textSecondaryColor),

                  const SizedBox(height: 24),

                  _selectForumCard(textColor, textSecondaryColor),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveDiary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              strings.saveChanges,
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _mediaPreview(String url, String type, VoidCallback onRemove) => Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: type == 'image'
            ? Image.network(url, width: 100, height: 100, fit: BoxFit.cover)
            : Container(
                width: 100,
                height: 100,
                color: Colors.grey[800],
                child: const Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: 40,
                ),
              ),
      ),
      Positioned(
        top: 2,
        right: 2,
        child: GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close, color: Colors.white),
        ),
      ),
    ],
  );

  Widget _mediaPreviewFile(File file, String type, VoidCallback onRemove) =>
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: type == 'image'
                ? Image.file(file, width: 100, height: 100, fit: BoxFit.cover)
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.videocam,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      );
}
