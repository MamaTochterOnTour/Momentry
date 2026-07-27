import 'package:flutter/material.dart';
import 'upload_post_page.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_travel_diary_page.dart';
import '../profil_tab/profile_page.dart';
import '../reisen_tab/reiseplanung/reiseplanung_page.dart';
import '../home_tab/home_page.dart';
import '../community_tab/community_page.dart';
import 'package:flutter/services.dart';

class MainNavigationPage extends StatefulWidget {
  static void openCommunityQA(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainNavigationPageState>();

    state?._openCommunityQA();
  }

  static void openCommunityGroups(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainNavigationPageState>();

    state?._openCommunityGroups();
  }

  static void openCreateTrip(BuildContext context) {
    final navigator = Navigator.of(context);

    navigator.popUntil((route) => route.isFirst);

    final state = context.findAncestorStateOfType<_MainNavigationPageState>();

    if (state != null) {
      state._showTripSheet();
    }
  }

  static void openEditGroup(BuildContext context, String groupId) {
    final state = context.findAncestorStateOfType<_MainNavigationPageState>();

    state?._showGroupSheet(groupId: groupId);
  }

  static void openForumPost(BuildContext context) {
    final state = context.findAncestorStateOfType<_MainNavigationPageState>();

    state?._openForumPost();
  }

  final int initialIndex;
  final int profileInitialTab;
  final int communityInitialTab;

  const MainNavigationPage({
    super.key,
    this.initialIndex = 0,
    this.profileInitialTab = 0,
    this.communityInitialTab = 0,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  late int _selectedIndex;
  late int _profileInitialTab;
  int _exploreRefreshKey = 0;
  int _communityTab = 0;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
    _profileInitialTab = widget.profileInitialTab;
    _communityTab = widget.communityInitialTab;
  }

  void _openCommunityQA() {
    setState(() {
      _selectedIndex = 1;
      _communityTab = 1;
    });
  }

  void _openCommunityGroups() {
    setState(() {
      _selectedIndex = 1; // Community Bottom Tab
      _communityTab = 2; // Gruppen Tab
    });
  }

  void _openForumPost() {
    setState(() {
      _selectedIndex = 2;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _showForumPostSheet();
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _showCreateSheet();
      return;
    }

    // 🔄 WICHTIG: wenn Explore (Index 0) nochmal gedrückt wird → refresh
    if (index == 0 && _selectedIndex == 0) {
      setState(() {
        _exploreRefreshKey++;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _showQuestionSheet() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final isDark = ref.watch(darkModeProvider).value ?? false;

            final bg = isDark ? Colors.black : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black;
            final hintColor = isDark ? Colors.white54 : Colors.black45;

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: StatefulBuilder(
                builder: (context, sheetSetState) {
                  bool isLoading = false;

                  Future<void> saveQuestion() async {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;

                    sheetSetState(() => isLoading = true);

                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      final docRef = FirebaseFirestore.instance
                          .collection('Questions')
                          .doc();

                      final userDoc = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.uid)
                          .get();

                      final data = userDoc.data();

                      await docRef.set({
                        'questionId': docRef.id,
                        'question': text,
                        'userId': user.uid,
                        'username': data?['username'] ?? 'User',
                        'profilePicture': data?['profilePicture'] ?? '',
                        'createdTime': Timestamp.now(),
                      });

                      if (!context.mounted) return;

                      // BottomSheet schließen
                      Navigator.pop(context);

                      if (!mounted) return;

                      setState(() {
                        _exploreRefreshKey++; // 👈 DAS FEHLT
                        _selectedIndex = 1; // Community
                        _communityTab = 1; // Gruppen
                      });
                    } catch (e) {
                      debugPrint("Q&A Error: $e");
                    } finally {
                      sheetSetState(() => isLoading = false);
                    }
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Frage stellen",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "✈️ Du hast eine Frage zu deiner Reise?\n💬 Stell deine Frage gerne im Q&A-Board, damit andere Reisende dir helfen können.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: hintColor),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: controller,
                        maxLines: 4,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Deine Frage eingeben...",
                          hintStyle: TextStyle(color: hintColor),
                          filled: true,
                          fillColor: isDark
                              ? Colors.grey[900]
                              : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : saveQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFE9D5FF,
                            ), // helllila
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Frage speichern",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showGroupSheet({String? groupId}) async {
    final titleController = TextEditingController();
    DateTimeRange? selectedRange;

    if (groupId != null) {
      final groupDoc = await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupId)
          .get();

      if (!mounted) return;

      final data = groupDoc.data();

      if (data != null) {
        titleController.text = data["title"] ?? "";

        selectedRange = DateTimeRange(
          start: (data["startDate"] as Timestamp).toDate(),
          end: (data["endDate"] as Timestamp).toDate(),
        );
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            Future<void> pickDateRange() async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );

              if (!mounted) return;

              if (result != null) {
                sheetSetState(() {
                  selectedRange = result;
                });
              }
            }

            Future<void> saveGroup() async {
              final title = titleController.text.trim();

              if (title.isEmpty && selectedRange == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bitte Titel und Zeitraum ausfüllen ✈️"),
                  ),
                );
                return;
              }

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Bitte einen Titel für die Gruppe eingeben 🧭",
                    ),
                  ),
                );
                return;
              }

              if (selectedRange == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bitte einen Reisezeitraum auswählen 📅"),
                  ),
                );
                return;
              }

              final user = FirebaseAuth.instance.currentUser;

              if (user == null) return;

              final docRef = groupId == null
                  ? FirebaseFirestore.instance.collection("groups").doc()
                  : FirebaseFirestore.instance
                        .collection("groups")
                        .doc(groupId);

              if (groupId == null) {
                await docRef.set({
                  "groupId": docRef.id,
                  "title": title,
                  "creatorId": user.uid,
                  "startDate": selectedRange!.start,
                  "endDate": selectedRange!.end,
                  "members": [user.uid],
                  "createdAt": Timestamp.now(),
                });
              } else {
                await docRef.update({
                  "title": title,
                  "startDate": selectedRange!.start,
                  "endDate": selectedRange!.end,
                });
              }

              if (!context.mounted) return;

              Navigator.pop(context);

              if (!mounted) return;

              setState(() {
                _selectedIndex = 1;
                _communityTab = 2;
              });
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16,
                right: 16,
                top: 24,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          groupId == null
                              ? "Gruppe erstellen"
                              : "Gruppe bearbeiten",

                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        if (groupId == null) ...[
                          const SizedBox(height: 8),

                          const Text(
                            "Du gehst bald auf große Reise ✈️ und suchst nach echten Connections 🌍.\n\n"
                            "Erstelle eine Reisegruppe, um dich schon vor dem Start – und natürlich auch unterwegs – mit anderen Reisenden zu verbinden 🤝✨.",

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: titleController,

                    maxLength: 25,

                    inputFormatters: [LengthLimitingTextInputFormatter(25)],

                    decoration: InputDecoration(
                      labelText: "Titel der Reisegruppe",
                      hintText: "z.B. Mittelmeer Kreuzfahrt",

                      filled: true,

                      fillColor: Colors.grey[100],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  InkWell(
                    onTap: pickDateRange,

                    borderRadius: BorderRadius.circular(12),

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.grey[100],

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: Colors.grey.shade300),
                      ),

                      child: Text(
                        selectedRange == null
                            ? "Zeitraum wählen"
                            : "${selectedRange!.start.day}.${selectedRange!.start.month} - "
                                  "${selectedRange!.end.day}.${selectedRange!.end.month}",

                        style: TextStyle(
                          color: selectedRange == null
                              ? Colors.black45
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,

                    height: 52,

                    child: ElevatedButton(
                      onPressed: saveGroup,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C77FF),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),

                        elevation: 0,
                      ),

                      child: Text(
                        groupId == null
                            ? "Gruppe erstellen"
                            : "Änderungen speichern",

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTripSheet() {
    final titleController = TextEditingController();
    DateTimeRange? selectedRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final isDark = ref.watch(darkModeProvider).value ?? false;

            final bg = isDark ? Colors.black : Colors.white;
            final textColor = isDark ? Colors.white : Colors.black;
            final hintColor = isDark ? Colors.white54 : Colors.black45;

            Future<void> pickDateRange() async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: Colors.deepPurple,
                        surface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (result != null) {
                selectedRange = result;
              }
            }

            Future<void> createTrip() async {
              final title = titleController.text.trim();
              if (title.isEmpty || selectedRange == null) return;

              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final docRef = FirebaseFirestore.instance
                  .collection('trips')
                  .doc();

              await docRef.set({
                'tripId': docRef.id,

                // Basisdaten
                'title': title,
                'userId': user.uid,

                // Zeitraum
                'startDate': Timestamp.fromDate(selectedRange!.start),
                'endDate': Timestamp.fromDate(selectedRange!.end),

                // Status
                'status': 'upcoming',

                // Verwaltung
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),

                // Vorbereitung für spätere Features
                'savedPosts': [],
                'savedPlaces': [],
                'travelers': [],
                'titleImage': null,
                'inspirations': [],
                'diaryEntries': [],
                'statistics': {},
              });

              if (!context.mounted) return;

              // BottomSheet schließen
              Navigator.pop(context);

              // Nach dem Schließen zum Trips-Tab wechseln
              if (!mounted) return;
              setState(() {
                _selectedIndex = 3;
              });
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Reise hinzufügen",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Plane deine Reise und teile sie mit anderen",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: hintColor),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: titleController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Reiseziel (z.B. Bali)",
                      hintStyle: TextStyle(color: hintColor),
                      filled: true,
                      fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: pickDateRange,
                      child: Text(
                        selectedRange == null
                            ? "Start- & Enddatum wählen"
                            : "${selectedRange!.start.day}.${selectedRange!.start.month} - ${selectedRange!.end.day}.${selectedRange!.end.month}",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: createTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9D5FF), // helllila
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Reise erstellen",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createTile(
                  icon: Icons.edit,
                  title: 'Post erstellen',
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      this.context,
                      MaterialPageRoute(builder: (_) => const UploadPostPage()),
                    );
                  },
                ),

                _createTile(
                  icon: Icons.help_outline,
                  title: 'Frage stellen',
                  onTap: () {
                    Navigator.pop(context);
                    _showQuestionSheet();
                  },
                ),

                _createTile(
                  icon: Icons.forum_outlined,
                  title: 'Beitrag im Reiseforum posten',
                  onTap: () {
                    Navigator.pop(context);
                    _showForumPostSheet();
                  },
                ),

                _createTile(
                  icon: Icons.menu_book_outlined,
                  title: 'Tagebuch schreiben',
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewTravelDiaryPage(),
                      ),
                    );
                  },
                ),

                _createTile(
                  icon: Icons.flight_takeoff,
                  title: 'Reise hinzufügen',
                  onTap: () {
                    Navigator.pop(context);
                    _showTripSheet();
                  },
                ),

                _createTile(
                  icon: Icons.group,
                  title: 'Reisegruppe erstellen',
                  onTap: () {
                    Navigator.pop(context);
                    _showGroupSheet();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

                "region": isGeneral ? "Allgemeine Reisethemen" : selectedRegion,

                "country": isGeneral ? "Allgemein" : selectedCountry,

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

                "likes": [],

                "comments": [],

                "savedBy": [],

                "helpful": [],
              });

              if (!context.mounted) return;

              Navigator.pop(context);

              setState(() {
                _selectedIndex = 1;

                // falls dein Forum ein eigener Community Tab wird
                _communityTab = 0;
              });
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

  Widget _createTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8C77FF)),
      title: Text(title),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDark = ref.watch(darkModeProvider).value ?? false;

        final bgColor = isDark ? Colors.black : Colors.white;

        final pages = [
          HomePage(
            key: ValueKey(_exploreRefreshKey),
            isDarkMode: isDark,
            onAddTrip: _showTripSheet,
          ),

          CommunityPage(initialTab: _communityTab),

          const SizedBox(), // Platzhalter für Erstellen

          TripsOverviewPage(onAddTrip: _showTripSheet),

          ProfilePage(initialTabIndex: _profileInitialTab),
        ];

        return Scaffold(
          backgroundColor: bgColor,
          body: pages[_selectedIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,

            backgroundColor: bgColor,

            selectedItemColor: const Color(0xFF8C77FF),
            unselectedItemColor: isDark ? Colors.white54 : Colors.black45,

            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Erstellen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flight_takeoff),
                label: 'Reisen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
