import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class MetropolenAbHamburgPage extends StatefulWidget {
  final bool isDarkMode;

  const MetropolenAbHamburgPage({super.key, required this.isDarkMode});

  @override
  State<MetropolenAbHamburgPage> createState() =>
      _MetropolenAbHamburgPageState();
}

class _MetropolenAbHamburgPageState extends State<MetropolenAbHamburgPage> {
  final List<int> imagesPerDay = [2, 1, 0, 0, 0, 1, 0];
  List<int> currentImageIndex = List.filled(8, 0);

  final List<List<String>> images = [
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWillkommenAIDA.jpg?alt=media&token=e9ec67af-9085-4a1d-b6a5-cd110a6d99e0',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAuslaufenAIDA.jpg?alt=media&token=69155081-e81b-45b6-89cd-0c976468f77d',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSeetag6.jpg?alt=media&token=9e7be0d1-7b7c-4c44-8003-5ea3578bd10a',
    ],
    [],
    [],
    [],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRotterdamAIDA.jpg?alt=media&token=aa684629-e260-4b94-be38-75fef6027939',
    ],
    [],
  ];

  final Map<String, bool> imageOrientation = {
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWillkommenAIDA.jpg?alt=media&token=e9ec67af-9085-4a1d-b6a5-cd110a6d99e0':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAuslaufenAIDA.jpg?alt=media&token=69155081-e81b-45b6-89cd-0c976468f77d':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSeetag6.jpg?alt=media&token=9e7be0d1-7b7c-4c44-8003-5ea3578bd10a':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRotterdamAIDA.jpg?alt=media&token=aa684629-e260-4b94-be38-75fef6027939':
        false,
  };

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleMetropolen,
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
                  s.metropolenDay1,
                  s.metropolenDay2,
                  s.metropolenDay3,
                  s.metropolenDay4,
                  s.metropolenDay5,
                  s.metropolenDay6,
                  s.metropolenDay7,
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
                  s.metropolen1,
                  s.metropolen2,
                  s.metropolen3,
                  s.metropolen4,
                  s.metropolen5,
                  s.metropolen6,
                  s.metropolen7,
                ][dayIndex],
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 12),

              if (imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height: 300, // max Höhe, Quer/Hochkant passt sich an
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (i) {
                          setState(() {
                            currentImageIndex[dayIndex] = i;
                          });
                        },
                        itemBuilder: (context, imgIndex) {
                          final path = images[dayIndex][imgIndex];
                          final bool portrait = imageOrientation[path] ?? true;

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
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                          : null,
                                    ),
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
