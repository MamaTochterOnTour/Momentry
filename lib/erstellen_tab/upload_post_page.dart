import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../l10n/s.dart';
import 'main_navigation.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadPostPage extends ConsumerStatefulWidget {
  const UploadPostPage({super.key});

  @override
  ConsumerState<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends ConsumerState<UploadPostPage> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isUploading = false;

  String? selectedTripId;
  String? selectedTripTitle;

  String? selectedForumRegion;
  String? selectedForumCountry;
  String? selectedForumTopic;

  String? selectedTripDayId;
  int? selectedTripDayNumber;

  final List<File> _mediaFiles = [];
  final List<String> _mediaTypes = [];
  final List<VideoPlayerController?> _videoControllers = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool get _isFormValid =>
      _mediaFiles.isNotEmpty &&
      _locationController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  bool get _isForumSelectionValid {
    final values = [
      selectedForumRegion,
      selectedForumCountry,
      selectedForumTopic,
    ];

    final filled = values.where((e) => e != null).length;

    // gar nichts ausgewählt -> ok
    if (filled == 0) return true;

    // ansonsten müssen alle drei ausgewählt sein
    return filled == 3;
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final strings = S.of(context)!;
    if (_mediaFiles.length >= 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.maxMedia)));
      return;
    }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 10 - _mediaFiles.length,
        requestType: RequestType.all,
      ),
    );

    if (result == null) return;

    for (var asset in result) {
      final file = await asset.file;
      if (file == null) continue;

      if (asset.type == AssetType.image) {
        setState(() {
          _mediaFiles.add(file);
          _mediaTypes.add('image');
          _videoControllers.add(null);
        });
      } else if (asset.type == AssetType.video) {
        final controller = VideoPlayerController.file(file);
        await controller.initialize();
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();

        setState(() {
          _mediaFiles.add(file);
          _mediaTypes.add('video');
          _videoControllers.add(controller);
        });
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
                  "Reise auswählen",
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

                onChanged: (value) async {
                  if (value == null) return;

                  final trip = trips.firstWhere((e) => e.id == value);

                  setState(() {
                    selectedTripId = value;

                    selectedTripTitle =
                        (trip.data() as Map<String, dynamic>)['title'];
                  });

                  await _showTripDaySelector();
                },
              ),
            ],
          ),
        );
      },
    );
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

    final result = await showModalBottomSheet<Map<String, dynamic>>(
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
                    Navigator.pop(sheetContext, {
                      "number": index + 1,
                      "date": date,
                    });
                  },
                );
              }),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        selectedTripDayNumber = result["number"];
      });
    }
  }

  Future<void> _uploadPost() async {
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
    final strings = S.of(context)!;
    final postRef = _firestore.collection('Posts').doc();
    final postId = postRef.id;
    if (!_isFormValid) return;
    setState(() => _isUploading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      List<String> mediaUrls = [];
      List<String> thumbnailUrls = [];

      for (int i = 0; i < _mediaFiles.length; i++) {
        final file = _mediaFiles[i];
        final type = _mediaTypes[i];
        final ext = type == 'image' ? 'jpg' : 'mp4';

        final ref = _storage.ref().child(
          'users/${user.uid}/posts/$postId/$i.$ext',
        );

        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        mediaUrls.add(url);

        if (type == 'video') {
          final thumbData = await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.JPEG,
            quality: 75,
          );
          if (thumbData != null) {
            final thumbRef = _storage.ref().child(
              'users/${user.uid}/posts/$postId/thumbnails/$i.jpg',
            );
            await thumbRef.putData(thumbData);
            final thumbUrl = await thumbRef.getDownloadURL();
            thumbnailUrls.add(thumbUrl);
          } else {
            thumbnailUrls.add('');
          }
        } else {
          thumbnailUrls.add('');
        }
      }

      final rawText = _descriptionController.text.trim();

      // Hashtags MIT # speichern
      final hashtags = RegExp(
        r'#\w+',
      ).allMatches(rawText).map((m) => m.group(0)!).toList();

      // Caption OHNE Hashtags speichern
      final cleanCaption = rawText
          .replaceAll(RegExp(r'#\w+'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      String username = 'User';
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['username'] != null) {
        username = userDoc.data()!['username'];
      }

      await postRef.set({
        'postId': postId,
        'mediaUrls': mediaUrls,
        'mediaTypes': _mediaTypes,
        'thumbnailUrls': thumbnailUrls, // 👈 DAS FEHLT
        'location': _locationController.text.trim(),
        'caption': cleanCaption,
        'hashtag': hashtags,
        'createdTime': Timestamp.now(),
        'uid': user.uid,
        'username': username,
        'commentCount': 0,
        'tripId': selectedTripId,

        'tripDayId': selectedTripDayId,

        'tripDayNumber': selectedTripDayNumber,

        'forumRegion': selectedForumRegion,
        'forumCountry': selectedForumCountry,
        'forumTopic': selectedForumTopic,
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainNavigationPage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Upload Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.uploadError)));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;

    final isDark = ref.watch(darkModeProvider).value ?? false;

    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.grey.shade200;
    final accentColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          strings.uploadPost,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        leading: BackButton(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMediaPreview(cardColor, isDark),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _locationController,
              label: strings.addLocation,
              textColor: textColor,
              labelColor: labelColor,
              accentColor: accentColor,
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _descriptionController,
              label: strings.description,
              textColor: textColor,
              labelColor: labelColor,
              accentColor: accentColor,
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            _selectTripCard(textColor, labelColor),

            _selectForumCard(textColor, labelColor),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.withValues(
                    alpha: _isFormValid ? 1 : 0.5,
                  ),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(strings.publishPost),
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
    int? maxLines = 1,
  }) {
    return TextField(
      controller: controller,
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
          borderSide: BorderSide(color: Colors.white54),
        ),
      ),
      cursorColor: accentColor,
    );
  }

  Widget _buildMediaPreview(Color cardColor, bool isDark) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mediaFiles.length + (_mediaFiles.length < 10 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaFiles.length) {
            return GestureDetector(
              onTap: _pickMedia,
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                ),
                child: const Center(child: Icon(Icons.add, size: 40)),
              ),
            );
          }

          final file = _mediaFiles[index];
          final type = _mediaTypes[index];

          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: cardColor,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (type == 'image')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(file, fit: BoxFit.cover),
                  ),

                if (type == 'video')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: VideoPlayer(_videoControllers[index]!),
                  ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _videoControllers[index]?.dispose();
                        _videoControllers.removeAt(index);
                        _mediaFiles.removeAt(index);
                        _mediaTypes.removeAt(index);
                      });
                    },
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class VideoPreviewPage extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoPreviewPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
