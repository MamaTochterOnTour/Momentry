import 'package:flutter/material.dart';
import '../guides/guides_mock_page.dart';
import 'feed_page.dart';
import 'upload_post_page.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'new_travel_diary_page.dart';
import 'profile_page.dart';
import '../reiseplanung/reiseplanung_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FeedPage(isDarkMode: false), // oder true / dynamic später

    GuidesMockPage(),

    const Center(child: Text('Erstellen')),
    TripsOverviewPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showCreateSheet();
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
                builder: (context, setState) {
                  bool isLoading = false;

                  Future<void> saveQuestion() async {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;

                    setState(() => isLoading = true);

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

                      if (!mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint("Q&A Error: $e");
                    } finally {
                      setState(() => isLoading = false);
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
                'title': title,
                'userId': user.uid,
                'startDate': selectedRange!.start,
                'endDate': selectedRange!.end,
                'createdAt': Timestamp.now(),
              });

              if (!context.mounted) return;
              Navigator.pop(context);
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
              ],
            ),
          ),
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

        return Scaffold(
          backgroundColor: bgColor,
          body: _pages[_selectedIndex],

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,

            backgroundColor: bgColor,

            selectedItemColor: const Color(0xFF8C77FF),
            unselectedItemColor: isDark ? Colors.white54 : Colors.black45,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Insider',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Erstellen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flight_takeoff),
                label: 'Trips',
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
