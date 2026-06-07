import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPostsStream({int limit = 50}) {
    return _firestore
        .collection('Posts')
        .orderBy('createdTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> toggleLike(
    String postId,
    List<dynamic> hearts,
    String userId,
    String postOwnerId,
  ) async {
    final current = List<String>.from(hearts);

    final isLiked = current.contains(userId);

    if (isLiked) {
      current.remove(userId);
    } else {
      current.add(userId);
    }

    await _firestore.collection('Posts').doc(postId).update({
      'hearts': current,
    });
  }
}
