import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../tagebuecher/aida_kreuzfahrten_page.dart';
import '../tagebuecher/fernreisen_page.dart';
import '../tagebuecher/roadtrip_europa_page.dart';
import '../tagebuecher/staedtereisen_page.dart';
import '../tagebuecher/auszeiten_am_meer_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/s.dart';
import '../providers/premium_provider.dart';
import '../liveboard/liveboard_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MamaTochterTagebuchPage extends StatefulWidget {
  final String? userId; // UID für Navigationszwecke

  const MamaTochterTagebuchPage({super.key, this.userId});

  @override
  State<MamaTochterTagebuchPage> createState() =>
      _MamaTochterTagebuchPageState();
}

class _MamaTochterTagebuchPageState extends State<MamaTochterTagebuchPage> {
  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    try {
      final userId = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (doc.exists) {
        setState(() {
          _isDarkMode = doc.data()?['isDarkMode'] ?? false;
        });
      }
    } catch (e) {
      debugPrint("Fehler beim Laden des DarkMode: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final S strings = S.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final secondaryColor = _isDarkMode ? Colors.white70 : Colors.black54;
    final lightPurple = const Color(0xFFE6E0F8);
    final darkPurple = const Color(0xFF7B4DE8);
    final userId = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: _isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            strings.pageTitle,
            style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
          ),
        ),
        body: TabBarView(
          children: [
            // ------------------ TAB 1: Tagebücher ------------------
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Einführungstext in Card
                  Card(
                    color: _isDarkMode ? Colors.grey[900] : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        strings.welcomeText,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Drei runde Bilder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FTelefonzelle.jpg?alt=media&token=15fa64ad-a153-41e3-8ba1-f51978d4c3f8',
                        ),
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHotel.jpg?alt=media&token=64d83d02-bd56-4e60-89cc-b8fbd2245245',
                        ),
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLaRomana.jpg?alt=media&token=28c369cf-433b-4eba-accf-ccfa4109e4d5',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Überschrift Reiseziele
                  Text(
                    strings.ourDestinations,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    strings.discoverAdventures,
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                  const SizedBox(height: 20),

                  // Sechs anklickbare Boxen mit Lokalisierung
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final isPremium =
                              ref.watch(premiumProvider).value ?? false;

                          return _buildCategoryBox(
                            strings.mallorcaTitle1,
                            strings.mallorcaSubtitle,
                            Icons.explore,
                            lightPurple,
                            darkPurple,
                            onTap: () {
                              if (isPremium) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MallorcaLiveboardPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(strings.comingSoon3),
                                    backgroundColor: const Color(0xFF7B4DE8),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      _buildCategoryBox(
                        strings.aidaCruisesTitle,
                        strings.aidaCruisesSubtitle,
                        Icons.directions_boat,
                        lightPurple,
                        darkPurple,
                        onTap: () {
                          if (userId == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AidaKreuzfahrtenPage(
                                isDarkMode: _isDarkMode,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCategoryBox(
                        strings.longDistanceTitle,
                        strings.longDistanceSubtitle,
                        Icons.flight_takeoff,
                        lightPurple,
                        darkPurple,
                        onTap: () {
                          if (userId == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FernreisenPage(
                                isDarkMode: _isDarkMode,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCategoryBox(
                        strings.roadtripEuropeTitle,
                        strings.roadtripEuropeSubtitle,
                        Icons.directions_car,
                        lightPurple,
                        darkPurple,
                        onTap: () {
                          if (userId == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoadtripEuropaPage(
                                isDarkMode: _isDarkMode,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCategoryBox(
                        strings.cityTripsTitle,
                        strings.cityTripsSubtitle,
                        Icons.location_city,
                        lightPurple,
                        darkPurple,
                        onTap: () {
                          if (userId == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StaedtereisenPage(
                                isDarkMode: _isDarkMode,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildCategoryBox(
                        strings.seasideGetawaysTitle,
                        strings.seasideGetawaysSubtitle,
                        Icons.beach_access,
                        lightPurple,
                        darkPurple,
                        onTap: () {
                          if (userId == null) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuszeitenAmMeerPage(
                                isDarkMode: _isDarkMode,
                                userId: userId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Social Media Bereich
                  Text(
                    strings.followOurJourney,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _launchURL(
                              'https://www.tiktok.com/@mamatochterontour?_r=1&_t=ZN-91h5KogGGpS',
                            ),
                            child: _SocialEmoji('🎵', 'TikTok', textColor),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _launchURL(
                              'https://www.instagram.com/mamatochterontour',
                            ),
                            child: _SocialEmoji('📸', 'Instagram', textColor),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _launchURL(
                              'https://youtube.com/@mamatochterontour',
                            ),
                            child: _SocialEmoji('📹', 'YouTube', textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _launchURL('https://podimo.com/s/nINWncrW'),
                            child: _SocialEmoji('🎤', 'Podcast', textColor),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () =>
                                _launchURL('https://snapchat.com/t/GXxrlXT3'),
                            child: _SocialEmoji('👻', 'Snapchat', textColor),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => _launchURL(
                              'https://www.twitch.tv/mamatochterontour',
                            ),
                            child: _SocialEmoji('🎮', 'Twitch', textColor),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Hinweis & Disclaimer
                  Text(
                    strings.note,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.disclaimer,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBox(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

// --------------------- Social Emoji Widget ---------------------
class _SocialEmoji extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _SocialEmoji(this.emoji, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 32, color: color)),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
