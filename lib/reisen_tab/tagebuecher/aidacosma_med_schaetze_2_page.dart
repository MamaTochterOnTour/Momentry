import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/s.dart';

class MediterraneSchaetze2Page extends StatefulWidget {
  final bool isDarkMode;

  const MediterraneSchaetze2Page({super.key, required this.isDarkMode});

  @override
  State<MediterraneSchaetze2Page> createState() =>
      _MediterraneSchaetze2PageState();
}

class _MediterraneSchaetze2PageState extends State<MediterraneSchaetze2Page> {
  final List<int> imagesPerDay = [6, 2, 2, 2, 3, 2, 3, 0];
  List<int> currentImageIndex = List.filled(8, 0);

  // Speichert Orientierung jedes Bildes (true = Hochkant, false = Querformat)
  Map<String, bool> imageOrientation = {};

  @override
  void initState() {
    super.initState();
    _detectAllImageOrientations();
  }

  // Liest die Orientierung aller Bilder aus
  void _detectAllImageOrientations() {
    final List<List<String>> allImages = _images;

    for (var dayImages in allImages) {
      for (var img in dayImages) {
        final imgProvider = Image.asset(img).image;

        imgProvider
            .resolve(const ImageConfiguration())
            .addListener(
              ImageStreamListener((ImageInfo info, bool _) {
                final width = info.image.width;
                final height = info.image.height;

                setState(() {
                  imageOrientation[img] = height >= width; // true = Portrait
                });
              }),
            );
      }
    }
  }

  List<List<String>> get _images => [
    // Tag 1
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise1.jpg?alt=media&token=9865f24d-d9a7-4071-bd45-6b58ddc3ed72',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise2.jpg?alt=media&token=f03383ae-ed86-40de-a824-28d26d71c1bb',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise4.jpg?alt=media&token=e0c142a6-cf78-49cc-9a1b-f36926a90e76',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise5.jpg?alt=media&token=5b30ac66-deac-4744-afca-3b4af1b55851',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise6.jpg?alt=media&token=8aec6e66-8e1a-4d09-b29e-0a2a5435c893',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAnreise%2FAnreise7.jpg?alt=media&token=86ad5629-d9e7-4368-96ef-383455f94ad4',
    ],

    // Tag 2
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FSeetag%2FSeetag1.jpg?alt=media&token=67ed2ed6-66bc-40de-b33f-3b21afb183b7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FSeetag%2FSeetag2.jpg?alt=media&token=a7d441f8-2410-40c3-b8ff-2eee5032e771',
    ],

    // Tag 3
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FCagliari%2FCagliari2.jpg?alt=media&token=04e7930d-bba8-49fb-a0a5-baa0eec2b658',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FCagliari%2FCagliari3.jpg?alt=media&token=6dcef2ac-233a-4c64-88fa-c16ce7a95213',
    ],

    // Tag 4
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FRom%2FRom1.jpg?alt=media&token=fc84e4c2-dc2d-456c-9512-d662d313c8e8',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FRom%2FRom2.jpg?alt=media&token=fdb68b62-abfe-44c0-8150-5a2f618994a2',
    ],

    // Tag 5
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAjaccio%2FAjaccio3.jpg?alt=media&token=a51a70d2-a4a8-4eb3-b553-293d06819df7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAjaccio%2FAjaccio5.jpg?alt=media&token=3e27c244-7adb-4f26-96a3-7686b08c5df5',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FAjaccio%2FAjaccio6.jpg?alt=media&token=9dd4989b-48b0-4a34-ad0f-ff5645bbbea0',
    ],

    // Tag 6
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FMarseille%2FMarseille2.jpg?alt=media&token=dabc21f9-1ca9-4990-9ea8-088937e14be9',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FMarseille%2FMarseille3.jpg?alt=media&token=e10a8043-e930-4cda-9f6c-163988dd6236',
    ],

    // Tag 7
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FBarcelona%2FBarcelona1.jpg?alt=media&token=b849296d-703b-4a1f-ba04-c8b7c6631d78',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FBarcelona%2FBarcelona3.jpg?alt=media&token=0775cf18-e1b8-4f03-bb2d-7fc77c650c2a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAcosma%20Med.Schaetze%2FBarcelona%2FBarcelona4.jpg?alt=media&token=e4d0a7bb-ccbc-41fb-b2b2-566e502fc949',
    ],

    [],
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
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
                  s.schatze2TitleDay1,
                  s.schatze2TitleDay2,
                  s.schatze2TitleDay3,
                  s.schatze2TitleDay4,
                  s.schatze2TitleDay5,
                  s.schatze2TitleDay6,
                  s.schatze2TitleDay7,
                  s.schatze2TitleDay8,
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
                  s.schaetze2Day1,
                  s.schaetze2Day2,
                  s.schaetze2Day3,
                  s.schaetze2Day4,
                  s.schaetze2Day5,
                  s.schaetze2Day6,
                  s.schaetze2Day7,
                  s.schaetze2Day8,
                ][dayIndex],
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 12),

              if (imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height:
                          400, // Standardhöhe, wird aber pro Bild dynamisch verändert (siehe unten)
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          final imagePath = _images[dayIndex][imgIndex];

                          final isPortrait =
                              imageOrientation[imagePath] ?? true;
                          final dynamicHeight = isPortrait ? 500 : 300;

                          return SizedBox(
                            height: dynamicHeight.toDouble(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
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
