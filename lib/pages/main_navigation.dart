import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../providers/dark_mode_provider.dart';
import '../l10n/s.dart';

// Seiten-Imports
import 'feed_page.dart';
import 'mama_tochter_tagebuch_page.dart';
import 'travel_guide_page.dart';
import 'profile_page.dart';
import 'new_travel_diary_page.dart';
import 'story_create_page.dart';
import 'upload_post_page.dart';
import 'premium_verwalten_page.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  final int? initialProfileTab;

  const MainNavigationPage({super.key, this.initialProfileTab});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _bottomNavIndex = 0;
  int _pageIndex = 0;
  int _profileTabIndex = 0;

  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _identifyRevenueCat();
    _loadUserSettings();

    if (widget.initialProfileTab != null) {
      _profileTabIndex = widget.initialProfileTab!;
      _bottomNavIndex = 4;
      _pageIndex = 3;
    }
  }

  Future<void> _identifyRevenueCat() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await Purchases.logIn(user.uid);
    } catch (e) {
      debugPrint("RevenueCat logIn failed: $e");
    }
  }

  Future<void> _loadUserSettings() async {
    if (_user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.uid)
        .get();
    if (doc.exists) {
      setState(() {
        _isDarkMode = doc.data()?['isDarkMode'] ?? false;
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _openCreateSheet();
      return;
    }
    setState(() {
      _bottomNavIndex = index;
      _pageIndex = index > 2 ? index - 1 : index;
    });
  }

  void _openCreateSheet() {
    final strings = S.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.post_add,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              strings.createPost,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadPostPage(isDarkMode: _isDarkMode),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu_book,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              strings.writeDiary,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NewTravelDiaryPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              strings.createStory,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoryCreatePage(isDarkMode: _isDarkMode),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.flight_takeoff,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              strings.addTrip,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _openAddTripSheet();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            title: Text(
              strings.askQuestion,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _openQuestionSheet();
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _openAddTripSheet() {
    final strings = S.of(context)!;
    final TextEditingController destinationController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: destinationController,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: strings.tripDestination,
                    labelStyle: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) => Theme(
                        data: _isDarkMode
                            ? ThemeData.dark()
                            : ThemeData.light(),
                        child: child!,
                      ),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                  child: Text(
                    startDate != null
                        ? "${strings.startDate}: ${startDate!.toLocal().toString().split(' ')[0]}"
                        : strings.selectStartDate,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? (startDate ?? DateTime.now()),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) => Theme(
                        data: _isDarkMode
                            ? ThemeData.dark()
                            : ThemeData.light(),
                        child: child!,
                      ),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                  child: Text(
                    endDate != null
                        ? "${strings.endDate}: ${endDate!.toLocal().toString().split(' ')[0]}"
                        : strings.selectEndDate,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final destination = destinationController.text.trim();
                    if (destination.isEmpty ||
                        startDate == null ||
                        endDate == null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(strings.fillAllFields)),
                      );
                      return;
                    }

                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;

                    final userDoc = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .get();
                    if (!context.mounted) return;

                    final userData = userDoc.data() ?? {};
                    final bool isPremium = userData['isPremium'] ?? false;
                    final int totalTripsCreated =
                        userData['totalTripsCreated'] ?? 0;

                    if (!isPremium && totalTripsCreated >= 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PremiumPage(uid: user.uid),
                                ),
                              );
                            },
                            child: Text(strings.tripLimitReached),
                          ),
                          backgroundColor: const Color(0xFF7B4DE8),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                      return;
                    }

                    final tripRef = FirebaseFirestore.instance
                        .collection('trips')
                        .doc();
                    await tripRef.set({
                      'title': destination,
                      'startDate': Timestamp.fromDate(startDate!),
                      'endDate': Timestamp.fromDate(endDate!),
                      'userId': user.uid,
                      'createdAt': Timestamp.now(),
                    });

                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.uid)
                        .update({'totalTripsCreated': FieldValue.increment(1)});

                    if (!context.mounted) return;
                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainNavigationPage(initialProfileTab: 2),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(strings.createTrip),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openQuestionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => NewQuestionSheet(
        isDarkMode: _isDarkMode,
        userId: _user!.uid,
        onSave: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final pages = [
      FeedPage(
        key: const ValueKey('feed_page'),
        userId: _user?.uid ?? '',
        searchQuery: '',
        isDarkMode: isDarkMode,
      ),
      MamaTochterTagebuchPage(
        key: const ValueKey('tagebuch_page'),
        userId: _user?.uid ?? '',
        isDarkMode: isDarkMode,
      ),
      TravelGuidesPage(
        key: const ValueKey('travel_page'),
        isDarkMode: isDarkMode,
      ),
      ProfilePage(
        key: const ValueKey('profile_page'),
        initialTabIndex: _profileTabIndex,
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: pages[_pageIndex],
      ),
      bottomNavigationBar: Container(
        height: 100, // Höhe kleiner, passt besser
        color: isDarkMode ? Colors.black : Colors.white, // gerader Balken
        child: SafeArea(
          // SafeArea verhindert Overflow
          child: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Container liefert Farbe
            elevation: 0,
            selectedItemColor: const Color(0xFF8C77FF),
            unselectedItemColor: Colors.grey,
            onTap: _onTabTapped,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home, size: 24),
                label: S.of(context)!.feed,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.menu_book, size: 24),
                label: S.of(context)!.diary,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF8C77FF),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_bag, size: 24),
                label: S.of(context)!.guides,
              ),
              BottomNavigationBarItem(
                icon: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(_user!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    String? imageUrl;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      imageUrl = data?['profilePicture'];
                    }
                    return CircleAvatar(
                      radius: 12, // kleiner als vorher
                      backgroundColor: const Color(0xFF8C77FF),
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl == null || imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    );
                  },
                ),
                label: S.of(context)!.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewQuestionSheet extends StatefulWidget {
  final bool isDarkMode;
  final String userId;
  final VoidCallback onSave;

  const NewQuestionSheet({
    super.key,
    required this.isDarkMode,
    required this.userId,
    required this.onSave,
  });

  @override
  State<NewQuestionSheet> createState() => _NewQuestionSheetState();
}

class _NewQuestionSheetState extends State<NewQuestionSheet> {
  final TextEditingController _questionController = TextEditingController();
  bool isSaving = false;

  Future<void> _saveQuestion() async {
    final strings = S.of(context)!;
    final questionText = _questionController.text.trim();
    if (questionText.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.enterQuestion)));
      return;
    }

    setState(() => isSaving = true);

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();
      final userData = userDoc.data() ?? {};
      final username = userData['username'] ?? 'User';
      final profilePicture = userData['profilePicture'];

      await FirebaseFirestore.instance.collection('Questions').add({
        'question': questionText,
        'userId': widget.userId,
        'username': username,
        'profilePicture': profilePicture,
        'createdTime': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      widget.onSave();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${strings.saveError}: $e")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.grey[900] : Colors.white;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              strings.askQuestionTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.askQuestionSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _questionController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: strings.askQuestionHint,
                hintStyle: TextStyle(color: textColor.withValues(alpha: 0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : _saveQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C77FF),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                isSaving ? strings.saving : strings.saveQuestion,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
