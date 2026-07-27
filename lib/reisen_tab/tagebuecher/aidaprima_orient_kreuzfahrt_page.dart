import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/s.dart';

class DubaiKreuzfahrtPage extends StatefulWidget {
  final bool isDarkMode;

  const DubaiKreuzfahrtPage({super.key, required this.isDarkMode});

  @override
  State<DubaiKreuzfahrtPage> createState() => _DubaiKreuzfahrtPageState();
}

class _DubaiKreuzfahrtPageState extends State<DubaiKreuzfahrtPage> {
  // Anzahl der Bilder pro Tag
  final List<int> imagesPerDay = [1, 0, 2, 0, 3, 0];

  // Aktueller Bildindex pro Tag
  List<int> currentImageIndex = List.filled(6, 0);

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    final titles = [
      s.orientDay1,
      s.orientDay2,
      s.orientDay3,
      s.orientDay4,
      s.orientDay5,
      s.orientDay6,
    ];

    final descriptions = [
      s.orient1,
      s.orient2,
      s.orient3,
      s.orient4,
      s.orient5,
      s.orient6,
    ];

    // Bilderpfade pro Tag
    final List<List<String>> images = [
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubaiAnreise.jpg?alt=media&token=5ca04b3c-e10b-45ba-a81a-9ecb7aee2e9f',
      ], // Tag 1
      [], // Tag 2
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFerrari.jpg?alt=media&token=ff83adca-7199-4f75-bb88-271a9356648c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFerrari2.jpg?alt=media&token=5db617fb-f5a5-4973-94b0-2e1faadf7aa9',
      ], // Tag 3
      [], // Tag 4
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2Fwasserflugzeug2.jpg?alt=media&token=11625893-abec-4a68-847c-0dd1a8ae1f82',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2Fwasserflugzeug3.jpg?alt=media&token=61987f10-3cb4-4711-8981-8dd7031d4e56',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2Fwasserflugzeug4.jpg?alt=media&token=8f7e18d9-9efb-468d-b839-8bef70b7a4d3',
      ], // Tag 5
      [], // Tag 6
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleOrientDubai,
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
                      height: 400, // Standardhöhe für alle Bilder
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              images[dayIndex][imgIndex],
                              fit: BoxFit.contain,
                              width: double.infinity,
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
