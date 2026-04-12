import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final darkModeProvider = StreamProvider<bool>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(false);

  return FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .snapshots()
      .map((snap) => snap.data()?['isDarkMode'] ?? false);
});
