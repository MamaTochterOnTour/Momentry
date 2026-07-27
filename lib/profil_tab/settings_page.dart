import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../registrierung/login_page.dart';
import '../registrierung/register_page.dart';
import 'settings_privacy_policy_page.dart';
import 'settings_terms_conditions_page.dart';
import 'settings_contact_feedback_page.dart';
import 'settings_impressum_page.dart';
import '../providers/language_provider.dart';
import '../../l10n/s.dart';
import 'edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  Future<void> _toggleDarkMode(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isDarkMode = value);

    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'isDarkMode': value,
    }, SetOptions(merge: true));

    if (!mounted) return;

    final strings = S.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(strings.darkModeChanged(value ? "Dunkel" : "Hell")),
      ),
    );
  }

  Future<void> _loadDarkMode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final savedMode = doc.data()?['isDarkMode'] ?? false;
      setState(() => _isDarkMode = savedMode);
    }
  }

  // -------------------------------
  // 🔥 ACCOUNT LÖSCHEN – ENTRY POINT
  // -------------------------------
  Future<void> _handleDeleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final providerIds = user.providerData.map((p) => p.providerId).toList();

    if (providerIds.contains('password')) {
      _showPasswordDeleteDialog(context);
    } else {
      _deleteWithOAuth(context);
    }
  }

  // -------------------------------
  // 🔐 PASSWORD-DIALOG (EMAIL LOGIN)
  // -------------------------------
  Future<void> _showPasswordDeleteDialog(BuildContext context) async {
    final strings = S.of(context)!;
    final passwordController = TextEditingController();
    bool isLoading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(strings.passwordDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(strings.passwordDialogDescription),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: strings.passwordDialogLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(strings.cancel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          await _deleteWithPassword(
                            context,
                            dialogContext,
                            passwordController.text.trim(),
                          );
                          setState(() => isLoading = false);
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(strings.deleteConfirm),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // -------------------------------
  // 🔑 EMAIL/PASSWORT DELETE FLOW
  // -------------------------------
  Future<void> _deleteWithPassword(
    BuildContext context,
    BuildContext dialogContext,
    String password,
  ) async {
    final strings = S.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      if (!context.mounted) return;
      if (!dialogContext.mounted) return;

      await _deleteUserDataAndAccount(context, dialogContext);
    } catch (e) {
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.error(e.toString()))));
    }
  }

  // -------------------------------
  // 🍏 GOOGLE / APPLE DELETE FLOW
  // -------------------------------
  Future<void> _deleteWithOAuth(BuildContext context) async {
    final strings = S.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await user.reauthenticateWithProvider(
        OAuthProvider(user.providerData.first.providerId),
      );

      if (!context.mounted) return;
      await _deleteUserDataAndAccount(context, context);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.reauthOAuthError)));
    }
  }

  // -------------------------------
  // 🧹 USERS-DOKUMENT + AUTH + FIRESTORE + STORAGE DELETE
  // -------------------------------
  Future<void> _deleteUserDataAndAccount(
    BuildContext context,
    BuildContext dialogContext,
  ) async {
    final strings = S.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    try {
      Future<void> deleteByField(String collection, String field) async {
        final snap = await firestore
            .collection(collection)
            .where(field, isEqualTo: uid)
            .get();
        for (final doc in snap.docs) {
          await doc.reference.delete();
        }
      }

      await deleteByField('Posts', 'uid');
      await deleteByField('Reisetagebcher', 'uid');
      await deleteByField('Comments', 'userId');
      await deleteByField('Follow', 'followerId');
      await deleteByField('Follow', 'followingId');

      await firestore.collection('Users').doc(uid).delete();

      final storageRef = storage.ref().child('users/$uid');
      await _deleteStorageFolder(storageRef);

      await user.delete();

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
        (_) => false,
      );
    } catch (e) {
      if (dialogContext.mounted) Navigator.pop(dialogContext);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.deleteError(e.toString()))),
      );
    }
  }

  Future<void> _deleteStorageFolder(Reference ref) async {
    final listResult = await ref.listAll();
    for (final item in listResult.items) {
      await item.delete();
    }
    for (final prefix in listResult.prefixes) {
      await _deleteStorageFolder(prefix);
    }
  }

  // -------------------------------
  // UI
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        leading: BackButton(color: textColor),
        title: Text(
          strings.settingsTitle,
          style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.accountSettings,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Dark Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.darkMode,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) async {
                    setState(() => _isDarkMode = value);
                    await _toggleDarkMode(value);
                  },
                  activeThumbColor: Colors.deepPurple,
                  activeTrackColor: Colors.deepPurple.withValues(alpha: 0.4),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Sprache
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.language,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                Consumer(
                  builder: (context, ref, _) {
                    final language = ref.watch(languageProvider);

                    return DropdownButton<String>(
                      value: language,
                      items: const [
                        DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                      onChanged: (value) async {
                        if (value != null) {
                          ref
                              .read(languageProvider.notifier)
                              .setLanguage(value);

                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.uid)
                                .set({
                                  'language': value,
                                }, SetOptions(merge: true));
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sprache auf ${value == "de" ? "Deutsch" : "English"} gesetzt',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // ⭐ NEU: Profil bearbeiten Button
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ),
              child: Text('Profil bearbeiten'),
            ),

            // Passwort zurücksetzen
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null || user.email == null) return;

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: user.email!,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.passwordResetSuccess)),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.error(e.toString()))),
                  );
                }
              },
              child: Text(strings.passwordReset),
            ),

            // Abmelden
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: Text(strings.signOut),
            ),

            // Konto löschen
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () => _handleDeleteAccount(context),
              child: Text(strings.deleteAccount),
            ),

            const SizedBox(height: 24),

            Text(
              strings.legalHelp,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
              ),
              child: Text(strings.privacyPolicy),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
              ),
              child: Text(strings.termsConditions),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactFeedbackPage()),
              ),
              child: Text(strings.contactFeedback),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImpressumPage()),
              ),
              child: Text(strings.impressum),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                strings.appVersion("3.1.0"),
                style: GoogleFonts.nunito(color: textColor, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
