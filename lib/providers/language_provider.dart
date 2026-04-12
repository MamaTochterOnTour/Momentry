import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

// Provider
final languageProvider = NotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);

class LanguageNotifier extends Notifier<String> {
  @override
  String build() {
    // Default Sprache
    loadLanguage();
    return 'de';
  }

  Future<void> loadLanguage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final savedLanguage = doc.data()?['language'];

    if (savedLanguage != null) {
      // Gespeicherte Sprache laden
      state = savedLanguage;
    } else {
      // Neues oder altes Konto ohne gespeicherte Sprache
      final deviceLanguage =
          PlatformDispatcher.instance.locale.languageCode; // 'de', 'en', etc.

      // Bestehende Nutzer → Default 'de'
      state = doc.exists ? 'de' : (deviceLanguage == 'en' ? 'en' : 'de');

      // Firestore speichern
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
        'language': state,
      }, SetOptions(merge: true));
    }
  }

  Future<void> setLanguage(String lang) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    state = lang;
    await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      'language': lang,
    }, SetOptions(merge: true));
  }
}
