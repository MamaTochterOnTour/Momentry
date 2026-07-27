import 'package:flutter/material.dart';
import 'profile_journals_list.dart';
import 'profile_posts_grid.dart';
import '../../l10n/s.dart';

class ProfileTabs extends StatelessWidget {
  final List<Map<String, dynamic>> reisen;
  final List<Map<String, dynamic>> beitraege;
  final bool isDarkMode;
  final Color purple;
  final int initialTabIndex;

  const ProfileTabs({
    super.key,
    required this.reisen,
    required this.beitraege,
    required this.isDarkMode,
    required this.purple,
    required this.initialTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Column(
        children: [
          TabBar(
            labelColor: purple,
            unselectedLabelColor: textColor,
            indicatorColor: purple,
            tabs: [
              Tab(text: S.of(context)!.posts),
              Tab(text: S.of(context)!.journals),
            ],
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 500,
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfilePostsGrid(
                  posts: beitraege,
                  isDarkMode: isDarkMode,
                  purple: purple,
                ),
                ProfileJournalsList(
                  reisen: reisen,
                  isDarkMode: isDarkMode,
                  purple: purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
