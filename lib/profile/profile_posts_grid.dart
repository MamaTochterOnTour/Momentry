import 'package:flutter/material.dart';
import '../pages/post_detail_page.dart';
import '../l10n/s.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 60, color: textColor),
            const SizedBox(height: 12),
            Text(
              S.of(context)!.noPost,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.noPostMessage,
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
