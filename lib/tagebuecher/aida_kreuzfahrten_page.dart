import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'aidaperla_norwegen_kreuzfahrt_page.dart';
import 'aidacosma_med_schaetze_mit_korsika_page.dart';
import 'aidaprima_orient_kreuzfahrt_page.dart';
import 'aidaprima_metropolen_ab_hamburg_page.dart';
import 'aidaperla_karibik_page.dart';
import '../pages/premium_verwalten_page.dart';
import 'aidanova_mediterrane_schaetze_2019_page.dart';
import 'aidastella_mediterranehighlights_page.dart';
import 'aidadiva_daenemark_und_schweden_page.dart';
import 'aidastella_spanien_portugal_page.dart';
import 'aidaprima_norwegens_fjorde_mit_geiranger_page.dart';
import '../../l10n/s.dart';

class AidaKreuzfahrtenPage extends StatelessWidget {
  final bool isDarkMode;
  final String userId;

  const AidaKreuzfahrtenPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
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
            strings.aidaTitle,
            textAlign: TextAlign.center,
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
                strings.aidaIntro,
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
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDA.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHeckwellen.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMolde.jpg?alt=media',
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSonnenuntergang.jpg?alt=media',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Überschrift
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.anchor, color: darkPurple),
                const SizedBox(width: 8),
                Text(
                  strings.aidaGridTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.anchor, color: darkPurple),
              ],
            ),

            const SizedBox(height: 20),

            // Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FMedSchaetze.png?alt=media&token=6571cc73-5ceb-4b05-a23b-8e275573de06",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    MediterraneSchaetzeNovaPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FMedHighlights.png?alt=media&token=fd2b9dbf-c1c2-4542-b397-bdf755212ae8",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    MediterraneSchaetzeStellaPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FOrient.png?alt=media&token=3a9de5fd-fde6-40f5-92da-f2c8fa36851d",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    DubaiKreuzfahrtPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FDaenemarkSchweden.png?alt=media&token=c2fe3039-d373-4caa-abbb-cde76b5341bc",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    DaenemarkSchwedenKreuzfahrtPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FMetropolen.png?alt=media&token=1abd663a-ca05-473a-9f41-51d8e5e469e3",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    MetropolenAbHamburgPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FSpanienPortugal.png?alt=media&token=98b382e2-3b63-4c12-8499-2a6ba6e10da1",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    SpanienPortugalPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FKaribik.png?alt=media&token=7eafbf2a-dfd8-4c8f-9c89-69698b4e33a5",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            KaribikReisePage(isDarkMode: isDarkMode),
                      ),
                    );
                  },
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FNorwegen.png?alt=media&token=2bc2f799-83c3-4fdd-9346-29550762677b",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    NorwegenKreuzfahrtPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FMedSchaetzeMitKorsika.png?alt=media&token=501fccb7-7c5c-4102-9fdf-893056d8422a",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    MediterraneSchaetzeMitKorsikaPage(isDarkMode: isDarkMode),
                  ),
                ),

                _buildKreuzfahrtThumbnail(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FThumbnails%2FNorwegen2.png?alt=media&token=ba6fd7a0-b436-4916-bccb-29b99f99e66a",
                  onTap: () => checkPremiumAndNavigate(
                    context,
                    NorwegenFjordePage(isDarkMode: isDarkMode),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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

  Widget _buildKreuzfahrtThumbnail({
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
