import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../l10n/s.dart';
import 'main_navigation.dart';

class UploadPostPage extends StatefulWidget {
  final bool isDarkMode;
  const UploadPostPage({super.key, required this.isDarkMode});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hashtagsController = TextEditingController();

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
      _descriptionController.text.trim().isNotEmpty &&
      _hashtagsController.text.trim().isNotEmpty;

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    _locationController.dispose();
    _descriptionController.dispose();
    _hashtagsController.dispose();
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
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: strings.cropImage,
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
            ),
            IOSUiSettings(aspectRatioLockEnabled: true),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _mediaFiles.add(File(croppedFile.path));
            _mediaTypes.add('image');
            _videoControllers.add(null);
          });
        }
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
          'users/${user.uid}/uploads/${DateTime.now().millisecondsSinceEpoch}_$i.$ext',
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
              'users/${user.uid}/uploads/thumbnails/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
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

      final hashtags = _hashtagsController.text
          .split(RegExp(r'\s+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      String username = 'User';
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()?['username'] != null) {
        username = userDoc.data()!['username'];
      }

      await _firestore.collection('Posts').doc().set({
        'mediaUrls': mediaUrls,
        'mediaTypes': _mediaTypes,
        'thumbnailUrls': thumbnailUrls,
        'location': _locationController.text.trim(),
        'caption': _descriptionController.text.trim(),
        'hashtag': hashtags,
        'createdTime': Timestamp.now(),
        'uid': user.uid,
        'username': username,
        'commentCount': 0,
      });

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationPage(initialProfileTab: 1),
        ),
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
    final textColor = Colors.white;
    final labelColor = Colors.white70;
    final accentColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
            _buildMediaPreview(),
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
            const SizedBox(height: 16),
            _buildTextField(
              controller: _hashtagsController,
              label: strings.hashtags,
              textColor: textColor,
              labelColor: labelColor,
              accentColor: accentColor,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.withAlpha(
                    _isFormValid ? 255 : (255 * 0.5).toInt(),
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

  Widget _buildMediaPreview() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _mediaFiles.length + (_mediaFiles.length < 10 ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaFiles.length) {
            return GestureDetector(
              onTap: _pickMedia,
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Icon(Icons.add, color: Colors.white70, size: 40),
              ),
            );
          }

          final file = _mediaFiles[index];
          final type = _mediaTypes[index];

          return Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  if (type == 'image') {
                    final croppedFile = await ImageCropper().cropImage(
                      sourcePath: file.path,
                      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 5),
                      uiSettings: [
                        AndroidUiSettings(
                          toolbarTitle: S.of(context)!.cropImage,
                          toolbarColor: Colors.deepPurple,
                          toolbarWidgetColor: Colors.white,
                          lockAspectRatio: true,
                        ),
                        IOSUiSettings(aspectRatioLockEnabled: true),
                      ],
                    );
                    if (croppedFile != null) {
                      setState(
                        () => _mediaFiles[index] = File(croppedFile.path),
                      );
                    }
                  } else if (type == 'video') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPreviewPage(
                          controller: _videoControllers[index]!,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: type == 'image'
                        ? DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: type == 'video' ? Colors.black : null,
                  ),
                  child: type == 'video'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: VideoPlayer(_videoControllers[index]!),
                        )
                      : null,
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
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
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
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
