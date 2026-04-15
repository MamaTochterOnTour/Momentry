import 'package:flutter/material.dart';
import '../pages/travel_diary_page.dart';
import '../l10n/s.dart';

class ProfileJournalsList extends StatelessWidget {
  final List<Map<String, dynamic>> reisen;
  final bool isDarkMode;
  final Color purple;

  const ProfileJournalsList({
    super.key,
    required this.reisen,
    required this.isDarkMode,
    required this.purple,
  });

  Widget _emptyState(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 60, color: textColor),
            const SizedBox(height: 12),
            Text(
              S.of(context)!.noJournal,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.noJournalMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (reisen.isEmpty) {
      return _emptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: reisen.length,
      itemBuilder: (_, index) {
        final item = reisen[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TravelDiaryDetailPage(
                  diaryId: item['id'],
                  isDarkMode: isDarkMode,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: purple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['image'] != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      item['image'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    item['titel'] ?? 'Titel',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
