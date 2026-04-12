import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/s.dart';

class StoryCreatePage extends StatefulWidget {
  final bool isDarkMode;
  const StoryCreatePage({super.key, required this.isDarkMode});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  File? _selectedFile;
  String? _fileType;
  VideoPlayerController? _videoController;
  bool _isPublishing = false;

  // Story Elements
  final List<_StoryText> _texts = [];
  _StoryDate? _date;
  int _currentFilterIndex = 0;
  List<String> filters = ['Normal', 'B&W', 'Sepia'];

  // Inline Text Editing
  final TextEditingController _textController = TextEditingController();
  bool _editingText = false;
  _StoryText? _activeText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pickMedia());
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result == null) return;

    final file = File(result.files.single.path!);
    final ext = result.files.single.extension?.toLowerCase();
    final isVideo = ['mp4', 'mov', 'avi'].contains(ext);

    setState(() {
      _selectedFile = file;
      _fileType = isVideo ? 'video' : 'image';
    });

    if (isVideo) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file)
        ..setLooping(true)
        ..initialize().then((_) => setState(() {}));
    }
  }

  void _toggleDate() {
    setState(() {
      if (_date == null) {
        _date = _StoryDate(
          show: true,
          color: Colors.white,
          font: "Roboto",
          size: 18,
          position: const Offset(16, 16),
        );
      } else {
        _date!.show = !_date!.show;
      }
    });
  }

  void _addText() {
    final strings = S.of(context)!;
    final newText = _StoryText(
      text: strings.newText,
      position: const Offset(100, 100),
      size: 24,
      color: Colors.white,
      font: "Roboto",
    );
    setState(() {
      _texts.add(newText);
      _activeText = newText;
      _textController.text = newText.text;
      _editingText = true;
    });
  }

  void _finishEditingText() {
    if (_activeText != null) {
      setState(() {
        _activeText!.text = _textController.text;
        _editingText = false;
        _activeText = null;
        _textController.clear();
      });
    }
  }

  Future<void> _publishStory() async {
    final strings = S.of(context)!;
    if (_selectedFile == null || _isPublishing) return;
    setState(() => _isPublishing = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.${_fileType == 'video' ? 'mp4' : 'jpg'}";
    final storageRef = FirebaseStorage.instance.ref().child(
      "users/$uid/stories/$fileName",
    );

    await storageRef.putFile(_selectedFile!);
    final mediaUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection("stories").add({
      "userId": uid,
      "mediaUrl": mediaUrl,
      "mediaType": _fileType,
      "filter": filters[_currentFilterIndex],
      "texts": _texts.map((t) => t.toMap()).toList(),
      "date": _date?.toMap(),
      "createdAt": Timestamp.now(),
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.storySaved)));
      Navigator.pop(context);
    }
  }

  void _nextFilter() {
    setState(() {
      _currentFilterIndex = (_currentFilterIndex + 1) % filters.length;
    });
  }

  void _previousFilter() {
    setState(() {
      _currentFilterIndex =
          (_currentFilterIndex - 1 + filters.length) % filters.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          strings.createStory,
          style: GoogleFonts.pacifico(color: textColor),
        ),
        actions: [
          IconButton(onPressed: _publishStory, icon: const Icon(Icons.send)),
        ],
      ),
      body: _selectedFile == null
          ? Center(
              child: Text(
                strings.pickMedia,
                style: TextStyle(color: textColor),
              ),
            )
          : GestureDetector(
              onTap: () {
                if (_editingText) _finishEditingText();
              },
              child: Stack(
                children: [
                  // Media mit Filter
                  Positioned.fill(
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          _nextFilter();
                        } else if (details.primaryVelocity! > 0) {
                          _previousFilter();
                        }
                      },
                      child: ColorFiltered(
                        colorFilter: _currentFilterIndex == 1
                            ? const ColorFilter.mode(
                                Colors.white,
                                BlendMode.saturation,
                              )
                            : _currentFilterIndex == 2
                            ? const ColorFilter.mode(
                                Color(0xFF704214),
                                BlendMode.modulate,
                              )
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.multiply,
                              ),
                        child:
                            _fileType == 'video' &&
                                _videoController != null &&
                                _videoController!.value.isInitialized
                            ? VideoPlayer(_videoController!)
                            : Image.file(_selectedFile!, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  // Datum
                  if (_date != null && _date!.show)
                    Positioned(
                      left: _date!.position.dx,
                      top: _date!.position.dy,
                      child: GestureDetector(
                        onPanUpdate: (e) =>
                            setState(() => _date!.position += e.delta),
                        child: Text(
                          "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                          style: TextStyle(
                            fontSize: _date!.size,
                            color: _date!.color,
                            fontFamily: _date!.font,
                          ),
                        ),
                      ),
                    ),

                  // Texte
                  for (var t in _texts)
                    Positioned(
                      left: t.position.dx,
                      top: t.position.dy,
                      child: GestureDetector(
                        onPanUpdate: (e) =>
                            setState(() => t.position += e.delta),
                        onTap: () {
                          setState(() {
                            _activeText = t;
                            _textController.text = t.text;
                            _editingText = true;
                          });
                        },
                        child: Text(
                          t.text,
                          style: GoogleFonts.getFont(
                            t.font,
                            fontSize: t.size,
                            color: t.color,
                          ),
                        ),
                      ),
                    ),

                  // Inline Text Editing UI
                  if (_editingText)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _textController,
                            autofocus: true,
                            style: GoogleFonts.getFont(
                              _activeText?.font ?? "Roboto",
                              fontSize: _activeText?.size ?? 24,
                              color: _activeText?.color ?? Colors.white,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black26,
                              hintText: strings.enterText,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _activeText?.text = val;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Farbe
                              IconButton(
                                onPressed: () async {
                                  Color newColor =
                                      _activeText?.color ?? Colors.white;
                                  await showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(strings.pickColor),
                                      content: BlockPicker(
                                        pickerColor: newColor,
                                        onColorChanged: (c) {
                                          setState(() {
                                            _activeText?.color = c;
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(strings.ok),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.color_lens),
                              ),
                              // Schriftart
                              DropdownButton<String>(
                                value: _activeText?.font ?? "Roboto",
                                items:
                                    [
                                          "Roboto",
                                          "Pacifico",
                                          "Lobster",
                                          "OpenSans",
                                        ]
                                        .map(
                                          (f) => DropdownMenuItem(
                                            value: f,
                                            child: Text(
                                              f,
                                              style: TextStyle(fontFamily: f),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _activeText?.font = val ?? "Roboto";
                                  });
                                },
                              ),
                              // Größe erhöhen/verkleinern
                              IconButton(
                                onPressed: () =>
                                    setState(() => _activeText!.size += 2),
                                icon: const Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (_activeText!.size > 10) {
                                      _activeText!.size -= 2;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              // Löschen
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _texts.remove(_activeText);
                                    _editingText = false;
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: _selectedFile != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "text",
                  onPressed: _addText,
                  child: const Icon(Icons.text_fields),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "date",
                  onPressed: _toggleDate,
                  child: const Icon(Icons.date_range),
                ),
              ],
            )
          : null,
    );
  }
}

// --- Models ---
class _StoryText {
  String text;
  Offset position;
  double size;
  Color color;
  String font;
  _StoryText({
    required this.text,
    required this.position,
    required this.size,
    required this.color,
    required this.font,
  });

  Map<String, dynamic> toMap() => {
    "text": text,
    "position": {"dx": position.dx, "dy": position.dy},
    "size": size,
    "color": color.toARGB32(),
    "font": font,
  };
}

class _StoryDate {
  bool show;
  Offset position;
  double size;
  Color color;
  String font;
  _StoryDate({
    required this.show,
    required this.position,
    required this.size,
    required this.color,
    required this.font,
  });

  Map<String, dynamic> toMap() => {
    "show": show,
    "position": {"dx": position.dx, "dy": position.dy},
    "size": size,
    "color": color.toARGB32(),
    "font": font,
  };
}
