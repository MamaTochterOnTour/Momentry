import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/s.dart';

class ReisebuerosPage extends StatefulWidget {
  final bool isDarkMode;
  const ReisebuerosPage({super.key, required this.isDarkMode});

  @override
  State<ReisebuerosPage> createState() => _ReisebuerosPageState();
}

class _ReisebuerosPageState extends State<ReisebuerosPage> {
  int _currentImageIndex = 0;
  final PageController _galleryController = PageController();
  bool _isExpanded = false;

  List<String> raeumeImages = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Tui%2FTUI_Mitarbeiter-085.jpg?alt=media&token=5fc7857b-cdb7-42bf-8f3c-ef9b6e1c98c5',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Tui%2FTUI_Mitarbeiter-092.jpg?alt=media&token=3e08ad0c-85bf-4b81-8d77-326927cf98eb',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Tui%2FTUI_Mitarbeiter-099.jpg?alt=media&token=9eabe292-5383-410b-a750-6ffcba5262b4',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Tui%2FTUI_Mitarbeiter-109.jpg?alt=media&token=68a5ac17-070a-4e6e-ba9e-5d4f7fdf4c3b',
  ];

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;

    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = widget.isDarkMode ? Colors.white70 : Colors.black54;
    final accentColor = const Color(0xFF8C77FF);

    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          // ---------- HEADER ----------
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Stack(
              children: [
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/Tui%2FTUI_Mitarbeiter.jpg?alt=media&token=88ed70d7-a7c2-47bc-9ff6-38b0c23870c4',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    strings.headerTitleTUI,
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------- CONTENT ----------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ---------- BESCHREIBUNG ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isExpanded
                              ? strings.fullTextReisebuero
                              : strings.previewTextReisebuero,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Text(
                            _isExpanded ? strings.readLess : strings.readMore,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ---------- LEISTUNGEN ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.public, color: accentColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            strings.serviceTravel,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- FEATURE CARDS (JETZT LOKALISIERT) ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _featureCard(
                          strings.featureLongHaul,
                          Icons.flight,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featurePackage,
                          Icons.beach_access,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureIndividual,
                          Icons.map,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureRoundTrips,
                          Icons.explore,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureCruises,
                          Icons.directions_boat,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureFamily,
                          Icons.family_restroom,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureHoneymoon,
                          Icons.favorite,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureClub,
                          Icons.group,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureCityTrips,
                          Icons.location_city,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureCamper,
                          Icons.directions_car,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureLuxury,
                          Icons.star,
                          accentColor,
                        ),
                        _featureCard(
                          strings.featureWellness,
                          Icons.spa,
                          accentColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------- KONTAKT ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.contactTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _contactTile(
                          icon: Icons.email,
                          label: strings.emailLabel,
                          onTap: () => _launch(
                            'mailto:Aschaffenburg1@tui-reisebuero.de',
                          ),
                          textColor: textColor,
                        ),
                        _contactTile(
                          icon: Icons.chat,
                          label: strings.whatsappLabel,
                          onTap: () => _launch('https://wa.me/49602133610'),
                          textColor: textColor,
                        ),
                        _contactTile(
                          icon: Icons.camera_alt,
                          label: strings.instagramLabel,
                          onTap: () => _launch(
                            'https://www.instagram.com/tuiaschaffenburg',
                          ),
                          textColor: textColor,
                        ),
                        _contactTile(
                          icon: Icons.location_on,
                          label: strings.googleMapsLabel,
                          onTap: () => _launch(
                            'https://maps.app.goo.gl/w7o7yhVBNqpL35UE6',
                          ),
                          textColor: textColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.onlineConsultation,
                          style: TextStyle(color: secondaryColor, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ---------- GALERIE ----------
                  Column(
                    children: [
                      SizedBox(
                        height: 320,
                        child: PageView.builder(
                          controller: _galleryController,
                          itemCount: raeumeImages.length,
                          onPageChanged: (index) =>
                              setState(() => _currentImageIndex = index),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                raeumeImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          raeumeImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == index ? 10 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == index
                                  ? accentColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ---------- DISCLAIMER ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      strings.disclaimerPartner,
                      style: TextStyle(fontSize: 11, color: secondaryColor),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(String text, IconData icon, Color color) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: TextStyle(color: color, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: textColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
