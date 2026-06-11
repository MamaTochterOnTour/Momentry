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

  Future<void> _uploadPost() async {
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
