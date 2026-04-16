import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/user_profil_page.dart';

class QATab extends StatelessWidget {
  final bool isDarkMode;

  const QATab({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('Questions')
          .orderBy('createdTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final questions = snapshot.data!.docs;

        if (questions.isEmpty) {
          return const Center(child: Text("Keine Fragen vorhanden"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final doc = questions[index];
            final data = doc.data() as Map<String, dynamic>;

            return _QuestionCard(
              questionId: doc.id,
              data: data,
              isDarkMode: isDarkMode,
            );
          },
        );
      },
    );
  }
}

class _QuestionCard extends StatefulWidget {
  final String questionId;
  final Map<String, dynamic> data;
  final bool isDarkMode;

  const _QuestionCard({
    required this.questionId,
    required this.data,
    required this.isDarkMode,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  final TextEditingController _answerController = TextEditingController();
  bool isExpanded = false;

  Future<void> _sendAnswer() async {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;

    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user == null) return;

    final userDoc = await firestore.collection('Users').doc(user.uid).get();
    final userData = userDoc.data() ?? {};

    await firestore
        .collection('Questions')
        .doc(widget.questionId)
        .collection('Answers')
        .add({
          'answer': text,
          'createdTime': Timestamp.now(),
          'userId': user.uid,
          'username': userData['username'] ?? 'User',
          'profilePicture': userData['profilePicture'], // ⭐ wichtig für UI
          'likes': [],
        });

    _answerController.clear();
  }

  void _showQuestionActions(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = uid == widget.data['userId'];

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
                  title: const Text("Bearbeiten"),
                  onTap: () {
                    Navigator.pop(context);
                    _editQuestion();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Löschen"),
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
                  title: const Text("Melden"),
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

  void _showAnswerActions(
    BuildContext context,
    String answerId,
    Map<String, dynamic> a,
  ) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = uid == a['userId'];

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
                  title: const Text("Bearbeiten"),
                  onTap: () {
                    Navigator.pop(context);
                    _editAnswer(answerId, a['answer']);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Löschen"),
                  onTap: () async {
                    Navigator.pop(context);

                    await FirebaseFirestore.instance
                        .collection('Questions')
                        .doc(widget.questionId)
                        .collection('Answers')
                        .doc(answerId)
                        .delete();
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Melden"),
                  onTap: () {
                    Navigator.pop(context);

                    FirebaseFirestore.instance.collection('Reports').add({
                      'type': 'answer',
                      'targetId': answerId,
                      'questionId': widget.questionId,
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

  void _editAnswer(String answerId, String oldText) {
    final controller = TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Antwort bearbeiten"),
        content: TextField(controller: controller, maxLines: 5),
        actions: [
          TextButton(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Speichern"),
            onPressed: () async {
              final text = controller.text.trim();
              await FirebaseFirestore.instance
                  .collection('Questions')
                  .doc(widget.questionId)
                  .collection('Answers')
                  .doc(answerId)
                  .update({'answer': text});

              if (!mounted) return;

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _editQuestion() {
    final controller = TextEditingController(text: widget.data['question']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Frage bearbeiten"),
        content: TextField(controller: controller, maxLines: 5),
        actions: [
          TextButton(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Speichern"),
            onPressed: () async {
              final text = controller.text.trim();
              await FirebaseFirestore.instance
                  .collection('Questions')
                  .doc(widget.questionId)
                  .update({'question': text});

              if (!mounted) return;

              Navigator.of(context).pop;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final data = widget.data;

    return GestureDetector(
      onLongPress: () => _showQuestionActions(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
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

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeago.format(
                        (data['createdTime'] as Timestamp).toDate(),
                        locale: 'de',
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    const SizedBox(width: 6),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(data['question'] ?? '', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            // TOGGLE
            StreamBuilder<int>(
              stream: FirebaseFirestore.instance
                  .collection('Questions')
                  .doc(widget.questionId)
                  .collection('Answers')
                  .snapshots()
                  .map((snapshot) => snapshot.docs.length),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;

                return GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: Text(
                    isExpanded
                        ? "Antworten ausblenden"
                        : "Antworten anzeigen ($count)",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 6),

            if (isExpanded) ...[
              _AnswerInputField(
                controller: _answerController,
                onSend: _sendAnswer,
                isDarkMode: widget.isDarkMode,
              ),

              const SizedBox(height: 10),

              StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('Questions')
                    .doc(widget.questionId)
                    .collection('Answers')
                    .orderBy('createdTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final answers = snapshot.data!.docs;

                  return Column(
                    children: answers.map((doc) {
                      final a = doc.data() as Map<String, dynamic>;
                      final likes = List<String>.from(a['likes'] ?? []);
                      final uid = "currentUserId";

                      final isLiked = likes.contains(uid);

                      return GestureDetector(
                        onLongPress: () =>
                            _showAnswerActions(context, doc.id, a),
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, left: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: firestore
                                    .collection('Users')
                                    .doc(a['userId'])
                                    .get(),
                                builder: (context, snap) {
                                  final user =
                                      snap.data?.data()
                                          as Map<String, dynamic>?;

                                  return CircleAvatar(
                                    radius: 14,
                                    backgroundImage:
                                        user?['profilePicture'] != null
                                        ? NetworkImage(user!['profilePicture'])
                                        : null,
                                    child: user?['profilePicture'] == null
                                        ? const Icon(Icons.person, size: 14)
                                        : null,
                                  );
                                },
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a['username'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(a['answer'] ?? ''),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
                                          color: isLiked
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        onPressed: () async {
                                          final ref = firestore
                                              .collection('Questions')
                                              .doc(widget.questionId)
                                              .collection('Answers')
                                              .doc(doc.id);

                                          await FirebaseFirestore.instance
                                              .runTransaction((tx) async {
                                                final fresh = await tx.get(ref);
                                                final data =
                                                    fresh.data()
                                                        as Map<String, dynamic>;

                                                List likes = List.from(
                                                  data['likes'] ?? [],
                                                );

                                                if (likes.contains(uid)) {
                                                  likes.remove(uid);
                                                } else {
                                                  likes.add(uid);
                                                }

                                                tx.update(ref, {
                                                  'likes': likes,
                                                });
                                              });
                                        },
                                      ),

                                      Text("${likes.length}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// INPUT FIELD
class _AnswerInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isDarkMode;

  const _AnswerInputField({
    required this.controller,
    required this.onSend,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,

            minLines: 1,
            maxLines: 3, // ✔ wächst bis 3 Zeilen, dann scrollt es

            keyboardType: TextInputType.multiline,

            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),

            decoration: InputDecoration(
              hintText: "Antwort schreiben...",

              filled: true,
              fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[200],

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        IconButton(
          icon: const Icon(Icons.send, color: Colors.blue),
          onPressed: onSend,
        ),
      ],
    );
  }
}
