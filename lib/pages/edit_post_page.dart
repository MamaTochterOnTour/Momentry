import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_player/video_player.dart';
import '../../l10n/s.dart'; // <-- Lokalisierung

class EditPostPage extends StatefulWidget {
  final String postId;
  final bool isDarkMode;

  const EditPostPage({
    super.key,
    required this.postId,
    required this.isDarkMode,
  });

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  bool _isSaving = false;

  Map<String, dynamic>? _postData;
  Map<String, dynamic>? _userData;

  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();

  final List<File> _newImages = [];
  final List<File> _newVideos = [];

  final List<String> _removedUrls = [];

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    try {
      final doc = await _firestore.collection('Posts').doc(widget.postId).get();
      if (doc.exists) {
        _postData = doc.data();

        _captionController.text = _postData?['caption'] ?? '';
        _locationController.text = _postData?['location'] ?? '';
        _hashtagsController.text =
            (_postData?['hashtag'] as List<dynamic>?)?.join(' ') ?? '';

        if (_postData?['uid'] != null) {
          final userDoc = await _firestore
              .collection('Users')
              .doc(_postData!['uid'])
              .get();
          if (userDoc.exists) _userData = userDoc.data();
        }
      }
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
      if (!mounted) return;
      final strings = S.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.postUpdateError)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();

    // Bilder auswählen (mehrere)
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      for (XFile file in pickedFiles) {
        if (!mounted) return;
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: S.of(context)!.imageCropTitle,
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
            ),
            IOSUiSettings(aspectRatioLockEnabled: true),
          ],
        );
        if (croppedFile != null) {
          _newImages.add(File(croppedFile.path));
        }
      }
      setState(() {});
    }

    // Video auswählen (einzeln)
    final XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedVideo != null) {
      setState(() => _newVideos.add(File(pickedVideo.path)));
    }
  }

  Future<void> _removeMedia(int index, bool isNew) async {
    setState(() {
      if (isNew) {
        if (index < _newImages.length) {
          _newImages.removeAt(index);
        } else {
          _newVideos.removeAt(index - _newImages.length);
        }
      } else {
        final url = _postData!['mediaUrls'][index];
        _removedUrls.add(url);
      }
    });
  }

  Future<void> _savePost() async {
    if (_postData == null) return;

    setState(() => _isSaving = true);
    final strings = S.of(context)!;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      List<String> mediaUrls = List<String>.from(_postData?['mediaUrls'] ?? []);
      List<String> mediaTypes = List<String>.from(
        _postData?['mediaTypes'] ?? [],
      );
      List<String> thumbnailUrls = List<String>.from(
        _postData?['thumbnailUrls'] ?? [],
      );

      // Entfernte URLs löschen
      for (String url in _removedUrls) {
        final index = mediaUrls.indexOf(url);
        if (index != -1) {
          mediaUrls.removeAt(index);
          mediaTypes.removeAt(index);
          thumbnailUrls.removeAt(index);
        }
      }

      // Neue Bilder hochladen
      for (File img in _newImages) {
        final ref = _storage.ref().child(
          'users/${user.uid}/uploads/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await ref.putFile(img);
        final url = await ref.getDownloadURL();
        mediaUrls.add(url);
        mediaTypes.add('image');
        thumbnailUrls.add(''); // Bilder brauchen kein Thumbnail
      }

      // Neue Videos hochladen
      for (File vid in _newVideos) {
        final ref = _storage.ref().child(
          'users/${user.uid}/uploads/${DateTime.now().millisecondsSinceEpoch}.mp4',
        );
        await ref.putFile(vid);
        final url = await ref.getDownloadURL();
        mediaUrls.add(url);
        mediaTypes.add('video');
        thumbnailUrls.add('');
      }

      final hashtags = _hashtagsController.text
          .split(RegExp(r'\s+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await _firestore.collection('Posts').doc(widget.postId).update({
        'caption': _captionController.text.trim(),
        'location': _locationController.text.trim(),
        'hashtag': hashtags,
        'mediaUrls': mediaUrls,
        'mediaTypes': mediaTypes,
        'thumbnailUrls': thumbnailUrls,
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.postUpdateSuccess)));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      debugPrint('Fehler beim Speichern: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.postUpdateError)));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final textSecondaryColor = widget.isDarkMode
        ? Colors.white70
        : Colors.black54;
    final iconColor = widget.isDarkMode ? Colors.white : Colors.black;
    final strings = S.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          strings.editPostTitle,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
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
                  // Profil + Username
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            _userData != null &&
                                _userData!['profilePicture'] != null
                            ? NetworkImage(_userData!['profilePicture'])
                            : null,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _postData?['username'] ?? strings.user,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Multi-Media Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (_postData?['mediaUrls']?.length ?? 0) +
                        _newImages.length +
                        _newVideos.length +
                        1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),
                    itemBuilder: (context, index) {
                      final existingCount =
                          _postData?['mediaUrls']?.length ?? 0;

                      // Add Button
                      if (index ==
                          existingCount +
                              _newImages.length +
                              _newVideos.length) {
                        return GestureDetector(
                          onTap: _pickMedia,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      // Neue Bilder
                      if (index < _newImages.length) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _newImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => _removeMedia(index, true),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Neue Videos
                      if (index < _newImages.length + _newVideos.length) {
                        final videoIndex = index - _newImages.length;
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: VideoThumbnailPreview(
                                file: _newVideos[videoIndex],
                              ),
                            ),
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => _removeMedia(index, true),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      // Bestehende Media
                      final mediaIndex =
                          index - _newImages.length - _newVideos.length;
                      final url = _postData!['mediaUrls'][mediaIndex];
                      final type = _postData!['mediaTypes'][mediaIndex];

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: type == 'image'
                                ? Image.network(url, fit: BoxFit.cover)
                                : VideoThumbnailPreview(
                                    url: url,
                                    isNetwork: true,
                                  ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () => _removeMedia(mediaIndex, false),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Caption
                  TextField(
                    controller: _captionController,
                    style: TextStyle(color: textColor),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: strings.caption,
                      labelStyle: TextStyle(color: textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location
                  TextField(
                    controller: _locationController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: strings.location,
                      labelStyle: TextStyle(color: textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Hashtags
                  TextField(
                    controller: _hashtagsController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: strings.hashtags,
                      labelStyle: TextStyle(color: textSecondaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Speichern Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _savePost,
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
}

// --- Video Vorschau Widget ---
class VideoThumbnailPreview extends StatefulWidget {
  final File? file;
  final String? url;
  final bool isNetwork;

  const VideoThumbnailPreview({
    this.file,
    this.url,
    this.isNetwork = false,
    super.key,
  });

  @override
  State<VideoThumbnailPreview> createState() => _VideoThumbnailPreviewState();
}

class _VideoThumbnailPreviewState extends State<VideoThumbnailPreview> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.isNetwork) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    } else {
      _controller = VideoPlayerController.file(widget.file!);
    }

    _controller.initialize().then((_) {
      setState(() => _initialized = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _initialized
        ? GestureDetector(
            onTap: () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                if (!_controller.value.isPlaying)
                  const Icon(
                    Icons.play_circle_fill,
                    size: 48,
                    color: Colors.white,
                  ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
