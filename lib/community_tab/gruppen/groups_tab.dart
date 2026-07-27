import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'group_chat_page.dart';
import '../../erstellen_tab/main_navigation.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  String searchQuery = "";
  bool isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QueryDocumentSnapshot> _sortByTravelDate(
    List<QueryDocumentSnapshot> groups,
  ) {
    final now = DateTime.now();

    groups.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;
      final bData = b.data() as Map<String, dynamic>;

      final aStart = (aData["startDate"] as Timestamp?)?.toDate();
      final aEnd = (aData["endDate"] as Timestamp?)?.toDate();

      final bStart = (bData["startDate"] as Timestamp?)?.toDate();
      final bEnd = (bData["endDate"] as Timestamp?)?.toDate();

      if (aStart == null || aEnd == null) return 1;
      if (bStart == null || bEnd == null) return -1;

      // 0 = läuft
      // 1 = kommt
      // 2 = beendet
      int status(DateTime start, DateTime end) {
        if (now.isAfter(end)) return 2;
        if (now.isAfter(start) && now.isBefore(end)) return 0;
        return 1;
      }

      final aStatus = status(aStart, aEnd);
      final bStatus = status(bStart, bEnd);

      // Erst nach Status sortieren
      if (aStatus != bStatus) {
        return aStatus.compareTo(bStatus);
      }

      // Laufende Reisen → frühestes Enddatum zuerst
      if (aStatus == 0) {
        return aEnd.compareTo(bEnd);
      }

      // Kommende Reisen → frühestes Startdatum zuerst
      if (aStatus == 1) {
        return aStart.compareTo(bStart);
      }

      // Beendete Reisen → zuletzt beendete zuerst
      return bEnd.compareTo(aEnd);
    });

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Nicht eingeloggt"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("groups")
          .orderBy("createdAt", descending: true)
          .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("Keine Gruppen gefunden"));
        }

        final allGroups = snapshot.data!.docs;

        final myGroups = allGroups.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final members = List<String>.from(data["members"] ?? []);

          return members.contains(user.uid);
        }).toList();

        final otherGroups = allGroups.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final members = List<String>.from(data["members"] ?? []);

          return !members.contains(user.uid);
        }).toList();

        final filteredMyGroups = _filterGroups(myGroups);

        final filteredOtherGroups = _sortByTravelDate(
          _filterGroups(otherGroups),
        );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  if (isSearching)
                    Expanded(
                      child: TextField(
                        controller: _searchController,

                        autofocus: true,

                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },

                        decoration: InputDecoration(
                          hintText: "Titel oder Datum suchen...",

                          prefixIcon: const Icon(Icons.search),

                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),

                            onPressed: () {
                              FocusScope.of(context).unfocus();

                              setState(() {
                                isSearching = false;
                                searchQuery = "";
                                _searchController.clear();
                              });
                            },
                          ),

                          filled: true,

                          fillColor: Colors.grey.shade100,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),

                  if (!isSearching)
                    IconButton(
                      icon: const Icon(Icons.search),
                      iconSize: 28,
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                    ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                children: [
                  if (filteredMyGroups.isNotEmpty) ...[
                    const Text(
                      "Deine Gruppen",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ..._sortPinned(filteredMyGroups, user.uid).map(
                      (doc) =>
                          _GroupCard(doc: doc, userId: user.uid, canPin: true),
                    ),
                  ],

                  if (filteredOtherGroups.isNotEmpty) ...[
                    const SizedBox(height: 30),

                    const Text(
                      "Weitere Gruppen",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...filteredOtherGroups.map(
                      (doc) =>
                          _GroupCard(doc: doc, userId: user.uid, canPin: false),
                    ),
                  ],

                  if (filteredMyGroups.isEmpty && filteredOtherGroups.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(30),

                      child: Center(child: Text("Keine Gruppen gefunden 🔍")),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<QueryDocumentSnapshot> _filterGroups(
    List<QueryDocumentSnapshot> groups,
  ) {
    if (searchQuery.isEmpty) {
      return groups;
    }

    return groups.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final title = (data["title"] ?? "").toString().toLowerCase();

      final start = (data["startDate"] as Timestamp?)?.toDate();
      final end = (data["endDate"] as Timestamp?)?.toDate();

      final dateText =
          "${start?.day}.${start?.month}.${start?.year} "
          "${end?.day}.${end?.month}.${end?.year}";

      return title.contains(searchQuery) || dateText.contains(searchQuery);
    }).toList();
  }

  List<QueryDocumentSnapshot> _sortPinned(
    List<QueryDocumentSnapshot> groups,
    String uid,
  ) {
    groups.sort((a, b) {
      final aData = a.data() as Map<String, dynamic>;

      final bData = b.data() as Map<String, dynamic>;

      final aPinned = List<String>.from(aData["pinnedBy"] ?? []).contains(uid);

      final bPinned = List<String>.from(bData["pinnedBy"] ?? []).contains(uid);

      if (aPinned && !bPinned) {
        return -1;
      }

      if (!aPinned && bPinned) {
        return 1;
      }

      return 0;
    });

    return groups;
  }
}

class _GroupCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  final String userId;

  final bool canPin;

  const _GroupCard({
    required this.doc,
    required this.userId,
    required this.canPin,
  });

  String _travelStatus(Map<String, dynamic> data) {
    final start = (data["startDate"] as Timestamp?)?.toDate();

    final end = (data["endDate"] as Timestamp?)?.toDate();

    if (start == null || end == null) {
      return "";
    }

    final now = DateTime.now();

    if (now.isAfter(end)) {
      return "✅ Reise beendet";
    }

    if (now.isAfter(start) && now.isBefore(end)) {
      return "🟢 Reise läuft gerade";
    }

    final days = start.difference(now).inDays;

    return "⏳ Startet in $days Tagen";
  }

  String _dates(Map<String, dynamic> data) {
    final start = (data["startDate"] as Timestamp?)?.toDate();

    final end = (data["endDate"] as Timestamp?)?.toDate();

    if (start == null || end == null) {
      return "";
    }

    return "${start.day}.${start.month}.${start.year}"
        " - "
        "${end.day}.${end.month}.${end.year}";
  }

  Future<void> _togglePin(bool pinned) async {
    final ref = FirebaseFirestore.instance.collection("groups").doc(doc.id);

    if (pinned) {
      await ref.update({
        "pinnedBy": FieldValue.arrayRemove([userId]),
      });
    } else {
      await ref.update({
        "pinnedBy": FieldValue.arrayUnion([userId]),
      });
    }
  }

  void _showGroupOptions(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    final creatorId = data["creatorId"];
    final members = List<String>.from(data["members"] ?? []);

    final isOwner = creatorId == userId;
    final isMember = members.contains(userId);

    if (!isMember) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nur Besitzer
              if (isOwner)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Gruppe bearbeiten"),
                  onTap: () {
                    Navigator.pop(context);
                    MainNavigationPage.openEditGroup(context, doc.id);
                  },
                ),

              // Nur wenn NICHT Ersteller
              if (!isOwner)
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Gruppe verlassen"),
                  onTap: () async {
                    Navigator.pop(context);

                    await FirebaseFirestore.instance
                        .collection("groups")
                        .doc(doc.id)
                        .update({
                          "members": FieldValue.arrayRemove([userId]),
                        });
                  },
                ),

              // Nur Besitzer
              if (isOwner)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    "Gruppe löschen",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    await FirebaseFirestore.instance
                        .collection("groups")
                        .doc(doc.id)
                        .delete();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;

    final members = List<String>.from(data["members"] ?? []);

    final isMember = members.contains(userId);

    final pinned = List<String>.from(data["pinnedBy"] ?? []).contains(userId);

    return Card(
      elevation: 2,

      margin: const EdgeInsets.only(bottom: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GroupChatPage(groupId: doc.id)),
          );
        },

        onLongPress: isMember
            ? () {
                _showGroupOptions(context);
              }
            : null,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data["title"] ?? "Ohne Titel",

                      style: const TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (canPin)
                    IconButton(
                      icon: Icon(
                        pinned ? Icons.push_pin : Icons.push_pin_outlined,

                        color: pinned ? Colors.deepPurple : Colors.grey,
                      ),

                      onPressed: () => _togglePin(pinned),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              Text(_dates(data)),

              const SizedBox(height: 6),

              Text(
                _travelStatus(data),

                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Text(
                "${members.length} Mitglieder",

                style: TextStyle(color: Colors.grey.shade600),
              ),

              if (data["lastMessage"] != null) ...[
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Text(
                    "${data["lastMessageSender"] ?? ""}: "
                    "${data["lastMessage"]}",

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
