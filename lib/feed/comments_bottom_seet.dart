import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/s.dart';
import '../pages/user_profil_page.dart';
import 'package:timeago/timeago.dart' as timeago;

// ---------------- CommentsBottomSheet ----------------
class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final bool isDarkMode;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    required this.isDarkMode,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  String? _replyToCommentId;
  String? _replyToUsername;

  // ---------------- Kommentar posten ----------------
  Future<void> _postComment() async {
    final user = _auth.currentUser;

    if (user == null || _commentController.text.trim().isEmpty) return;

    final commentText = _commentController.text.trim();

    // 1. Kommentar speichern
    final commentRef = await _firestore.collection('Comments').add({
      'postId': widget.postId,
      'userId': user.uid,
      'text': commentText,
      'createdAt': FieldValue.serverTimestamp(),
      'parentCommentId': _replyToCommentId,
      'likesCount': 0,
      'likedBy': [],
    });

    // 2. Post Kommentar Count
    await _firestore.collection('Posts').doc(widget.postId).update({
      'commentCount': FieldValue.increment(1),
    });

    // 3. 🔥 ACTIVITY LOGIK START
    String? toUserId;

    // CASE A: COMMENT (kein Reply)
    if (_replyToCommentId == null) {
      final postSnap = await _firestore
          .collection('Posts')
          .doc(widget.postId)
          .get();

      toUserId = postSnap.data()?['uid'];
    }
    // CASE B: REPLY
    else {
      final parentCommentSnap = await _firestore
          .collection('Comments')
          .doc(_replyToCommentId)
          .get();

      toUserId = parentCommentSnap.data()?['userId'];
    }

    // 4. Activity speichern (nur wenn nicht eigene Aktion)
    if (toUserId != null && toUserId != user.uid) {
      await _firestore.collection('activities').add({
        'type': _replyToCommentId == null ? 'comment' : 'reply',
        'fromUserId': user.uid,
        'toUserId': toUserId,
        'postId': widget.postId,
        'commentId': commentRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // 5. Reset UI
    _commentController.clear();

    setState(() {
      _replyToCommentId = null;
      _replyToUsername = null;
    });
  }

  // ---------------- Kommentar bearbeiten ----------------
  // ignore: unused_element
  Future<void> _editComment(String commentId, String currentText) async {
    final controller = TextEditingController(text: currentText);
    final strings = S.of(context)!;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editContact),
        content: TextField(controller: controller, maxLines: null),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _firestore.collection('Comments').doc(commentId).update({
                  'text': controller.text.trim(),
                });

                // Prüfen, ob Widget noch im Baum ist
                if (!mounted) return;

                Navigator.pop(context); // schließt das Dialog / Screen
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fehler beim Speichern: $e')),
                );
              }
            },
            child: Text(strings.saveButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final strings = S.of(context)!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                strings.comments,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 8),

              // ---------------- Kommentare ----------------
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Comments')
                      .where('postId', isEqualTo: widget.postId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: textColor),
                      );
                    }

                    final allComments = snapshot.data!.docs;

                    // Hauptkommentare filtern (parentCommentId == null)
                    final rootComments = allComments.where((c) {
                      final data = c.data() as Map<String, dynamic>;
                      return data['parentCommentId'] == null;
                    }).toList();

                    if (rootComments.isEmpty) {
                      return Center(
                        child: Text(
                          strings.noComments,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: rootComments.length,
                      itemBuilder: (context, index) {
                        final comment = rootComments[index];

                        // Replies filtern
                        final replies = allComments.where((c) {
                          final data = c.data() as Map<String, dynamic>;
                          return data['parentCommentId'] == comment.id;
                        }).toList();

                        return CommentTile(
                          comment: comment,
                          replies: replies,
                          isDarkMode: widget.isDarkMode,
                          onReply: (username) {
                            setState(() {
                              _replyToCommentId = comment.id;
                              _replyToUsername = username;
                            });
                          },
                          onEdit: (commentToEdit) async {
                            final controller = TextEditingController(
                              text: commentToEdit['text'],
                            );
                            await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(strings.editComment),
                                content: TextField(
                                  controller: controller,
                                  maxLines: null,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(strings.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await _firestore
                                            .collection('Comments')
                                            .doc(commentToEdit.id)
                                            .update({
                                              'text': controller.text.trim(),
                                            });

                                        if (!context.mounted) {
                                          return;
                                        }
                                        Navigator.pop(
                                          context,
                                        ); // Dialog schließen
                                      } catch (e) {
                                        if (!context.mounted) {
                                          return;
                                        }
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Fehler beim Speichern: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(strings.save),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDelete: (commentToDelete) async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(strings.deleteCommentTitle),
                                content: Text(strings.deleteCommentContent),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(strings.no),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(strings.yes),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await _firestore
                                  .collection('Comments')
                                  .doc(commentToDelete.id)
                                  .delete();

                              // Kommentaranzahl im Post-Dokument verringern
                              final postRef = _firestore
                                  .collection('Posts')
                                  .doc(commentToDelete['postId']);
                              await postRef.update({
                                'commentCount': FieldValue.increment(-1),
                              });
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // Antwort abbrechen Button oben über TextField
              if (_replyToUsername != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          strings.replyingTo(_replyToUsername ?? 'User'),
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _replyToCommentId = null;
                            _replyToUsername = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // ---------------- Textfeld ----------------
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            minLines: 1, // startet mit 1 Zeile
                            maxLines: 3, // wächst maximal auf 3 Zeilen
                            keyboardType: TextInputType
                                .multiline, // erlaubt Zeilenumbruch mit Enter
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: _replyToUsername != null
                                  ? strings.writeReplyHint
                                  : strings.writeCommentHint,
                              hintStyle: TextStyle(color: secondaryColor),
                              filled: true,
                              fillColor: widget.isDarkMode
                                  ? Colors.white12
                                  : Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                          onPressed: _postComment,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ), // <-- hier der Abstand unter Textfeld + Button
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- CommentTile ----------------
class CommentTile extends StatelessWidget {
  final QueryDocumentSnapshot comment;
  final List<QueryDocumentSnapshot> replies;
  final bool isDarkMode;
  final Function(String username) onReply;
  final Function(QueryDocumentSnapshot comment) onEdit;
  final Function(QueryDocumentSnapshot comment) onDelete;

  const CommentTile({
    super.key,
    required this.comment,
    required this.replies,
    required this.isDarkMode,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
  });

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return timeago.format(dateTime, locale: 'de'); // vor x Stunden/Minuten
  }

  Future<void> _toggleLike(String commentId, List likedBy) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseFirestore.instance
        .collection('Comments')
        .doc(commentId);

    final isLiked = likedBy.contains(uid);

    if (isLiked) {
      await ref.update({
        'likedBy': FieldValue.arrayRemove([uid]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await ref.update({
        'likedBy': FieldValue.arrayUnion([uid]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final strings = S.of(context)!;
    final data = comment.data() as Map<String, dynamic>;

    final likesCount = data['likesCount'] ?? 0;
    final likedBy = List<String>.from(data['likedBy'] ?? []);
    final isLiked = likedBy.contains(currentUserId);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('Users')
          .doc(comment['userId'])
          .get(),
      builder: (context, snapshot) {
        String username = 'User';
        String profilePic = '';

        if (snapshot.hasData && snapshot.data!.data() != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          username = data['username'] ?? 'User';
          profilePic = data['profilePicture'] ?? '';
        }

        final isOwnComment =
            comment['userId'] == FirebaseAuth.instance.currentUser?.uid;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Hauptkommentar ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF8C77FF),
                    backgroundImage: profilePic.isNotEmpty
                        ? NetworkImage(profilePic)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OtherUserProfilePage(
                                  userId: comment['userId'],
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor, // wieder normale Farbe
                            ),
                          ),
                        ),
                        Text(
                          comment['text'],
                          style: TextStyle(color: textColor),
                        ),
                        Row(
                          children: [
                            Text(
                              formatTimestamp(comment['createdAt']),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),

                            // ❤️ LIKE BUTTON
                            GestureDetector(
                              onTap: () => _toggleLike(comment.id, likedBy),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    likesCount.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => onReply(username),
                          child: Text(
                            strings.reply,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // PopupMenu für eigene und fremde Kommentare
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        onEdit(comment);
                      } else if (value == 'delete') {
                        onDelete(comment);
                      } else if (value == 'report') {
                        await FirebaseFirestore.instance
                            .collection('commentReports')
                            .add({
                              'reportedBy':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'reportedCommentId': comment.id,
                              'reason': 'Kommentar melden',
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        if (!context.mounted) return; // <-- WICHTIG
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.commentReported)),
                        );
                      }
                    },
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    itemBuilder: (_) => isOwnComment
                        ? [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                strings.editAction,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                strings.deleteButton,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ]
                        : [
                            PopupMenuItem(
                              value: 'report',
                              child: Text(
                                strings.report,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                  ),
                ],
              ),

              // ---------------- Replies ----------------
              if (replies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 8),
                  child: Column(
                    children: replies.map((reply) {
                      final replyData = reply.data() as Map<String, dynamic>;
                      final replyLikes = replyData['likesCount'] ?? 0;
                      final replyLikedBy = List<String>.from(
                        replyData['likedBy'] ?? [],
                      );
                      final isReplyLiked = replyLikedBy.contains(currentUserId);
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(reply['userId'])
                            .get(),
                        builder: (context, snap) {
                          String replyUsername = 'User';
                          String replyPic = '';

                          if (snap.hasData && snap.data!.data() != null) {
                            final data =
                                snap.data!.data() as Map<String, dynamic>;
                            replyUsername = data['username'] ?? 'User';
                            replyPic = data['profilePicture'] ?? '';
                          }

                          final isOwnReply = reply['userId'] == currentUserId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFF8C77FF),
                                  backgroundImage: replyPic.isNotEmpty
                                      ? NetworkImage(replyPic)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  OtherUserProfilePage(
                                                    userId: reply['userId'],
                                                    isDarkMode: isDarkMode,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          replyUsername,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: textColor, // normale Farbe
                                          ),
                                        ),
                                      ),
                                      Text(
                                        reply['text'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            formatTimestamp(reply['createdAt']),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => _toggleLike(
                                              reply.id,
                                              replyLikedBy,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  isReplyLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: 14,
                                                  color: isReplyLiked
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  replyLikes.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      GestureDetector(
                                        onTap: () => onReply(replyUsername),
                                        child: Text(
                                          strings.reply,
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ---------------- PopupMenu für Replies ----------------
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      onEdit(reply);
                                    } else if (value == 'delete') {
                                      onDelete(reply);
                                    } else if (value == 'report') {
                                      await FirebaseFirestore.instance
                                          .collection('commentReports')
                                          .add({
                                            'reportedBy': FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                            'reportedCommentId': reply.id,
                                            'reason': 'Kommentar melden',
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
                                          });

                                      if (!context.mounted) {
                                        return; // <- WICHTIG
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            strings.commentReported,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (_) => isOwnReply
                                      ? [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text(
                                              strings.editAction,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              strings.deleteButton,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : [
                                          PopupMenuItem(
                                            value: 'report',
                                            child: Text(
                                              strings.report,
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                  color: isDarkMode
                                      ? Colors.grey[900]
                                      : Colors.white,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
