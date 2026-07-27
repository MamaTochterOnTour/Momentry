import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/s.dart';
import '../erstellen_tab/edit_travel_diary_page.dart';

class TravelDiaryDetailPage extends StatefulWidget {
  final String diaryId;
  final bool isDarkMode;

  const TravelDiaryDetailPage({
    super.key,
    required this.diaryId,
    required this.isDarkMode,
  });

  @override
  State<TravelDiaryDetailPage> createState() => _TravelDiaryDetailPageState();
}

class _TravelDiaryDetailPageState extends State<TravelDiaryDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  Map<String, dynamic>? _diaryData;

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
        setState(() {
          _diaryData = doc.data();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
      setState(() => _isLoading = false);
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
          strings.travelDiary,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
        leading: BackButton(color: iconColor),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: iconColor),
            onSelected: (value) async {
              if (value == 'delete') {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(strings.confirmDeleteTitle),
                    content: Text(strings.confirmDeleteText),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(strings.no),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(strings.yes),
                      ),
                    ],
                  ),
                );

                if (!context.mounted) return;

                if (shouldDelete == true) {
                  try {
                    await _firestore
                        .collection('Reisetagebcher')
                        .doc(widget.diaryId)
                        .delete();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.diaryDeleted)),
                    );

                    Navigator.of(context).pop();
                  } catch (e) {
                    if (!context.mounted) return;

                    SnackBar(content: Text(strings.deleteError(e.toString())));
                  }
                }
              }

              if (value == 'edit') {
                final navigator = Navigator.of(context);

                final updated = await navigator.push(
                  MaterialPageRoute(
                    builder: (_) => EditTravelDiaryPage(
                      diaryId: widget.diaryId,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );

                if (!context.mounted) return;

                if (updated == true) {
                  await _loadDiary();
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(strings.edit)),
              PopupMenuItem(value: 'delete', child: Text(strings.delete)),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: iconColor))
          : _diaryData == null
          ? Center(
              child: Text(
                strings.diaryNotFound,
                style: TextStyle(color: textColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _diaryData!['titel'] ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _diaryData!['beschreibung'] ?? '',
                    style: TextStyle(fontSize: 16, color: textSecondaryColor),
                  ),
                  const SizedBox(height: 16),

                  if (_diaryData!['images'] != null &&
                      (_diaryData!['images'] as List).isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: (_diaryData!['images'] as List).length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final item = _diaryData!['images'][index];

                          final String url;
                          final String type;

                          if (item is String) {
                            url = item;
                            type = 'image';
                          } else {
                            url = item['url'];
                            type = item['type'] ?? 'image';
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: type == 'image'
                                ? Image.network(
                                    url,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.black,
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        color: Colors.white,
                                        size: 64,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
