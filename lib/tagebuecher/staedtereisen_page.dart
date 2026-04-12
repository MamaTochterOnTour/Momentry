import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import deiner Stadt-Seiten
import 'staedtereisen_paris_page.dart';
import 'staedtereisen_genua_page.dart';
import 'staedtereisen_berlin_page.dart';
import '../pages/premium_verwalten_page.dart';
import 'staedtereisen_london_page.dart';
import 'staedtereisen_hamburg_page.dart';
import 'staedtereisen_rom_page.dart';
import 'staedtereisen_wien_page.dart';

// Lokalisierung
import '../../l10n/s.dart';

class StaedtereisenPage extends StatelessWidget {
  final bool isDarkMode;
  final String userId;

  const StaedtereisenPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final lightPurple = const Color(0xFFE6E0F8);
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
                _buildCityBox(
                  strings.parisTitle,
                  strings.parisSubtitle,
                  Icons.favorite,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    ParisPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.berlinTitle,
                  strings.berlinSubtitle,
                  Icons.location_city,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    BerlinPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.hamburgTitle,
                  strings.hamburgSubtitle,
                  Icons.sailing,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    HamburgPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.londonTitle,
                  strings.londonSubtitle,
                  Icons.account_balance,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    LondonPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.romTitle,
                  strings.romSubtitle,
                  Icons.account_balance_wallet,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    RomPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.wienTitle,
                  strings.wienSubtitle,
                  Icons.star,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    WienPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildCityBox(
                  strings.genuaTitle,
                  strings.genuaSubtitle,
                  Icons.map,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
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

  Widget _buildCityBox(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: iconColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: iconColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
