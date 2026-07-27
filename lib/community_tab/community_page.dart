import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/dark_mode_provider.dart';

import 'qanda/qa_tab.dart';
import 'gruppen/groups_tab.dart';
import 'follow_suggestions_page.dart';
import 'forum/forum_page.dart';

class CommunityPage extends ConsumerStatefulWidget {
  final int initialTab;

  const CommunityPage({super.key, this.initialTab = 0});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void didUpdateWidget(covariant CommunityPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider).value ?? false;

    final bg = isDark ? Colors.black : Colors.white;

    final text = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,

        elevation: 0,

        centerTitle: true,

        foregroundColor: text,

        title: Text(
          "Community",
          style: GoogleFonts.pacifico(fontSize: 26, color: text),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FollowSuggestionsPage(),
                ),
              );
            },
          ),
        ],

        bottom: TabBar(
          controller: _tabController,

          indicatorColor: const Color(0xFF8C77FF),

          labelColor: const Color(0xFF8C77FF),

          unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,

          tabs: const [
            Tab(text: "Forum"),
            Tab(text: "Q&A"),
            Tab(text: "Gruppen"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,

        children: [
          // ==================
          // FORUM
          // ==================
          const ForumPage(),

          // ==================
          // Q&A
          // ==================
          const QATab(),

          // ==================
          // GRUPPEN
          // ==================
          const GroupsTab(),
        ],
      ),
    );
  }
}
