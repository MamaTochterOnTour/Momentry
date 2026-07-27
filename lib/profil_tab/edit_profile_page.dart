import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../l10n/s.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _profilePicture;
  String? _username;
  String? _bio;

  File? _newImage;

  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = true;
  bool _isSavingImage = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_user == null) return;
    setState(() => _isLoading = true);

    try {
      final doc = await _firestore.collection('Users').doc(_user!.uid).get();
      final data = doc.data();
      setState(() {
        _profilePicture = data?['profilePicture'];
        _username = data?['username'] ?? '';
        _bio = data?['bio'] ?? '';
        _usernameController.text = _username!;
        _bioController.text = _bio!;
      });
    } catch (e) {
      debugPrint("Fehler beim Laden der Daten: $e");
      if (!mounted) return;
      // String erst hier im Kontext holen
      final strings = S.of(context)!;
      _showSnackBar(strings.profileDataLoadError);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfilePicture() async {
    final strings = S.of(context)!;
    if (_newImage == null || _user == null) return;

    setState(() => _isSavingImage = true);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(_user!.uid)
          .child('uploads')
          .child('profile.jpg');

      await ref.putFile(_newImage!);
      final url = await ref.getDownloadURL();

      await _firestore.collection('Users').doc(_user!.uid).update({
        'profilePicture': url,
      });

      setState(() {
        _profilePicture = url;
        _newImage = null;
      });

      _showSnackBar(strings.profilePictureSaved);
    } catch (e) {
      debugPrint("Fehler beim Hochladen: $e");
      _showSnackBar(strings.profilePictureUploadError);
    } finally {
      setState(() => _isSavingImage = false);
    }
  }

  Future<void> _saveUsername() async {
    final strings = S.of(context)!;
    if (_user == null) return;

    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) {
      _showSnackBar("${strings.username} darf nicht leer sein");
      return;
    }

    try {
      await _firestore.collection('Users').doc(_user!.uid).update({
        'username': newUsername,
      });
      setState(() => _username = newUsername);
      _showSnackBar(strings.usernameSaved);
    } catch (e) {
      debugPrint("Fehler beim Speichern des Usernames: $e");
      _showSnackBar(strings.usernameSaveError);
    }
  }

  Future<void> _saveBio() async {
    final strings = S.of(context)!;
    if (_user == null) return;

    final newBio = _bioController.text.trim();
    try {
      await _firestore.collection('Users').doc(_user!.uid).update({
        'bio': newBio,
      });
      setState(() => _bio = newBio);
      _showSnackBar(strings.bioSaved);
    } catch (e) {
      debugPrint("Fehler beim Speichern der Biografie: $e");
      _showSnackBar(strings.bioSaveError);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: BackButton(color: textColor),
        title: Text(
          strings.editProfileTitle,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: textColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple.shade200,
                    backgroundImage: _newImage != null
                        ? FileImage(_newImage!)
                        : (_profilePicture != null
                                  ? NetworkImage(_profilePicture!)
                                  : null)
                              as ImageProvider?,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text(strings.changeProfilePicture),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isSavingImage ? null : _saveProfilePicture,
                    child: _isSavingImage
                        ? const CircularProgressIndicator()
                        : Text(strings.saveProfilePicture),
                  ),
                  const Divider(height: 32),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: strings.username,
                      labelStyle: TextStyle(color: textColor),
                      hintText: strings.usernameHint,
                      hintStyle: TextStyle(color: textColor.withAlpha(153)),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveUsername,
                    child: Text(strings.saveUsername),
                  ),
                  const Divider(height: 32),
                  TextField(
                    controller: _bioController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: strings.bio,
                      labelStyle: TextStyle(color: textColor),
                      hintText: strings.bioHint,
                      hintStyle: TextStyle(color: textColor.withAlpha(153)),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveBio,
                    child: Text(strings.saveBio),
                  ),
                ],
              ),
            ),
    );
  }
}
