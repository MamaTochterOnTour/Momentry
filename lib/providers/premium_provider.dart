import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final premiumProvider = StreamProvider<bool>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value(false);
  }

  return FirebaseFirestore.instance
      .collection('Users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return false;
        return doc.data()?['isPremium'] == true;
      });
});
