import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import '../../l10n/s.dart';

class RomPage extends ConsumerWidget {
  const RomPage({super.key});

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
              strings.romPageTitle,
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
                          strings.romDescriptionTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7B4DE8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          strings.romDescription,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: strings.sightsAndActivitiesTitle,
                    icon: Icons.location_city,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.colosseum,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.colosseumDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.forumRomanum,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.forumRomanumDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.pantheon,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.pantheonDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.vatican,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.vaticanDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.treviFountain,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.treviFountainDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.piazzaNavona,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.piazzaNavonaDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.spanishSteps,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.spanishStepsDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.palatineHill,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.palatineHillDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.keyhole,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.keyholeDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.trastevere,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.trastevereDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.orangeGarden,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.orangeGardenDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.coppede,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.coppedeDescription),
                        SizedBox(height: 12),

                        Text(
                          strings.santaMariaTrastevere,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(strings.santaMariaTrastevereDescription),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: strings.culinaryTitle,
                    icon: Icons.restaurant,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.gelateria,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.gelateriaDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          strings.laTavernetta,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.laTavernettaDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          strings.fontanaBakery,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.fontanaBakeryDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          strings.roscioli,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.roscioliDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          strings.streetPizza,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          strings.streetPizzaDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: strings.hotelsTitle,
                    icon: Icons.hotel,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.hotelBolivar,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          strings.hotelBolivarDescription,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  _buildPremiumExpansion(
                    title: strings.arrivalTitle,
                    icon: Icons.directions_boat,
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.flightTrain,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(strings.flightTrainDescription),
                        SizedBox(height: 12),
                        Text(
                          strings.carParking,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(strings.carParkingDescription),
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
