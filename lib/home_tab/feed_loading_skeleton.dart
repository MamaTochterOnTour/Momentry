import 'package:flutter/material.dart';

class FeedLoadingSkeleton extends StatelessWidget {
  final bool isDarkMode;

  const FeedLoadingSkeleton({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _SkeletonPost(isDarkMode: isDarkMode),
        childCount: 3,
      ),
    );
  }
}

class _SkeletonPost extends StatelessWidget {
  final bool isDarkMode;

  const _SkeletonPost({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode
        ? const Color(0xFF191522)
        : const Color(0xFFF8F5FF);

    final skeletonColor = isDarkMode ? Colors.white10 : Colors.grey.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profil
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundColor: skeletonColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bar(110, 14, skeletonColor),
                        const SizedBox(height: 6),
                        _bar(70, 10, skeletonColor),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Bild
              Container(
                height: 330,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(height: 12),

              _bar(double.infinity, 14, skeletonColor),
              const SizedBox(height: 8),
              _bar(220, 14, skeletonColor),

              const SizedBox(height: 14),

              /// Buttons
              Row(
                children: [
                  Icon(Icons.favorite_border, color: skeletonColor, size: 22),
                  const SizedBox(width: 22),
                  Icon(Icons.comment_outlined, color: skeletonColor, size: 22),
                  const SizedBox(width: 22),
                  Icon(Icons.bookmark_border, color: skeletonColor, size: 22),
                  const SizedBox(width: 22),
                  Icon(Icons.ios_share, color: skeletonColor, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
