import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import '../../l10n/s.dart';

class MallorcaHubPage extends ConsumerWidget {
  const MallorcaHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = S.of(context)!;
    final darkModeAsync = ref.watch(darkModeProvider);

    return darkModeAsync.when(
      data: (isDarkMode) {
        final backgroundColor = isDarkMode ? Colors.black : Colors.grey[100];
        final cardColor = isDarkMode ? Colors.grey[900]! : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              strings.mallorcaTitle,
              style: GoogleFonts.pacifico(fontSize: 26, color: textColor),
            ),
            iconTheme: IconThemeData(color: textColor),
          ),
          body: Column(
            children: [
              const SizedBox(height: 12),

              /// HERO HEADER
              Container(
                height: 180,
                margin: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Mallorca%2FPlayaDeMuro.JPG?alt=media&token=56621954-b9ca-4522-9001-5cad1cf3bc59",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.65),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    strings.mallorcaHeroText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// GRID
              Expanded(
                child: GridView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  children: [
                    _buildCard(
                      context,
                      title: strings.mallorcaFeed,
                      subtitle: strings.mallorcaFeedSubtitle,
                      icon: Icons.dynamic_feed,
                      color: cardColor,
                      textColor: textColor,
                    ),
                    _buildCard(
                      context,
                      title: strings.insiderTips,
                      subtitle: strings.insiderTipsSubtitle,
                      icon: Icons.lightbulb,
                      color: cardColor,
                      textColor: textColor,
                    ),
                    _buildCard(
                      context,
                      title: strings.mallorcaMap,
                      subtitle: strings.mallorcaMapSubtitle,
                      icon: Icons.map,
                      color: cardColor,
                      textColor: textColor,
                    ),
                    _buildCard(
                      context,
                      title: strings.checklist,
                      subtitle: strings.checklistSubtitle,
                      icon: Icons.checklist,
                      color: cardColor,
                      textColor: textColor,
                    ),
                    _buildCard(
                      context,
                      title: strings.miniGuides,
                      subtitle: strings.miniGuidesSubtitle,
                      icon: Icons.menu_book,
                      color: cardColor,
                      textColor: textColor,
                    ),
                    _buildCard(
                      context,
                      title: strings.ourStory,
                      subtitle: strings.ourStorySubtitle,
                      icon: Icons.camera_alt,
                      color: cardColor,
                      textColor: textColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(strings.themeLoadError)),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    final strings = S.of(context)!;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(strings.comingSoon),
                duration: const Duration(seconds: 2),
              ),
            );
          },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF7B4DE8)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
