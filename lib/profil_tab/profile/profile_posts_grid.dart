import 'package:flutter/material.dart';
import '../../erstellen_tab/post_detail_page.dart';
import '../../erstellen_tab/upload_post_page.dart';

class ProfilePostsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final bool isDarkMode;
  final Color purple;

  const ProfilePostsGrid({
    super.key,
    required this.posts,
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
            Icon(Icons.photo_camera_outlined, size: 70, color: purple),

            const SizedBox(height: 18),

            Text(
              "Teile deine Reiseinspiration",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Erstelle deinen ersten Beitrag und nimm andere Reisende mit auf dein Abenteuer ✈️\n\n"
              "Teile besondere Momente deiner vergangenen oder aktuellen Reisen mit schönen Bildern, Videos und deiner persönlichen Geschichte.\n\n"
              "Gib Empfehlungen, inspiriere andere und zeige der Community deine schönsten Orte.",
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
                    MaterialPageRoute(builder: (_) => const UploadPostPage()),
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
                  "Ersten Beitrag erstellen",
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
    if (posts.isEmpty) {
      return _emptyState(context);
    }

    return GridView.builder(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 80,
      ),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) {
        final item = posts[index];

        final List mediaUrls = item['mediaUrls'] ?? [];
        final List mediaTypes = item['mediaTypes'] ?? [];

        final String? legacyImage = item['image'];
        final String? legacyVideo = item['videoUrl'];

        // =========================
        // 🔹 NEUES FORMAT
        // =========================
        if (mediaUrls.isNotEmpty) {
          final String coverType = mediaTypes.isNotEmpty
              ? mediaTypes.first
              : 'image';
          final List thumbnailUrls = item['thumbnailUrls'] ?? [];

          final String coverUrl =
              (coverType == 'video' &&
                  thumbnailUrls.isNotEmpty &&
                  thumbnailUrls.first.isNotEmpty)
              ? thumbnailUrls.first
              : mediaUrls.first;

          final bool isMulti = mediaUrls.length > 1;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(
                    postId: item['id'],
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: purple,
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
                  if (coverType == 'video')
                    const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  if (isMulti)
                    Positioned(
                      right: 8,
                      top: 8,
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

        // =========================
        // 🔹 ALTES FORMAT
        // =========================
        if (legacyImage != null && legacyImage.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(
                    postId: item['id'],
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: purple,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(legacyImage, fit: BoxFit.cover),
              ),
            ),
          );
        }

        if (legacyVideo != null && legacyVideo.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(
                    postId: item['id'],
                    isDarkMode: isDarkMode,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: purple,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          );
        }

        return Container(color: purple);
      },
    );
  }
}
