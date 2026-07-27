import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../profil_tab/other_user_profil_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dark_mode_provider.dart';
import '../../providers/premium_provider.dart';
import '../../profil_tab/premium_verwalten_page.dart';
import 'group_info_page.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  final String groupId;

  const GroupChatPage({super.key, required this.groupId});

  @override
  ConsumerState<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? editingMessageId;

  String? replyingToId;
  String? replyingToUser;
  String? replyingToText;

  bool isSearching = false;
  String searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  bool _readLimitSnackbarShown = false;

  bool isMember = false;

  bool _initialScrollDone = false;

  int sentMessages = 0;
  int readMessages = 0;

  bool canRead = true;
  bool canWrite = true;

  @override
  void initState() {
    super.initState();
    _checkMembership();
    _loadUsage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkMembership() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get();

    final data = doc.data() as Map<String, dynamic>;
    final members = List<String>.from(data['members'] ?? []);

    setState(() {
      isMember = members.contains(user.uid);
    });
  }

  Future<void> _loadUsage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final data = doc.data();

    if (data == null) return;

    final premium = ref
        .read(premiumProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);

    setState(() {
      sentMessages = data['groupMessagesSent'] ?? 0;
      readMessages = data['groupMessagesRead'] ?? 0;

      canWrite = premium || sentMessages < 10;
      canRead = premium || readMessages < 50;
    });
  }

  Future<void> _joinGroup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (!ref
        .read(premiumProvider)
        .maybeWhen(data: (value) => value, orElse: () => false)) {
      final groups = await FirebaseFirestore.instance
          .collection('groups')
          .where('members', arrayContains: user.uid)
          .get();

      if (!mounted) return;

      if (groups.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Kostenlos kannst du nur einer Gruppe beitreten. Schalte Premium frei, um unbegrenzt Gruppen beizutreten.",
            ),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: "Premium",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PremiumPage(uid: user.uid)),
                );
              },
            ),
          ),
        );
        return;
      }
    }

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .update({
          'members': FieldValue.arrayUnion([user.uid]),
        });

    setState(() => isMember = true);
  }

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (!canWrite) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Dein kostenloses Nachrichtenlimit ist erreicht. Schalte Premium frei und lese/ sende unbegrenzt Nachrichten.",
          ),
          action: SnackBarAction(
            label: "Premium",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PremiumPage(uid: FirebaseAuth.instance.currentUser!.uid),
                ),
              );
            },
          ),
        ),
      );
      return;
    }

    final messagesRef = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages');

    if (editingMessageId != null) {
      await messagesRef.doc(editingMessageId).update({'text': text});

      setState(() {
        editingMessageId = null;
      });
    } else {
      await messagesRef.add({
        'text': text,

        'userId': user.uid,

        'createdAt': Timestamp.now(),

        if (replyingToId != null)
          'replyTo': {
            'messageId': replyingToId,
            'username': replyingToUser,
            'text': replyingToText,
          },
      });
      final premium = ref
          .read(premiumProvider)
          .maybeWhen(data: (value) => value, orElse: () => false);

      setState(() {
        sentMessages++;
        canWrite = premium || sentMessages < 10;
      });

      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update(
        {'groupMessagesSent': sentMessages},
      );
    }

    _messageController.clear();

    setState(() {
      replyingToId = null;
      replyingToUser = null;
      replyingToText = null;
    });

    _scrollToBottom(); // 👈 DAS IST DER FIX
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String getDateLabel(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Heute";
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Gestern";
    }

    return "${date.day}.${date.month}.${date.year}";
  }

  void _showMessageOptions(
    BuildContext context,
    String messageId,
    String text,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Bearbeiten"),
                onTap: () {
                  Navigator.pop(context);
                  _editMessage(messageId, text);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Löschen"),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(messageId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editMessage(String messageId, String text) {
    setState(() {
      editingMessageId = messageId;
      _messageController.text = text;
    });
  }

  void _replyToMessage(String id, String username, String text) {
    setState(() {
      replyingToId = id;
      replyingToUser = username;
      replyingToText = text;
    });
  }

  void _confirmDelete(String messageId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nachricht löschen?"),
        actions: [
          TextButton(
            child: const Text("Nein"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Ja"),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .doc(messageId)
                  .delete();

              if (!mounted) return;

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkModeAsync = ref.watch(darkModeProvider);

    final isPremium = ref
        .watch(premiumProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);

    final isDarkMode = darkModeAsync.when(
      data: (v) => v,
      loading: () => false,
      error: (_, _) => false,
    );
    final bgColor = isDarkMode ? const Color(0xFF0F0F0F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey;
    final inputColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.grey.shade200;
    final bubbleOther = isDarkMode
        ? const Color(0xFF1C1C1E)
        : Colors.grey.shade200;
    final bubbleMe = isDarkMode
        ? const Color(0xFF2F6BFF)
        : Colors.blue.shade200;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,

        leading: const BackButton(),

        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Nachrichten suchen...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupId)
                    .snapshots(),

                builder: (context, snapshot) {
                  final data = snapshot.data?.data() as Map<String, dynamic>?;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              GroupInfoPage(groupId: widget.groupId),
                        ),
                      );
                    },

                    child: Text(
                      data?['title'] ?? "Gruppe",
                      textAlign: TextAlign.center,
                      maxLines: ((data?['title'] ?? "").length > 25) ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.pacifico(
                        fontSize: ((data?['title'] ?? "").length > 25)
                            ? 18
                            : 20,
                        height: 1.15,
                      ),
                    ),
                  );
                },
              ),

        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),

            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchQuery = "";
                  _searchController.clear();
                } else {
                  isSearching = true;
                }
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// 💬 MESSAGES
          Expanded(
            child: isMember
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .collection('messages')
                        .orderBy('createdAt')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;

                        final text = (data["text"] ?? "")
                            .toString()
                            .toLowerCase();

                        return text.contains(searchQuery);
                      }).toList();

                      if (!isPremium &&
                          readMessages < messages.length &&
                          mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          final newReadMessages = messages.length > 50
                              ? 50
                              : messages.length;

                          if (newReadMessages != readMessages) {
                            setState(() {
                              readMessages = newReadMessages;
                              canRead = readMessages < 50;
                            });

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'groupMessagesRead': readMessages});

                            if (!mounted) return;

                            if (!canRead && !_readLimitSnackbarShown) {
                              _readLimitSnackbarShown = true;

                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Dein kostenloses Nachrichtenlimit ist erreicht. Schalte Premium frei und lese/sende unbegrenzt Nachrichten.",
                                  ),
                                  action: SnackBarAction(
                                    label: "Premium",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PremiumPage(
                                            uid: FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        });
                      }

                      final visibleMessages = canRead
                          ? messages
                          : messages
                                .skip(
                                  messages.length > 50
                                      ? messages.length - 50
                                      : 0,
                                )
                                .toList();

                      if (!_initialScrollDone) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                            _initialScrollDone = true;
                          }
                        });
                      }

                      if (messages.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("💬", style: TextStyle(fontSize: 52)),
                                SizedBox(height: 16),
                                Text(
                                  "Noch keine Nachrichten",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Sei der Erste und starte die Unterhaltung! ✈️",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: false,
                        itemCount: visibleMessages.length,
                        itemBuilder: (context, index) {
                          final data =
                              visibleMessages[index].data()
                                  as Map<String, dynamic>;

                          final createdAt =
                              (data['createdAt'] as Timestamp?)?.toDate() ??
                              DateTime.now();

                          bool showDate = false;

                          if (index == 0) {
                            showDate = true;
                          } else {
                            final previousData =
                                visibleMessages[index - 1].data()
                                    as Map<String, dynamic>;

                            final previousDate =
                                (previousData['createdAt'] as Timestamp?)
                                    ?.toDate() ??
                                DateTime.now();

                            showDate =
                                previousDate.day != createdAt.day ||
                                previousDate.month != createdAt.month ||
                                previousDate.year != createdAt.year;
                          }

                          final text = data['text'] ?? '';
                          final userId = data['userId'];

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(userId)
                                .get(),
                            builder: (context, userSnap) {
                              final userData =
                                  userSnap.data?.data()
                                      as Map<String, dynamic>?;

                              final username =
                                  userData?['username'] ?? 'Unbekannt';
                              final profilePicture =
                                  userData?['profilePicture'] ?? '';

                              final currentUserId =
                                  FirebaseAuth.instance.currentUser?.uid;
                              final isMe = userId == currentUserId;

                              return Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (showDate)
                                    Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          getDateLabel(createdAt),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),

                                  Align(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: GestureDetector(
                                      onLongPress: isMe
                                          ? () => _showMessageOptions(
                                              context,
                                              visibleMessages[index].id,
                                              text,
                                            )
                                          : null,

                                      child: Dismissible(
                                        key: ValueKey(
                                          visibleMessages[index].id,
                                        ),

                                        direction: DismissDirection.startToEnd,

                                        confirmDismiss: (_) async {
                                          _replyToMessage(
                                            visibleMessages[index].id,
                                            username,
                                            text,
                                          );

                                          return false;
                                        },

                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          constraints: BoxConstraints(
                                            maxWidth:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.75,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isMe
                                                ? bubbleMe
                                                : bubbleOther,
                                            borderRadius: BorderRadius.only(
                                              topLeft: const Radius.circular(
                                                14,
                                              ),
                                              topRight: const Radius.circular(
                                                14,
                                              ),
                                              bottomLeft: Radius.circular(
                                                isMe ? 14 : 0,
                                              ),
                                              bottomRight: Radius.circular(
                                                isMe ? 0 : 14,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Avatar
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundImage:
                                                    profilePicture.isNotEmpty
                                                    ? NetworkImage(
                                                        profilePicture,
                                                      )
                                                    : null,
                                                child: profilePicture.isEmpty
                                                    ? const Icon(
                                                        Icons.person,
                                                        size: 16,
                                                      )
                                                    : null,
                                              ),

                                              const SizedBox(width: 8),

                                              // Text + Name
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
                                                                  userId:
                                                                      userId,
                                                                ),
                                                          ),
                                                        );
                                                      },

                                                      child: Text(
                                                        username,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isMe
                                                              ? Colors.white
                                                              : textColor,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 6),

                                                    // 👇 HIER REIN
                                                    if (data["replyTo"] != null)
                                                      Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                              bottom: 8,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                              top: 6,
                                                              bottom: 6,
                                                              right: 8,
                                                            ),

                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: isMe
                                                                  ? Colors.white
                                                                  : Colors.blue,
                                                              width: 3,
                                                            ),
                                                          ),
                                                        ),

                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,

                                                          children: [
                                                            Text(
                                                              "Antwort auf ${data["replyTo"]["username"]}",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: isMe
                                                                    ? Colors
                                                                          .white70
                                                                    : Colors
                                                                          .blue,
                                                              ),
                                                            ),

                                                            const SizedBox(
                                                              height: 2,
                                                            ),

                                                            Text(
                                                              data["replyTo"]["text"],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,

                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: isMe
                                                                    ? Colors
                                                                          .white70
                                                                    : Colors
                                                                          .grey
                                                                          .shade700,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    // 👇 normale Nachricht bleibt darunter
                                                    Text(
                                                      text,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,

                                                        color: isMe
                                                            ? Colors.white
                                                            : textColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),

          /// 🚫 NOT MEMBER VIEW
          if (!isMember)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: _joinGroup,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1A1A1A)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.group_add,
                            size: 50,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Du bist noch kein Mitglied dieser Gruppe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tippe hier, um der Gruppe beizutreten und Nachrichten zu lesen & schreiben",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          /// ✍️ INPUT FIELD (only if member)
          if (isMember)
            if (replyingToId != null)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 8),

                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Antwort auf $replyingToUser",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            replyingToText ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.close),

                      onPressed: () {
                        setState(() {
                          replyingToId = null;
                          replyingToUser = null;
                          replyingToText = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Nachricht schreiben...",
                        hintStyle: TextStyle(color: subTextColor),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      editingMessageId != null ? Icons.check : Icons.send,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
