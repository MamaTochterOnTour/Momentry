import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../../../l10n/s.dart';

class MediterraneSchaetzeNovaPage extends StatefulWidget {
  final bool isDarkMode;

  const MediterraneSchaetzeNovaPage({super.key, required this.isDarkMode});

  @override
  State<MediterraneSchaetzeNovaPage> createState() =>
      _MediterraneSchaetzePageState();
}

class _MediterraneSchaetzePageState extends State<MediterraneSchaetzeNovaPage> {
  final List<int> imagesPerDay = [3, 1, 0, 1, 0, 0, 0];
  List<int> currentImageIndex = List.filled(7, 0);

  final List<List<String>> images = [
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FMedSchaetze1Anreise.jpg?alt=media&token=c05826cf-85a5-4c39-8c92-cf1388d3ee8c',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FAIDAnova%202.jpg?alt=media&token=d9312cb3-baf0-4972-a567-76d810d27075',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FMedSchaetze1Tier.jpg?alt=media&token=4dd70fdc-177b-4419-9d0c-35f5561d3884',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FSeetagAIDAnova.jpg?alt=media&token=b13f20a3-9f1f-4b13-9e0b-5e65fb0e47d9',
    ],
    [],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FPisaAIDAnova.jpg?alt=media&token=55d2b3cb-0672-4247-bdd4-024879edfdb1',
    ],
    [],
    [],
    [],
  ];

  final Map<String, bool> imageOrientation = {
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FMedSchaetze1Anreise.jpg?alt=media&token=c05826cf-85a5-4c39-8c92-cf1388d3ee8c':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FAIDAnova%202.jpg?alt=media&token=d9312cb3-baf0-4972-a567-76d810d27075':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FMedSchaetze1Tier.jpg?alt=media&token=4dd70fdc-177b-4419-9d0c-35f5561d3884':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FSeetagAIDAnova.jpg?alt=media&token=b13f20a3-9f1f-4b13-9e0b-5e65fb0e47d9':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAnova%20Mediterrane%20Schätze%2FPisaAIDAnova.jpg?alt=media&token=55d2b3cb-0672-4247-bdd4-024879edfdb1':
        true,
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleMedTreasures,
          style: GoogleFonts.pacifico(color: textColor, fontSize: 28),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        toolbarHeight: 80,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: imagesPerDay.length,
        itemBuilder: (context, dayIndex) {
          final imageCount = imagesPerDay[dayIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [
                  s.novaTitleDay1,
                  s.novaTitleDay2,
                  s.novaTitleDay3,
                  s.novaTitleDay4,
                  s.novaTitleDay5,
                  s.novaTitleDay6,
                  s.novaTitleDay7,
                ][dayIndex],
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                [
                  s.novaDay1,
                  s.novaDay2,
                  s.novaDay3,
                  s.novaDay4,
                  s.novaDay5,
                  s.novaDay6,
                  s.novaDay7,
                ][dayIndex],
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 12),

              if (imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          final path = images[dayIndex][imgIndex];
                          final portrait = imageOrientation[path] ?? true;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                path,
                                fit: portrait
                                    ? BoxFit.fitHeight
                                    : BoxFit.fitWidth,
                                width: double.infinity,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageCount, (dotIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentImageIndex[dayIndex] == dotIndex
                                ? Colors.purple
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
