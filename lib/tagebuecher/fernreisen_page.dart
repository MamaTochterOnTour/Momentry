import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'fernreisen_newyork_page.dart';
import 'fernreisen_florida_page.dart';
import 'fernreisen_kalifornien_page.dart';
import 'fernreisen_dubai_page.dart';
import '../pages/premium_verwalten_page.dart';
import '../../l10n/s.dart';

class FernreisenPage extends StatelessWidget {
  final bool isDarkMode;
  final String userId;

  const FernreisenPage({
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
            strings.fernreisenTitle,
            style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
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
                strings.fernreisenIntro,
                style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
                textAlign: TextAlign.left,
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
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNewYork.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLasVegasSign.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKrustyland.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FEsel.jpg?alt=media',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Überschrift
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flight, color: darkPurple),
                const SizedBox(width: 8),
                Text(
                  strings.fernreisenGridTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.flight, color: darkPurple),
              ],
            ),

            const SizedBox(height: 20),

            // Grid mit Premium-Check
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildReiseBox(
                  strings.floridaTitle,
                  strings.floridaSubtitle,
                  Icons.beach_access,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    FloridaPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildReiseBox(
                  strings.kalifornienTitle,
                  strings.kalifornienSubtitle,
                  Icons.terrain,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    KalifornienPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildReiseBox(
                  strings.dubaiTitle,
                  strings.dubaiSubtitle,
                  Icons.location_city,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    DubaiPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
                _buildReiseBox(
                  strings.newyorkTitle,
                  strings.newyorkSubtitle,
                  Icons.location_city,
                  lightPurple,
                  darkPurple,
                  () => checkPremiumAndNavigate(
                    context,
                    NewYorkPage(isDarkMode: isDarkMode, userId: userId),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
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

  Widget _buildReiseBox(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
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
