import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import '../../../l10n/s.dart';

class MediterraneSchaetzeStellaPage extends StatefulWidget {
  final bool isDarkMode;

  const MediterraneSchaetzeStellaPage({super.key, required this.isDarkMode});

  @override
  State<MediterraneSchaetzeStellaPage> createState() =>
      _MediterraneSchaetzeStellaPageState();
}

class _MediterraneSchaetzeStellaPageState
    extends State<MediterraneSchaetzeStellaPage> {
  final List<int> imagesPerDay = [5, 1, 1, 0, 0, 1, 3, 1, 0, 0];
  List<int> currentImageIndex = List.filled(10, 0);

  final List<List<String>> images = [
    [
      // Tag 1+2 Mallorca
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle1.jpeg?alt=media&token=59fec78d-2e2d-4eec-9776-f51c49396e3a', // hoch
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle2.jpeg?alt=media&token=36780489-1870-4196-b5ee-8fba47fee55f', // hoch
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle3.jpeg?alt=media&token=85c007a0-6d91-48c9-9080-a6a9e676edc4', // quer
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle4.jpeg?alt=media&token=079026b9-632f-4901-928e-aff68b275396', // hoch
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle5.jpeg?alt=media&token=528f2c8a-ece8-4372-ae58-c07f3dbec875', // quer
    ],
    [
      // Tag 3 Seetag
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FSeetag.jpeg?alt=media&token=d2be33d2-fb84-4add-9e95-0743ce144149', // hoch
    ],
    [
      // Tag 4 Olbia
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FOlbia.jpeg?alt=media&token=8c7e5947-d7e3-4a4a-9fdf-c6f67bcf4179', // quer
    ],
    [], // Tag 5 Neapel
    [], // Tag 6 Rom
    [
      // Tag 7 Livorno
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FLivorno.jpeg?alt=media&token=9cace721-7154-41b0-bf84-be4bf2b684e7', // hoch
    ],
    [
      // Tag 8 Cannes
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco.jpeg?alt=media&token=714a9b27-d33b-41e6-8451-ca4ddaa32d16', // hoch
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco2.jpeg?alt=media&token=ff16950c-f5bf-4160-b5ac-e536ac15d13a', // quer
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco3.jpeg?alt=media&token=d22e83c5-fb5f-4e7a-91f8-d09486c8ce7a', // quer
    ],
    [
      // Tag 9 Toulon
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FSchifftour%20Toulon.jpg?alt=media&token=57ac50c0-8c9c-4481-b9dd-44e2d70939ab', // quer
    ],
    [], // Tag 10 Barcelona
    [], // Tag 11 Mallorca Rückkehr
  ];

  final Map<String, bool> imageOrientation = {
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle1.jpeg?alt=media&token=59fec78d-2e2d-4eec-9776-f51c49396e3a':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle2.jpeg?alt=media&token=36780489-1870-4196-b5ee-8fba47fee55f':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle3.jpeg?alt=media&token=85c007a0-6d91-48c9-9080-a6a9e676edc4':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle4.jpeg?alt=media&token=079026b9-632f-4901-928e-aff68b275396':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMalle5.jpeg?alt=media&token=528f2c8a-ece8-4372-ae58-c07f3dbec875':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FSeetag.jpeg?alt=media&token=d2be33d2-fb84-4add-9e95-0743ce144149':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FOlbia.jpeg?alt=media&token=8c7e5947-d7e3-4a4a-9fdf-c6f67bcf4179':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FLivorno.jpeg?alt=media&token=9cace721-7154-41b0-bf84-be4bf2b684e7':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco.jpeg?alt=media&token=714a9b27-d33b-41e6-8451-ca4ddaa32d16':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco2.jpeg?alt=media&token=ff16950c-f5bf-4160-b5ac-e536ac15d13a':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FMonaco3.jpeg?alt=media&token=d22e83c5-fb5f-4e7a-91f8-d09486c8ce7a':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstella%20Mediterrane%20Highlights%202019%2FSchifftour%20Toulon.jpg?alt=media&token=57ac50c0-8c9c-4481-b9dd-44e2d70939ab':
        false,
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final s = S.of(context)!;

    final titles = [
      s.cruiseHighlights1,
      s.cruiseHighlights2,
      s.cruiseHighlights3,
      s.cruiseHighlights4,
      s.cruiseSpainDay5_6,
      s.cruiseHighlights7,
      s.cruiseHighlights8,
      s.cruiseHighlights9,
      s.cruiseHighlights10,
      s.cruiseHighlights11,
    ];

    final descriptions = [
      s.cruiseHighlightsTitle1,
      s.cruiseHighlightsTitle2,
      s.cruiseHighlightsTitle3,
      s.cruiseHighlightsTitle4,
      s.cruiseHighlightsTitle5,
      s.cruiseHighlightsTitle6,
      s.cruiseHighlightsTitle7,
      s.cruiseHighlightsTitle8,
      s.cruiseHighlightsTitle9,
      s.cruiseHighlightsTitle10,
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleHighlights,
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
                titles[dayIndex],
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(descriptions[dayIndex], style: TextStyle(color: textColor)),
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
