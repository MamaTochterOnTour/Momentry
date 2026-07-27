import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/dark_mode_provider.dart';

import '../../erstellen_tab/post_detail_page.dart';
import '../../profil_tab/travel_diary_page.dart';
import '../../erstellen_tab/new_travel_diary_page.dart';
import '../../erstellen_tab/upload_post_page.dart';
import '../../profil_tab/other_user_profil_page.dart';

class PostsSearchPage extends ConsumerStatefulWidget {
  final String initialQuery;

  const PostsSearchPage({super.key, required this.initialQuery});

  @override
  ConsumerState<PostsSearchPage> createState() => _PostsSearchPageState();
}

class _PostsSearchPageState extends ConsumerState<PostsSearchPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TabController _tabController;

  String searchQuery = "";

  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchQuery = widget.initialQuery;

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didUpdateWidget(covariant PostsSearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialQuery != widget.initialQuery) {
      setState(() {
        searchQuery = widget.initialQuery;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();

    super.dispose();
  }

  bool matchesSearch(Map<String, dynamic> data) {
    if (searchQuery.trim().isEmpty) {
      return true;
    }

    final query = searchQuery.toLowerCase().trim();

    final searchableText = [
      data["text"] ?? "",
      data["titel"] ?? "",
      data["beschreibung"] ?? "",
      data["caption"] ?? "",
      data["location"] ?? "",
      data["username"] ?? "",
      data["region"] ?? "",
      data["country"] ?? "",
      data["topic"] ?? "",
      data["forumRegion"] ?? "",
      data["forumCountry"] ?? "",
      data["forumTopic"] ?? "",
      if (data["hashtag"] != null) (data["hashtag"] as List).join(" "),
      if (data["hashtags"] != null) (data["hashtags"] as List).join(" "),
    ].join(" ").toLowerCase();

    return searchableText.contains(query);
  }

  // =========================
  // ERFAHRUNGEN
  // =========================

  Stream<QuerySnapshot> _experienceStream() {
    return _firestore
        .collection("forumPosts")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // =========================
  // STORIES
  // =========================

  Stream<QuerySnapshot> _storiesStream() {
    return _firestore
        .collection("Reisetagebcher")
        .orderBy("createdTime", descending: true)
        .snapshots();
  }

  // =========================
  // MOMENTE
  // =========================

  Stream<QuerySnapshot> _momentsStream() {
    return _firestore
        .collection("Posts")
        .orderBy("createdTime", descending: true)
        .snapshots();
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return "";
    }

    final date = timestamp.toDate();

    return "${date.day}.${date.month}.${date.year}";
  }

  void _showForumPostSheet() {
    final postController = TextEditingController();

    String? selectedRegion;
    String? selectedCountry;
    String? selectedTopic;

    bool isGeneral = false;

    DateTimeRange? travelRange;

    final regions = [
      "Europa",
      "Asien",
      "Afrika",
      "Nordamerika",
      "Südamerika",
      "Zentralamerika",
      "Karibik",
      "Australien & Pazifik",
      "Naher Osten",
      "Polarregionen",
    ];

    final generalTopics = [
      "Reiseplanung",

      "Flüge & Airlines",

      "Budget & Sparen",

      "Unterkünfte",

      "Transport & Mobilität",

      "Apps & Technik",

      "Geld & Bezahlen",

      "Einreise & Visa",

      "Gesundheit & Versicherung",

      "Ausrüstung & Packlisten",

      "Reisesicherheit",

      "Reisestile",

      "Langzeitreisen & Auswandern",

      "Erfahrungen & Fragen",
    ];

    final Map<String, List<String>> countriesByRegion = {
      "Europa": [
        "Deutschland",
        "Spanien",
        "Italien",
        "Frankreich",
        "Portugal",
        "Griechenland",
        "Österreich",
        "Schweiz",
        "Niederlande",
        "Belgien",
        "Luxemburg",
        "Dänemark",
        "Schweden",
        "Norwegen",
        "Finnland",
        "Island",
        "Irland",
        "Großbritannien",
        "Polen",
        "Tschechien",
        "Slowakei",
        "Ungarn",
        "Slowenien",
        "Kroatien",
        "Montenegro",
        "Albanien",
        "Bosnien und Herzegowina",
        "Serbien",
        "Bulgarien",
        "Rumänien",
        "Estland",
        "Lettland",
        "Litauen",
        "Malta",
        "Zypern",
        "Türkei",
      ],

      "Asien": [
        "Japan",
        "China",
        "Südkorea",
        "Taiwan",
        "Thailand",
        "Vietnam",
        "Kambodscha",
        "Laos",
        "Myanmar",
        "Indonesien",
        "Malaysia",
        "Singapur",
        "Philippinen",
        "Brunei",
        "Indien",
        "Sri Lanka",
        "Nepal",
        "Bhutan",
        "Bangladesch",
        "Malediven",
        "Mongolei",
        "Kasachstan",
        "Usbekistan",
        "Kirgisistan",
        "Georgien",
        "Armenien",
        "Aserbaidschan",
      ],

      "Afrika": [
        "Südafrika",
        "Namibia",
        "Botswana",
        "Simbabwe",
        "Sambia",
        "Mosambik",
        "Tansania",
        "Kenia",
        "Uganda",
        "Ruanda",
        "Äthiopien",
        "Ghana",
        "Senegal",
        "Marokko",
        "Tunesien",
        "Ägypten",
        "Madagaskar",
        "Mauritius",
        "Seychellen",
        "Kap Verde",
      ],

      "Nordamerika": ["USA", "Kanada", "Mexiko"],

      "Zentralamerika": [
        "Costa Rica",
        "Panama",
        "Guatemala",
        "Belize",
        "Honduras",
        "Nicaragua",
        "El Salvador",
      ],

      "Karibik": [
        "Dominikanische Republik",
        "Kuba",
        "Jamaika",
        "Bahamas",
        "Barbados",
        "Aruba",
        "Curaçao",
        "Puerto Rico",
        "Trinidad und Tobago",
        "St. Lucia",
        "Grenada",
        "Antigua und Barbuda",
        "Dominica",
      ],

      "Südamerika": [
        "Brasilien",
        "Argentinien",
        "Chile",
        "Peru",
        "Kolumbien",
        "Bolivien",
        "Ecuador",
        "Uruguay",
        "Paraguay",
        "Venezuela",
        "Guyana",
        "Suriname",
      ],

      "Australien & Pazifik": [
        "Australien",
        "Neuseeland",
        "Fidschi",
        "Samoa",
        "Tonga",
        "Vanuatu",
        "Französisch-Polynesien",
        "Cookinseln",
        "Palau",
        "Neukaledonien",
        "Papua-Neuguinea",
        "Salomonen",
      ],

      "Naher Osten": [
        "Vereinigte Arabische Emirate",
        "Saudi-Arabien",
        "Oman",
        "Katar",
        "Jordanien",
        "Israel",
        "Bahrain",
        "Kuwait",
        "Libanon",
      ],

      "Polarregionen": ["Antarktis", "Grönland", "Spitzbergen"],
    };

    final countryTopics = [
      "Sehenswürdigkeiten\n& Natur",

      "Erlebnisse &\nAktivitäten",

      "Essen & Trinken",

      "Unterkünfte",

      "Transport & Apps",

      "Einreise & Visa",

      "Kosten & Preise",

      "Beste Reisezeit & Wetter",

      "Sicherheit",

      "Kultur & Verhalten",

      "Geheimtipps & Orte",

      "Reisestile",

      "Erfahrungen & Reiseberichte",

      "Fragen & Hilfe",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            Future<void> pickDateRange() async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );

              if (picked != null) {
                sheetSetState(() {
                  travelRange = picked;
                });
              }
            }

            Future<void> saveForumPost() async {
              if (!isGeneral &&
                  (selectedRegion == null ||
                      selectedCountry == null ||
                      selectedTopic == null)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bitte Region, Land und Thema auswählen 🌍"),
                  ),
                );

                return;
              }

              if (isGeneral && selectedTopic == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Bitte ein allgemeines Reisethema auswählen ✈️",
                    ),
                  ),
                );

                return;
              }

              if (postController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bitte schreibe zuerst deinen Beitrag ✍️"),
                  ),
                );

                return;
              }

              final user = FirebaseAuth.instance.currentUser;

              if (user == null) return;

              final userDoc = await FirebaseFirestore.instance
                  .collection("Users")
                  .doc(user.uid)
                  .get();

              final userData = userDoc.data();

              final doc = FirebaseFirestore.instance
                  .collection("forumPosts")
                  .doc();

              await doc.set({
                "postId": doc.id,

                "userId": user.uid,

                "username": userData?["username"] ?? "User",

                "profilePicture": userData?["profilePicture"] ?? "",

                "general": isGeneral,

                "region": isGeneral ? null : selectedRegion,

                "country": isGeneral ? null : selectedCountry,

                "topic": selectedTopic,

                "text": postController.text.trim(),

                "createdAt": Timestamp.now(),

                "travelDate":
                    travelRange != null &&
                        travelRange!.start == travelRange!.end
                    ? Timestamp.fromDate(travelRange!.start)
                    : null,

                "travelStart":
                    travelRange != null &&
                        travelRange!.start != travelRange!.end
                    ? Timestamp.fromDate(travelRange!.start)
                    : null,

                "travelEnd":
                    travelRange != null &&
                        travelRange!.start != travelRange!.end
                    ? Timestamp.fromDate(travelRange!.end)
                    : null,

                "likes": 0,

                "comments": [],

                "savedBy": [],

                "helpful": 0,
              });

              if (!context.mounted) return;

              Navigator.pop(context);
            }

            List<String> availableTopics = isGeneral
                ? generalTopics
                : countryTopics;

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,

                left: 16,

                right: 16,

                top: 20,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Text(
                      "Beitrag im Reiseforum posten",

                      style: TextStyle(
                        fontSize: 21,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Du möchtest Erfahrungen aus vergangenen Reisen teilen oder brauchst Tipps für deine nächste Reise? 🌍\n\n"
                      "Teile deine Erfahrungen, Fragen und Empfehlungen mit anderen Reisenden.",

                      textAlign: TextAlign.center,

                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Region oder allgemeines Reisethema",

                        border: OutlineInputBorder(),
                      ),

                      initialValue: isGeneral
                          ? "Allgemeine Reisethemen"
                          : selectedRegion,

                      items: [
                        const DropdownMenuItem(
                          value: "Allgemeine Reisethemen",

                          child: Text("Allgemeine Reisethemen"),
                        ),

                        ...regions.map(
                          (r) => DropdownMenuItem(value: r, child: Text(r)),
                        ),
                      ],

                      onChanged: (value) {
                        sheetSetState(() {
                          if (value == "Allgemeine Reisethemen") {
                            isGeneral = true;

                            selectedRegion = null;

                            selectedCountry = null;
                          } else {
                            isGeneral = false;

                            selectedRegion = value;

                            selectedCountry = null;
                          }

                          selectedTopic = null;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    if (!isGeneral && selectedRegion != null)
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Land",

                          border: OutlineInputBorder(),
                        ),

                        initialValue: selectedCountry,

                        items: countriesByRegion[selectedRegion]!
                            .map(
                              (country) => DropdownMenuItem(
                                value: country,

                                child: Text(country),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {
                          sheetSetState(() {
                            selectedCountry = value;

                            selectedTopic = null;
                          });
                        },
                      ),

                    const SizedBox(height: 12),

                    if ((isGeneral || selectedCountry != null))
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Thema",

                          border: OutlineInputBorder(),
                        ),

                        initialValue: selectedTopic,

                        items: availableTopics
                            .map(
                              (topic) => DropdownMenuItem(
                                value: topic,

                                child: Text(topic),
                              ),
                            )
                            .toList(),

                        onChanged: (value) {
                          sheetSetState(() {
                            selectedTopic = value;
                          });
                        },
                      ),

                    const SizedBox(height: 12),

                    InkWell(
                      onTap: pickDateRange,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: Text(
                          travelRange == null
                              ? "Wann warst du dort? (optional)"
                              : travelRange!.start == travelRange!.end
                              ? "${travelRange!.start.day}.${travelRange!.start.month}.${travelRange!.start.year}"
                              : "${travelRange!.start.day}.${travelRange!.start.month}.${travelRange!.start.year} - "
                                    "${travelRange!.end.day}.${travelRange!.end.month}.${travelRange!.end.year}",
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: postController,

                      maxLines: 6,

                      decoration: const InputDecoration(
                        hintText:
                            "Schreibe deinen Beitrag, deine Erfahrung oder deine Frage...",

                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      height: 50,

                      child: ElevatedButton(
                        onPressed: saveForumPost,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C77FF),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          "Beitrag absenden",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoments(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: _momentsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return matchesSearch(data);
        }).toList();

        if (filteredDocs.isEmpty) {
          return searchQuery.isNotEmpty
              ? _searchEmptyState()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_camera_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Noch keine Momente vorhanden",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Teile dein erstes Reisefoto",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UploadPostPage(),
                            ),
                          );
                        },
                        child: const Text("Moment teilen"),
                      ),
                    ],
                  ),
                );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(10),

          itemCount: filteredDocs.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 1,
          ),

          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;

            final List mediaUrls = data["mediaUrls"] ?? [];
            final List mediaTypes = data["mediaTypes"] ?? [];
            final List thumbnailUrls = data["thumbnailUrls"] ?? [];

            final String? legacyImage = data["image"];
            final String? legacyVideo = data["videoUrl"];

            // Neues Format
            if (mediaUrls.isNotEmpty) {
              final String coverType = mediaTypes.isNotEmpty
                  ? mediaTypes.first
                  : "image";

              final String coverUrl =
                  coverType == "video" &&
                      thumbnailUrls.isNotEmpty &&
                      thumbnailUrls.first.isNotEmpty
                  ? thumbnailUrls.first
                  : mediaUrls.first;

              final bool isMulti = mediaUrls.length > 1;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(
                        postId: filteredDocs[index].id,
                        isDarkMode: isDark,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),

                      if (coverType == "video")
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),

                      if (isMulti)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.collections,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            // Altes Bildformat
            if (legacyImage != null && legacyImage.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(
                        postId: filteredDocs[index].id,
                        isDarkMode: isDark,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(legacyImage, fit: BoxFit.cover),
                ),
              );
            }

            // Altes Videoformat
            if (legacyVideo != null && legacyVideo.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(
                        postId: filteredDocs[index].id,
                        isDarkMode: isDark,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill, size: 50),
                  ),
                ),
              );
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        );
      },
    );
  }

  Widget _emptyState({
    required String title,
    required String subtitle,
    required String button,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(Icons.travel_explore, size: 60, color: Colors.grey),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(subtitle, textAlign: TextAlign.center),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              _showForumPostSheet();
            },

            child: Text(button),
          ),
        ],
      ),
    );
  }

  Widget _buildStories(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: _storiesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return matchesSearch(data);
        }).toList();

        if (filteredDocs.isEmpty) {
          if (searchQuery.isNotEmpty) {
            return _searchEmptyState();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 60,
                  color: Colors.grey,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Noch keine Stories vorhanden",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Erstelle dein erstes Reisetagebuch",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewTravelDiaryPage(),
                      ),
                    );
                  },
                  child: const Text("Story erstellen"),
                ),
              ],
            ),
          );
        }

        final textColor = isDark ? Colors.white : Colors.black;

        final secondary = isDark ? Colors.white60 : Colors.black54;

        final cardColor = isDark
            ? const Color(0xff241E3A)
            : const Color(0xffF3F0FF);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;

            final text = data["beschreibung"] ?? "";

            final preview = text.length > 80
                ? "${text.substring(0, 80)}..."
                : text;

            final userId = data["uid"];

            return FutureBuilder<Map<String, dynamic>>(
              future: _getUserData(userId),
              builder: (context, userSnapshot) {
                final userData = userSnapshot.data ?? {};

                final username = userData["username"] ?? "User";

                final profilePicture = userData["profilePicture"] ?? "";

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OtherUserProfilePage(userId: userId),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: profilePicture.isNotEmpty
                                  ? NetworkImage(profilePicture)
                                  : null,
                              child: profilePicture.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                          ),

                          const SizedBox(width: 12),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OtherUserProfilePage(userId: userId),
                                ),
                              );
                            },
                            child: Text(
                              username,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data["titel"] ?? "Reisetagebuch",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Text(
                        preview,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TravelDiaryDetailPage(
                                  diaryId: filteredDocs[index].id,
                                  isDarkMode: isDark,
                                ),
                              ),
                            );
                          },

                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Weiterlesen",
                                style: TextStyle(
                                  color: Color(0xff8C77FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              SizedBox(width: 6),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Color(0xff8C77FF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider).value ?? false;

    final background = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: background,

      body: Column(
        children: [
          TabBar(
            controller: _tabController,

            labelColor: const Color(0xff8C77FF),

            unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,

            indicatorColor: const Color(0xff8C77FF),

            tabs: const [
              Tab(text: "Erfahrungen"),

              Tab(text: "Stories"),

              Tab(text: "Momente"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,

              children: [
                _buildExperiences(isDark),

                _buildStories(isDark),

                _buildMoments(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey),

          SizedBox(height: 20),

          Text(
            "Keine Suche gefunden",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8),

          Text(
            "Es wurden keine passenden Beiträge gefunden.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExperiences(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: _experienceStream(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        final filteredDocs = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return matchesSearch(data);
        }).toList();

        if (filteredDocs.isEmpty) {
          return searchQuery.isNotEmpty
              ? _searchEmptyState()
              : _emptyState(
                  title: "Noch keine Erfahrungen vorhanden",
                  subtitle: "Teile deine erste Reiseerfahrung mit anderen",
                  button: "Erfahrung teilen",
                );
        }

        final textColor = isDark ? Colors.white : Colors.black;

        final secondary = isDark ? Colors.white60 : Colors.black54;

        final cardColor = isDark
            ? const Color(0xff241E3A)
            : const Color(0xffF3F0FF);

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: filteredDocs.length,

          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: cardColor,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // USER HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,

                        backgroundImage:
                            data["profilePicture"] != null &&
                                data["profilePicture"] != ""
                            ? NetworkImage(data["profilePicture"])
                            : null,

                        child:
                            data["profilePicture"] == null ||
                                data["profilePicture"] == ""
                            ? const Icon(Icons.person)
                            : null,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              data["username"] ?? "User",

                              style: TextStyle(
                                color: textColor,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (data["travelDate"] != null)
                              Text(
                                formatDate(data["travelDate"]),

                                style: TextStyle(
                                  color: secondary,

                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // TEXT
                  Text(
                    data["text"] ?? "",

                    style: TextStyle(
                      color: textColor,

                      fontSize: 15,

                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // BUTTON ROW
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("forumPosts")
                        .doc(filteredDocs[index].id)
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      final post =
                          snapshot.data!.data() as Map<String, dynamic>;

                      final user = FirebaseAuth.instance.currentUser;

                      final likes = post["likes"] ?? [];

                      final liked = user != null && likes.contains(user.uid);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _actionItem(
                            icon: liked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: liked ? Colors.red : secondary,
                            count: likes.length,
                            onTap: () {
                              toggleLike(filteredDocs[index].id, likes);
                            },
                          ),

                          const SizedBox(width: 24),

                          FutureBuilder<int>(
                            future: getCommentCount(filteredDocs[index].id),
                            builder: (context, snapshot) {
                              final commentCount = snapshot.data ?? 0;

                              return _actionItem(
                                icon: Icons.mode_comment_outlined,
                                color: secondary,
                                count: commentCount,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) {
                                      return _CommentSheet(
                                        questionId: filteredDocs[index].id,
                                        questionData: post,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _actionItem({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Icon(icon, size: 21, color: color),

          const SizedBox(width: 6),

          Text(
            "$count",
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> markHelpful(String postId, List helpfulBy) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection("forumPosts").doc(postId);

    if (helpfulBy.contains(user.uid)) {
      await ref.update({
        "helpfulBy": FieldValue.arrayRemove([user.uid]),
      });
    } else {
      await ref.update({
        "helpfulBy": FieldValue.arrayUnion([user.uid]),
      });
    }
  }

  Future<int> getCommentCount(String postId) async {
    int count = 0;

    final answersSnapshot = await FirebaseFirestore.instance
        .collection("forumPosts")
        .doc(postId)
        .collection("Answers")
        .get();

    count += answersSnapshot.docs.length;

    for (final answer in answersSnapshot.docs) {
      final repliesSnapshot = await FirebaseFirestore.instance
          .collection("forumPosts")
          .doc(postId)
          .collection("Answers")
          .doc(answer.id)
          .collection("Replies")
          .get();

      count += repliesSnapshot.docs.length;
    }

    return count;
  }

  Future<void> toggleLike(String postId, List likes) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection("forumPosts").doc(postId);

    if (likes.contains(user.uid)) {
      await ref.update({
        "likes": FieldValue.arrayRemove([user.uid]),
      });
    } else {
      await ref.update({
        "likes": FieldValue.arrayUnion([user.uid]),
      });
    }
  }

  Future<void> toggleSave(String postId, List savedBy) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final ref = FirebaseFirestore.instance.collection("forumPosts").doc(postId);

    if (savedBy.contains(user.uid)) {
      await ref.update({
        "savedBy": FieldValue.arrayRemove([user.uid]),
      });
    } else {
      await ref.update({
        "savedBy": FieldValue.arrayUnion([user.uid]),
      });
    }
  }

  Future<Map<String, dynamic>> _getUserData(String? userId) async {
    if (userId == null || userId.isEmpty) {
      return {};
    }

    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .get();

    return doc.data() ?? {};
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
        .collection('forumPosts')
        .doc(widget.questionId)
        .collection('Answers')
        .doc(answerId)
        .collection('Replies');

    final replies = await repliesRef.get();

    for (var r in replies.docs) {
      await r.reference.delete();
    }

    await FirebaseFirestore.instance
        .collection('forumPosts')
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
                                .collection('forumPosts')
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
            .collection('forumPosts')
            .doc(widget.questionId)
            .collection('Answers')
            .doc(editingAnswerId)
            .update({'answer': text});
      }

      if (editingReplyId != null) {
        await FirebaseFirestore.instance
            .collection('forumPosts')
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
          .collection('forumPosts')
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
        .collection('forumPosts')
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
          // 🔥 LISTE
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('forumPosts')
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

                    return Column(
                      children: [
                        Padding(
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
                                      radius: 18,
                                      backgroundImage:
                                          user?['profilePicture'] != null
                                          ? NetworkImage(
                                              user!['profilePicture'],
                                            )
                                          : null,
                                      child: user?['profilePicture'] == null
                                          ? const Icon(Icons.person)
                                          : null,
                                    );
                                  },
                                ),

                                const SizedBox(width: 10),

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
                                                    userId: a['userId'],
                                                  ),
                                            ),
                                          );
                                        },
                                        child: FutureBuilder<DocumentSnapshot>(
                                          future: firestore
                                              .collection('Users')
                                              .doc(a['userId'])
                                              .get(),
                                          builder: (context, snap) {
                                            final user =
                                                snap.data?.data()
                                                    as Map<String, dynamic>?;

                                            return Text(
                                              user?['username'] ?? 'User',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 2,
                                                    ),
                                                child: Text(
                                                  replyingToAnswerId == answerId
                                                      ? "Antwort aktiv"
                                                      : "Antworten",
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color:
                                                        Colors.deepPurpleAccent,
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

                                              final ref = FirebaseFirestore
                                                  .instance
                                                  .collection('forumPosts')
                                                  .doc(widget.questionId)
                                                  .collection('Answers')
                                                  .doc(answerId);

                                              if (isLiked) {
                                                await ref.update({
                                                  'likes':
                                                      FieldValue.arrayRemove([
                                                        uid,
                                                      ]),
                                                });
                                              } else {
                                                await ref.update({
                                                  'likes':
                                                      FieldValue.arrayUnion([
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
                                                      : Icons
                                                            .thumb_up_alt_outlined,
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
                                            .collection('forumPosts')
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

                                          if (count == 0) {
                                            return const SizedBox();
                                          }

                                          final isOpen = expandedReplies
                                              .contains(answerId);

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
                                                      expandedReplies.add(
                                                        answerId,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 6,
                                                      ),
                                                  child: Text(
                                                    isOpen
                                                        ? "Antworten ausblenden"
                                                        : "Antworten anzeigen ($count)",
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // 👉 REPLIES LIST (nur wenn geöffnet)
                                              if (isOpen)
                                                Column(
                                                  children: replies.map((r) {
                                                    final currentUid =
                                                        FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid;

                                                    final reply =
                                                        r.data()
                                                            as Map<
                                                              String,
                                                              dynamic
                                                            >;

                                                    final replyLikes =
                                                        List<String>.from(
                                                          reply['likes'] ?? [],
                                                        );
                                                    final isReplyLiked =
                                                        replyLikes.contains(
                                                          currentUid,
                                                        );

                                                    final replyRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                              'forumPosts',
                                                            )
                                                            .doc(
                                                              widget.questionId,
                                                            )
                                                            .collection(
                                                              'Answers',
                                                            )
                                                            .doc(answerId)
                                                            .collection(
                                                              'Replies',
                                                            )
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
                                                            text:
                                                                reply['reply'],
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
                                                            FutureBuilder<
                                                              DocumentSnapshot
                                                            >(
                                                              future: firestore
                                                                  .collection(
                                                                    'Users',
                                                                  )
                                                                  .doc(
                                                                    reply['userId'],
                                                                  )
                                                                  .get(),
                                                              builder: (context, snap) {
                                                                final user =
                                                                    snap.data
                                                                            ?.data()
                                                                        as Map<
                                                                          String,
                                                                          dynamic
                                                                        >?;

                                                                return CircleAvatar(
                                                                  radius: 16,
                                                                  backgroundImage:
                                                                      user?['profilePicture'] !=
                                                                          null
                                                                      ? NetworkImage(
                                                                          user!['profilePicture'],
                                                                        )
                                                                      : null,
                                                                  child:
                                                                      user?['profilePicture'] ==
                                                                          null
                                                                      ? const Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              16,
                                                                        )
                                                                      : null,
                                                                );
                                                              },
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
                                                                    child:
                                                                        FutureBuilder<
                                                                          DocumentSnapshot
                                                                        >(
                                                                          future: firestore
                                                                              .collection(
                                                                                'Users',
                                                                              )
                                                                              .doc(
                                                                                reply['userId'],
                                                                              )
                                                                              .get(),
                                                                          builder:
                                                                              (
                                                                                context,
                                                                                snap,
                                                                              ) {
                                                                                final user =
                                                                                    snap.data?.data()
                                                                                        as Map<
                                                                                          String,
                                                                                          dynamic
                                                                                        >?;

                                                                                return Text(
                                                                                  user?['username'] ??
                                                                                      'User',
                                                                                  style: const TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                );
                                                                              },
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
                                                                if (uid ==
                                                                    null) {
                                                                  return;
                                                                }

                                                                if (isReplyLiked) {
                                                                  await replyRef
                                                                      .update({
                                                                        'likes':
                                                                            FieldValue.arrayRemove([
                                                                              uid,
                                                                            ]),
                                                                      });
                                                                } else {
                                                                  await replyRef
                                                                      .update({
                                                                        'likes':
                                                                            FieldValue.arrayUnion([
                                                                              uid,
                                                                            ]),
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
                                                                      fontSize:
                                                                          13,
                                                                      color:
                                                                          isReplyLiked
                                                                          ? Colors.blue
                                                                          : Colors.grey,
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
                        ),
                        if (index != docs.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              height: 1,
                              thickness: 0.8,
                              color: isDarkMode
                                  ? Colors.white24
                                  : Colors.grey.shade300,
                            ),
                          ),
                      ],
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
        .collection('forumPosts')
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
