import 'package:flutter/material.dart';
import '../travel_diary_page.dart';
import '../../erstellen_tab/new_travel_diary_page.dart';

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 70, color: purple),

            const SizedBox(height: 18),

            Text(
              "Deine Reisegeschichten warten",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Halte deine schönsten Reisemomente fest und erschaffe dein persönliches Reisetagebuch 🌍\n\n"
              "Egal ob vergangene Abenteuer oder deine aktuelle Reise – teile deine Erlebnisse mit wunderschönen Texten, Bildern und Videos und bewahre deine Erinnerungen für immer auf.",
              textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewTravelDiaryPage(),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  "Erstes Reisetagebuch erstellen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
