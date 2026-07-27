import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../profil_tab/other_user_profil_page.dart';

import 'package:google_fonts/google_fonts.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;

  const GroupInfoPage({super.key, required this.groupId});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  final TextEditingController _descriptionController = TextEditingController();

  bool editingDescription = false;

  Future<void> saveDescription() async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .update({"description": _descriptionController.text.trim()});

    setState(() {
      editingDescription = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text("Gruppeninfo", style: GoogleFonts.pacifico(fontSize: 24)),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(widget.groupId)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final title = data["title"] ?? "Gruppe";

          final description = data["description"] ?? "";

          final creatorId = data["creatorId"];

          final members = List<String>.from(data["members"] ?? []);

          if (_descriptionController.text.isEmpty) {
            _descriptionController.text = description;
          }

          return ListView(
            padding: const EdgeInsets.all(20),

            children: [
              // Gruppen Titel
              Center(
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${members.length} Mitglieder",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Beschreibung
              const Text(
                "Gruppenbeschreibung",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              if (editingDescription)
                Column(
                  children: [
                    TextField(
                      controller: _descriptionController,

                      maxLines: 5,

                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),

                    Align(
                      alignment: Alignment.centerRight,

                      child: ElevatedButton(
                        onPressed: saveDescription,

                        child: const Text("Speichern"),
                      ),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: () {
                    setState(() {
                      editingDescription = true;
                    });
                  },

                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Text(
                      description.isEmpty
                          ? "Tippen um Beschreibung hinzuzufügen"
                          : description,
                    ),
                  ),
                ),

              const SizedBox(height: 35),

              Text(
                "Mitglieder",

                style: const TextStyle(
                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ...members.map((uid) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(uid)
                      .get(),

                  builder: (context, userSnap) {
                    if (!userSnap.hasData) {
                      return const SizedBox();
                    }

                    final userData =
                        userSnap.data!.data() as Map<String, dynamic>?;

                    final username = userData?["username"] ?? "Unbekannt";

                    final profilePicture = userData?["profilePicture"] ?? "";

                    final isCreator = uid == creatorId;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: CircleAvatar(
                        radius: 25,

                        backgroundImage: profilePicture.isNotEmpty
                            ? NetworkImage(profilePicture)
                            : null,

                        child: profilePicture.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),

                      title: Row(
                        children: [
                          Text(username),

                          if (isCreator)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),

                              child: Text("👑", style: TextStyle(fontSize: 18)),
                            ),
                        ],
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => OtherUserProfilePage(userId: uid),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
