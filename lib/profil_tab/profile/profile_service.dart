import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> fetchProfileData() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final userDoc = await _firestore.collection('Users').doc(user.uid).get();

    final reisenSnap = await _firestore
        .collection('Reisetagebcher')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdTime', descending: true)
        .get();

    final beitraegeSnap = await _firestore
        .collection('Posts')
        .where('uid', isEqualTo: user.uid)
        .orderBy('createdTime', descending: true)
        .get();

    final followRef = _firestore.collection('Follow');

    final followerSnap = await followRef
        .where('followingId', isEqualTo: user.uid)
        .get();

    final followingSnap = await followRef
        .where('followerId', isEqualTo: user.uid)
        .get();

    return {
      'userData': userDoc.data(),
      'reisen': reisenSnap.docs.map((e) => {...e.data(), 'id': e.id}).toList(),
      'beitraege': beitraegeSnap.docs
          .map((e) => {...e.data(), 'id': e.id})
          .toList(),
      'followerCount': followerSnap.docs.length,
      'followingCount': followingSnap.docs.length,
      'followerIds': followerSnap.docs
          .map((doc) => doc['followerId'] as String)
          .toList(),
      'followingIds': followingSnap.docs
          .map((doc) => doc['followingId'] as String)
          .toList(),
    };
  }
}
