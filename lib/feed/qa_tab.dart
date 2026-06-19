import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/user_profil_page.dart';
import '../l10n/s.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dark_mode_provider.dart';

class QATab extends StatefulWidget {
  const QATab({super.key});

  @override
  State<QATab> createState() => _QATabState();
}

class _QATabState extends State<QATab> {
  String _searchQuery = '';
  bool _showSearch = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Consumer(
      builder: (context, ref, _) {
        final isDark = ref.watch(darkModeProvider).value ?? false;

        final bg = isDark ? Colors.black : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            title: _showSearch
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Fragen suchen...",
                      hintStyle: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  )
                : const SizedBox.shrink(),

            centerTitle: true,

            actions: [
              IconButton(
                icon: Icon(
                  _showSearch ? Icons.close : Icons.search,
                  color: textColor,
                ),
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;

                    if (!_showSearch) {
                      _searchController.clear();
                      _searchQuery = '';
                    }
                  });
                },
              ),
            ],
          ),

          body: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('Questions')
                .orderBy('createdTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final questions = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final question = (data['question'] ?? '')
                    .toString()
                    .toLowerCase();

                return question.contains(_searchQuery);
              }).toList();

              final strings = S.of(context)!;

              if (questions.isEmpty) {
                return Center(
                  child: Text(
                    strings.noQuestions,
                    style: TextStyle(color: textColor),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final doc = questions[index];
                  final data = doc.data() as Map<String, dynamic>;

                  return _QuestionCard(questionId: doc.id, data: data);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _QuestionCard extends ConsumerStatefulWidget {
  final String questionId;
  final Map<String, dynamic> data;

  const _QuestionCard({required this.questionId, required this.data});

  @override
  ConsumerState<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends ConsumerState<_QuestionCard> {
  void _showQuestionActions(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = uid == widget.data['userId'];
    final strings = S.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOwner) ...[
                ListTile(
                  leading: const Icon(Icons.edit),

                  title: Text(strings.edit),
                  onTap: () {
                    Navigator.pop(context);
                    _editQuestion();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: Text(strings.delete),
                  onTap: () async {
                    Navigator.pop(context);
                    await FirebaseFirestore.instance
                        .collection('Questions')
                        .doc(widget.questionId)
                        .delete();
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: Text(strings.report),
                  onTap: () {
                    Navigator.pop(context);
                    FirebaseFirestore.instance.collection('Reports').add({
                      'type': 'question',
                      'targetId': widget.questionId,
                      'reportedBy': uid,
                      'createdAt': Timestamp.now(),
                    });
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _editQuestion() {
    final controller = TextEditingController(text: widget.data['question']);
    final strings = S.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(strings.editQuestion),
        content: TextField(controller: controller, maxLines: 5),
        actions: [
          TextButton(
            child: Text(strings.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(strings.save),
            onPressed: () async {
              final text = controller.text.trim();
              await FirebaseFirestore.instance
                  .collection('Questions')
                  .doc(widget.questionId)
                  .update({'question': text});

              if (!mounted) return;

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final firestore = FirebaseFirestore.instance;
    final data = widget.data;
    // final strings = S.of(context)!;

    return GestureDetector(
      onLongPress: () => _showQuestionActions(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: firestore
                      .collection('Users')
                      .doc(data['userId'])
                      .get(),
                  builder: (context, snap) {
                    final user = snap.data?.data() as Map<String, dynamic>?;

                    return CircleAvatar(
                      backgroundImage: user?['profilePicture'] != null
                          ? NetworkImage(user!['profilePicture'])
                          : null,
                      child: user?['profilePicture'] == null
                          ? const Icon(Icons.person)
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OtherUserProfilePage(userId: data['userId']),
                        ),
                      );
                    },
                    child: Text(
                      data['username'] ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(data['question'] ?? '', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            StreamBuilder<int>(
              stream: FirebaseFirestore.instance
                  .collection('Questions')
                  .doc(widget.questionId)
                  .snapshots()
                  .asyncMap((_) async {
                    final answersSnap = await FirebaseFirestore.instance
                        .collection('Questions')
                        .doc(widget.questionId)
                        .collection('Answers')
                        .get();

                    int replyCount = 0;

                    for (final answer in answersSnap.docs) {
                      final repliesSnap = await FirebaseFirestore.instance
                          .collection('Questions')
                          .doc(widget.questionId)
                          .collection('Answers')
                          .doc(answer.id)
                          .collection('Replies')
                          .get();

                      replyCount += repliesSnap.docs.length;
                    }

                    return answersSnap.docs.length + replyCount;
                  }),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _CommentSheet(
                            questionId: widget.questionId,
                            questionData: widget.data,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "$count",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentSheet extends ConsumerStatefulWidget {
  final String questionId;
  final Map<String, dynamic> questionData;

  const _CommentSheet({required this.questionId, required this.questionData});

  @override
  ConsumerState<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<_CommentSheet> {
  String? replyingToAnswerId;
  String? replyingToUsername;
  Set<String> expandedReplies = {};
  bool isEditing = false;

  String? editingAnswerId;
  String? editingReplyId;
  String? editingParentAnswerId;

  final TextEditingController controller = TextEditingController();

  Future<void> deleteAnswer(String answerId) async {
    final repliesRef = FirebaseFirestore.instance
        .collection('Questions')
        .doc(widget.questionId)
        .collection('Answers')
        .doc(answerId)
        .collection('Replies');

    final replies = await repliesRef.get();

    for (var r in replies.docs) {
      await r.reference.delete();
    }

    await FirebaseFirestore.instance
        .collection('Questions')
        .doc(widget.questionId)
        .collection('Answers')
        .doc(answerId)
        .delete();
  }

  void showCommentActions({
    required String text,
    required String id,
    required bool isReply,
    String? parentAnswerId,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Bearbeiten"),
                onTap: () {
                  Navigator.pop(context);

                  startEdit(
                    id: id,
                    isReply: isReply,
                    parentAnswerId: parentAnswerId,
                    currentText: text,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text("Löschen"),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(
                    id: id,
                    isReply: isReply,
                    parentAnswerId: parentAnswerId,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void startEdit({
    required String id,
    required bool isReply,
    String? parentAnswerId,
    required String currentText,
  }) {
    setState(() {
      isEditing = true;

      controller.text = currentText;

      if (isReply) {
        editingReplyId = id;
        editingParentAnswerId = parentAnswerId;
        editingAnswerId = null;
      } else {
        editingAnswerId = id;
        editingReplyId = null;
        editingParentAnswerId = null;
      }
    });
  }

  void _confirmDelete({
    required String id,
    required bool isReply,
    String? parentAnswerId,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Löschen",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Bist du sicher, dass du das löschen willst?"),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Nein"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          if (isReply) {
                            await FirebaseFirestore.instance
                                .collection('Questions')
                                .doc(widget.questionId)
                                .collection('Answers')
                                .doc(parentAnswerId)
                                .collection('Replies')
                                .doc(id)
                                .delete();
                          } else {
                            await deleteAnswer(id);
                          }
                        },
                        child: const Text("Ja"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data() ?? {};

    // =========================
    // 🔥 EDIT MODE
    // =========================
    if (isEditing) {
      if (editingAnswerId != null) {
        await FirebaseFirestore.instance
            .collection('Questions')
            .doc(widget.questionId)
            .collection('Answers')
            .doc(editingAnswerId)
            .update({'answer': text});
      }

      if (editingReplyId != null) {
        await FirebaseFirestore.instance
            .collection('Questions')
            .doc(widget.questionId)
            .collection('Answers')
            .doc(editingParentAnswerId)
            .collection('Replies')
            .doc(editingReplyId)
            .update({'reply': text});
      }

      setState(() {
        isEditing = false;
        editingAnswerId = null;
        editingReplyId = null;
        editingParentAnswerId = null;
      });

      controller.clear();
      return;
    }

    // =========================
    // 🔥 CREATE MODE (Antwort / Reply)
    // =========================

    if (replyingToAnswerId != null) {
      await FirebaseFirestore.instance
          .collection('Questions')
          .doc(widget.questionId)
          .collection('Answers')
          .doc(replyingToAnswerId)
          .collection('Replies')
          .add({
            'reply': text,
            'createdTime': Timestamp.now(),
            'userId': user.uid,
            'username': userData['username'] ?? 'User',
            'profilePicture': userData['profilePicture'],
            'likes': [],
          });

      setState(() {
        replyingToAnswerId = null;
        replyingToUsername = null;
      });

      controller.clear();
      return;
    }

    await FirebaseFirestore.instance
        .collection('Questions')
        .doc(widget.questionId)
        .collection('Answers')
        .add({
          'answer': text,
          'createdTime': Timestamp.now(),
          'userId': user.uid,
          'username': userData['username'] ?? 'User',
          'profilePicture': userData['profilePicture'],
          'likes': [],
        });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 🔥 QUESTION
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.deepPurple[300]
                  : const Color(0xFFB388FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.questionData['question'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 LISTE
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('Questions')
                  .doc(widget.questionId)
                  .collection('Answers')
                  .orderBy('createdTime')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final a = docs[index].data() as Map<String, dynamic>;
                    final answerId = docs[index].id;

                    final currentUid = FirebaseAuth.instance.currentUser?.uid;

                    final likes = List<String>.from(a['likes'] ?? []);
                    final isLiked = likes.contains(currentUid);
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    final isOwner = uid == a['userId'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onLongPress: () {
                          if (!isOwner) return;

                          showCommentActions(
                            text: a['answer'],
                            id: answerId,
                            isReply: false,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: a['profilePicture'] != null
                                  ? NetworkImage(a['profilePicture'])
                                  : null,
                              child: a['profilePicture'] == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),

                            const SizedBox(width: 10),

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
                                            userId: a['userId'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      a['username'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(a['answer'] ?? ''),

                                  const SizedBox(height: 6),

                                  // 👉 ACTION ROW
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // LINKS: Antworten
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              replyingToAnswerId = answerId;
                                              replyingToUsername =
                                                  a['username'] ?? 'User';
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              replyingToAnswerId == answerId
                                                  ? "Antwort aktiv"
                                                  : "Antworten",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      // RECHTS: LIKE
                                      GestureDetector(
                                        onTap: () async {
                                          final uid = FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid;
                                          if (uid == null) return;

                                          final ref = FirebaseFirestore.instance
                                              .collection('Questions')
                                              .doc(widget.questionId)
                                              .collection('Answers')
                                              .doc(answerId);

                                          if (isLiked) {
                                            await ref.update({
                                              'likes': FieldValue.arrayRemove([
                                                uid,
                                              ]),
                                            });
                                          } else {
                                            await ref.update({
                                              'likes': FieldValue.arrayUnion([
                                                uid,
                                              ]),
                                            });
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              isLiked
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_alt_outlined,
                                              size: 20,
                                              color: isLiked
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "${a['likes']?.length ?? 0}",
                                              style: TextStyle(
                                                color: isLiked
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // 👉 REPLIES (EINGERÜCKT)
                                  StreamBuilder<QuerySnapshot>(
                                    stream: firestore
                                        .collection('Questions')
                                        .doc(widget.questionId)
                                        .collection('Answers')
                                        .doc(answerId)
                                        .collection('Replies')
                                        .orderBy('createdTime')
                                        .snapshots(),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return const SizedBox();
                                      }

                                      final replies = snap.data!.docs;
                                      final count = replies.length;

                                      if (count == 0) return const SizedBox();

                                      final isOpen = expandedReplies.contains(
                                        answerId,
                                      );

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 👉 TOGGLE BUTTON
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isOpen) {
                                                  expandedReplies.remove(
                                                    answerId,
                                                  );
                                                } else {
                                                  expandedReplies.add(answerId);
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 6,
                                              ),
                                              child: Text(
                                                isOpen
                                                    ? "Antworten ausblenden"
                                                    : "Antworten anzeigen ($count)",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 👉 REPLIES LIST (nur wenn geöffnet)
                                          if (isOpen)
                                            Column(
                                              children: replies.map((r) {
                                                final currentUid = FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.uid;

                                                final reply =
                                                    r.data()
                                                        as Map<String, dynamic>;

                                                final replyLikes =
                                                    List<String>.from(
                                                      reply['likes'] ?? [],
                                                    );
                                                final isReplyLiked = replyLikes
                                                    .contains(currentUid);

                                                final replyRef =
                                                    FirebaseFirestore.instance
                                                        .collection('Questions')
                                                        .doc(widget.questionId)
                                                        .collection('Answers')
                                                        .doc(answerId)
                                                        .collection('Replies')
                                                        .doc(r.id);

                                                final uid = FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.uid;
                                                final isOwner =
                                                    uid == reply['userId'];

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 0,
                                                        top: 10,
                                                      ),
                                                  child: GestureDetector(
                                                    onLongPress: () {
                                                      if (!isOwner) return;

                                                      showCommentActions(
                                                        text: reply['reply'],
                                                        id: r.id,
                                                        isReply: true,
                                                        parentAnswerId:
                                                            answerId,
                                                      );
                                                    },
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // 👤 Avatar
                                                        CircleAvatar(
                                                          radius: 16,
                                                          backgroundImage:
                                                              reply['profilePicture'] !=
                                                                  null
                                                              ? NetworkImage(
                                                                  reply['profilePicture'],
                                                                )
                                                              : null,
                                                          child:
                                                              reply['profilePicture'] ==
                                                                  null
                                                              ? const Icon(
                                                                  Icons.person,
                                                                  size: 16,
                                                                )
                                                              : null,
                                                        ),

                                                        const SizedBox(
                                                          width: 10,
                                                        ),

                                                        // 👇 TEXT BLOCK
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (_) => OtherUserProfilePage(
                                                                        userId:
                                                                            reply['userId'],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  reply['username'] ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                reply['reply'] ??
                                                                    '',
                                                              ),
                                                            ],
                                                          ),
                                                        ),

                                                        // ❤️ LIKE BUTTON (optional, kannst du später erweitern)
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final uid =
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid;
                                                            if (uid == null) {
                                                              return;
                                                            }

                                                            if (isReplyLiked) {
                                                              await replyRef
                                                                  .update({
                                                                    'likes':
                                                                        FieldValue.arrayRemove(
                                                                          [uid],
                                                                        ),
                                                                  });
                                                            } else {
                                                              await replyRef
                                                                  .update({
                                                                    'likes':
                                                                        FieldValue.arrayUnion(
                                                                          [uid],
                                                                        ),
                                                                  });
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                isReplyLiked
                                                                    ? Icons
                                                                          .thumb_up
                                                                    : Icons
                                                                          .thumb_up_alt_outlined,
                                                                size: 18,
                                                                color:
                                                                    isReplyLiked
                                                                    ? Colors
                                                                          .blue
                                                                    : Colors
                                                                          .grey,
                                                              ),

                                                              const SizedBox(
                                                                width: 6,
                                                              ),

                                                              Text(
                                                                "${replyLikes.length}",
                                                                style: TextStyle(
                                                                  fontSize: 13,
                                                                  color:
                                                                      isReplyLiked
                                                                      ? Colors
                                                                            .blue
                                                                      : Colors
                                                                            .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          if (replyingToAnswerId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        replyingToAnswerId = null;
                        replyingToUsername = null;
                      });
                    },
                    child: const Icon(Icons.close, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Antwort an $replyingToUsername",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          // 👉 INPUT (DYNAMISCH)
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: isEditing
                              ? "Bearbeitung..."
                              : replyingToAnswerId != null
                              ? "Antwort schreiben..."
                              : "Kommentar schreiben...",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(isEditing ? Icons.check : Icons.send),
                      color: isEditing ? Colors.green : Colors.deepPurple,
                      onPressed: send,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatefulWidget {
  final String questionId;

  const _CommentInput({required this.questionId});

  @override
  State<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<_CommentInput> {
  final controller = TextEditingController();

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data() ?? {};

    await FirebaseFirestore.instance
        .collection('Questions')
        .doc(widget.questionId)
        .collection('Answers')
        .add({
          'answer': text,
          'createdTime': Timestamp.now(),
          'userId': user.uid,
          'username': userData['username'] ?? 'User',
          'profilePicture': userData['profilePicture'],
          'likes': [],
        });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Kommentar schreiben...",
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: send),
        ],
      ),
    );
  }
}
