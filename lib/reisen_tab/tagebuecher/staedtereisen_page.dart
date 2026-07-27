import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import deiner Stadt-Seiten
import 'staedtereisen_paris_page.dart';
import 'staedtereisen_genua_page.dart';
import 'staedtereisen_berlin_page.dart';
import '../../profil_tab/premium_verwalten_page.dart';
import 'staedtereisen_london_page.dart';
import 'staedtereisen_hamburg_page.dart';
import 'staedtereisen_rom_page.dart';
import 'staedtereisen_wien_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dark_mode_provider.dart';

// Lokalisierung
import '../../../l10n/s.dart';

class StaedtereisenPage extends ConsumerWidget {
  final String userId;

  const StaedtereisenPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final strings = S.of(context)!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final darkPurple = const Color(0xFF7B4DE8);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            strings.staedtereisenTitle,
            style: GoogleFonts.pacifico(fontSize: 26, color: textColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Einleitung
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                strings.staedtereisenIntro,
                style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            // Runde Bilder
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FParis2.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKoeln.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg.jpg?alt=media',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Überschrift
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city, color: darkPurple),
                const SizedBox(width: 8),
                Text(
                  strings.staedtereisenTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.location_city, color: darkPurple),
              ],
            ),

            const SizedBox(height: 20),

            // Grid mit Stadt-Boxen
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FParis.png?alt=media&token=13fe372c-0e34-49ec-a1a2-c155557b5ba7",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    ParisPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FBerlin.png?alt=media&token=4a175d43-a322-4a02-9d63-73322359f963",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    BerlinPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FHamburg.png?alt=media&token=87375cc9-2931-4383-b243-5cee23789735",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    HamburgPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FLondon.png?alt=media&token=5e0afa35-3840-4970-9b85-89249d6d89fa",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    LondonPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FRom.png?alt=media&token=0589fd33-6236-4c7b-95ab-4754f1fadfde",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    RomPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FWien.png?alt=media&token=e762b09d-9ea7-4eb4-8639-d3259e65e7b5",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    WienPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),

                _buildCityThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FGenua.png?alt=media&token=c8f51a48-6d65-491a-b19f-fd78488c2f0e",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    GenuaPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkPremiumAndNavigate(
    BuildContext context,
    Widget page,
  ) async {
    final strings = S.of(context)!;
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      final isPremium = userDoc.get('isPremium') ?? false;
      if (!context.mounted) return;

      if (isPremium) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      } else {
        final snackBar = SnackBar(
          content: GestureDetector(
            onTap: () {
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PremiumPage(uid: userId)),
              );
            },
            child: Text(strings.premiumSnackbarText),
          ),
          backgroundColor: const Color(0xFF7B4DE8),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.premiumErrorText),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  Widget _buildCityThumbnail({
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withValues(alpha: 0.1), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}
