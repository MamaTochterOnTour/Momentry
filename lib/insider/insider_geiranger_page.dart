import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dark_mode_provider.dart';
import '../../l10n/s.dart';

class GeirangerPage extends ConsumerWidget {
  const GeirangerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkModeAsync = ref.watch(darkModeProvider);

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
              'Geiranger',
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
                  // Intro
                  _buildCard(
                    cardColor: cardColor,
                    textColor: textColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.geirangerPageTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight
                                .bold, // nur fett, keine Größenänderung
                            color: Color(
                              0xFF7B4DE8,
                            ), // lila Akzent passend zur App
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context)!.geirangerDescription,
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Expansion-Boxen
                  _buildPremiumExpansion(
                    title: S.of(context)!.ribBoatTitle,
                    icon: Icons.speed,
                    contentWidget: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: S.of(context)!.ribBoatContentIntro),
                          TextSpan(
                            text: S.of(context)!.ribBoatDurationTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.ribBoatDurationContent),
                          TextSpan(
                            text: S.of(context)!.ribBoatServicesTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.ribBoatServicesContent),
                          TextSpan(
                            text: S.of(context)!.ribBoatAgeTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.ribBoatAgeContent),
                          TextSpan(
                            text: S.of(context)!.ribBoatPriceTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.ribBoatPriceContent),
                          TextSpan(
                            text: S.of(context)!.ribBoatTipsTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.ribBoatTipsContent),
                        ],
                      ),
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.fjordSightseeingTitle,
                    icon: Icons.directions_boat,
                    contentWidget: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: S.of(context)!.fjordSightseeingIntro),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingDurationTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S
                                .of(context)!
                                .fjordSightseeingDurationContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingPriceTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingPriceContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingRouteTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingRouteContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingTipsTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.fjordSightseeingTipsContent,
                          ),
                        ],
                      ),
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.kayakTourTitle,
                    icon: Icons.rowing,
                    contentWidget: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: S.of(context)!.kayakTourIntro),
                          TextSpan(
                            text: S.of(context)!.kayakTourWhereWhenTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.kayakTourWhereWhenContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.kayakTourDurationTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.kayakTourDurationContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.kayakTourPriceTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.kayakTourPriceContent),
                          TextSpan(
                            text: S.of(context)!.kayakTourAgeTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.kayakTourAgeContent),
                          TextSpan(
                            text: S.of(context)!.kayakTourWeightTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.kayakTourWeightContent),
                          TextSpan(
                            text: S.of(context)!.kayakTourTipsTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.kayakTourTipsContent),
                        ],
                      ),
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.viewpointsTitle,
                    icon: Icons.landscape,
                    contentWidget: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.6,
                        ),
                        children: [
                          TextSpan(text: S.of(context)!.viewpointsIntro),
                          TextSpan(
                            text: S.of(context)!.viewpointsOrnesvingenTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsOrnesvingenContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsFlydalsjuvetTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsFlydalsjuvetContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsDalsnibbaTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsDalsnibbaContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsHikesTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.viewpointsHikesContent),
                          TextSpan(
                            text: S.of(context)!.viewpointsPackingTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsPackingContent,
                          ),
                          TextSpan(
                            text: S.of(context)!.viewpointsTipsTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: S.of(context)!.viewpointsTipsContent),
                        ],
                      ),
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.culinaryTitle,
                    icon: Icons.restaurant,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.culinaryChocolateTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.culinaryChocolateContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.culinaryLocalTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.culinaryLocalContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.culinaryCafeTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.culinaryCafeContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.culinaryRestaurantTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.culinaryRestaurantContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  _buildPremiumExpansion(
                    title: S.of(context)!.campingTitle,
                    icon: Icons.nature_people,
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.campingSiteTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.campingSiteContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.campingHotelTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.campingHotelContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          S.of(context)!.campingTipTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.of(context)!.campingTipContent,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                    cardColor: cardColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                  ),

                  const SizedBox(height: 16),
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
    String? content, // optionaler String
    Widget? contentWidget, // optionales Widget
    required Color cardColor,
    required Color textColor,
    required Color? subtitleColor,
  }) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(icon, color: subtitleColor ?? textColor),
        iconColor: textColor,
        collapsedIconColor: subtitleColor ?? textColor.withValues(alpha: 153),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                contentWidget ??
                Text(
                  content ?? '',
                  style: TextStyle(fontSize: 16, color: textColor, height: 1.5),
                  textAlign: TextAlign.left,
                ),
          ),
        ],
      ),
    );
  }
}
