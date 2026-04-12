import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import '../../l10n/s.dart';

class MallorcaPage extends ConsumerWidget {
  const MallorcaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeAsync = ref.watch(darkModeProvider);
    final strings = S.of(context)!;

    return isDarkModeAsync.when(
      data: (isDarkMode) {
        final bgColor = isDarkMode ? Colors.black : Colors.white;
        final cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!;
        final textColor = isDarkMode ? Colors.white : Colors.black87;
        final subtitleColor = isDarkMode
            ? Colors.grey[400]!
            : Colors.grey[700]!;

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Mallorca',
              style: GoogleFonts.pacifico(
                fontSize: 28,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    cardColor: cardColor,
                    textColor: textColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.mallorcaDescriptionTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B4DE8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          strings.mallorcaDescription,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: strings.beachesCovesNatureTitle,
                    icon: Icons.beach_access,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Es Trenc',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.esTrencDescription),

                        SizedBox(height: 12),
                        Text(
                          'Playa de Palma',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.playaDePalmaDescription),

                        SizedBox(height: 12),
                        Text(
                          'Son Moll (Cala Ratjada)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.calaAgullaDescription),

                        SizedBox(height: 12),
                        Text(
                          'Cala Agulla',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.calaAgullaNatureDescription),

                        SizedBox(height: 12),
                        Text(
                          'Cala Mondragó',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.mondragoBeachDescription),

                        SizedBox(height: 12),
                        Text(
                          'Cap de Formentor',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.capFormentorDescription),

                        SizedBox(height: 12),
                        Text(
                          'Mirador Es Colomer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.formentorViewpointDescription),

                        SizedBox(height: 12),
                        Text(
                          'Torrent de Pareis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.saCalobraGorgeDescription),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.excursionTipsTitle,
                    icon: Icons.location_city,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.palmaTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.palmaDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.cathedralTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.cathedralDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.oldTownTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.oldTownDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.islandDriveTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.islandDriveDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.sollerTrainTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.sollerTrainDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.boatToursTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.boatToursDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.buggyToursTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.buggyToursDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.bellverTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.bellverDescription),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.culinaryTitle,
                    icon: Icons.restaurant,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.mallorcanSpecialtiesTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.mallorcanSpecialtiesDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.paAmbOliTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.paAmbOliDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.ensaimadaTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.ensaimadaDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.mercatSantaCatalinaTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.mercatSantaCatalinaDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.mercatOlivarTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.mercatOlivarDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.littleItalyTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.littleItalyDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.mamaPizzaTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.mamaPizzaDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.saPortassaTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.saPortassaDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.casPatroMarchTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.casPatroMarchDescription),

                        const SizedBox(height: 12),
                        Text(
                          S.of(context)!.timsBarTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(S.of(context)!.timsBarDescription),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.nightlifeTitle,
                    icon: Icons.nightlife,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Text(
                      S.of(context)!.nightlifeDescription,
                      style: const TextStyle(height: 1.5),
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.hotelsTitle,
                    icon: Icons.hotel,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.hotelPlayaGolfTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.hotelPlayaGolfDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.hotelRiuPlayaParkTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.hotelRiuPlayaParkDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.sonMollSentitsTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.sonMollSentitsDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.r2LagoPlayaParkTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.r2LagoPlayaParkDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.arrivalTitle,
                    icon: Icons.directions_boat,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.arrivalByCarFerryTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.arrivalByCarFerryDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.camperTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.camperDescription,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }

  Widget _buildCard({
    required Color cardColor,
    required Color textColor,
    required Widget child,
  }) {
    return Card(
      color: cardColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildPremiumExpansion({
    required String title,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subtitleColor,
    Widget? contentWidget,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(icon, color: subtitleColor),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child:
                contentWidget ?? Text('', style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }
}
