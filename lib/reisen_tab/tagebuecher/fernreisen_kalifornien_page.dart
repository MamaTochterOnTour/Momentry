import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';
import '../../../l10n/s.dart';

class KalifornienPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const KalifornienPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<KalifornienPage> createState() => _KalifornienPageState();
}

class _KalifornienPageState extends State<KalifornienPage> {
  List<int> currentImageIndex = List.filled(7, 0);

  // Bilder pro Tag
  final List<List<String>> images = [
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien1.jpg?alt=media&token=e7eefbdc-61cd-4c95-a7ec-20c5e729aefe',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien2.jpg?alt=media&token=185a4dbb-16c1-4b26-9eed-7ddc292c75f2',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien3.jpg?alt=media&token=3fdec7e5-4a97-468f-8e6e-16c34ae65956',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien4.jpg?alt=media&token=541c740c-ada2-42f9-b8bb-65f555490385',
    ],
    [],
    [],
    [],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien5.jpg?alt=media&token=c0ecda60-46a8-4201-9832-193b5349a2c2',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien6.jpg?alt=media&token=bab1d5da-adb2-4937-9e21-58f9fc9bf152',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien7.jpg?alt=media&token=2c53b971-ac43-49c4-97ee-d13c495448d4',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien8.jpg?alt=media&token=33b9e2ba-6684-45c9-b26f-833476faf44e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien9.jpg?alt=media&token=507f5445-9a3b-4233-a734-7b1a27a3cc7c',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien10.jpg?alt=media&token=1999e3f7-93cc-4fcb-b726-46ef07450998',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien12.jpg?alt=media&token=c67db1e6-7302-4d0a-8822-d16ace6de759',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien13.jpg?alt=media&token=e0d9ff2d-5b8d-4568-bf2b-f43b329f0cd5',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien14.jpg?alt=media&token=d8d3f70b-236d-41fc-921a-1531a24d5760',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien15.jpg?alt=media&token=e3f1aa0e-d7d4-44c7-a21c-e13e6c45cb02',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKalifornien16.jpg?alt=media&token=0aa24b77-4ecc-4d1b-a731-5d0a83ea6325',
    ],
  ];

  // Funktion zur automatischen Hoch-/Querformat-Erkennung
  Future<bool> isPortrait(String assetPath) async {
    final image = AssetImage(assetPath);
    final config = ImageConfiguration();
    final completer = Completer<ui.Image>();
    final stream = image.resolve(config);
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });
    stream.addListener(listener);
    final ui.Image img = await completer.future;
    stream.removeListener(listener);
    return img.height > img.width;
  }

  Future<ui.Image> _getImageSize(String imageUrl) async {
    final completer = Completer<ui.Image>();
    final networkImage = NetworkImage(imageUrl);
    final stream = networkImage.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    });
    stream.addListener(listener);
    final image = await completer.future;
    stream.removeListener(listener);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    final titles = [
      s.ca1title,
      s.ca2title,
      s.ca3title,
      s.ca4title,
      s.ca5title,
      s.ca6title,
      s.ca7title,
    ];

    final descriptions = [
      s.ca1Desc,
      s.ca2Desc,
      s.ca3Desc,
      s.ca4Desc,
      s.ca5Desc,
      s.ca6Desc,
      s.ca7Desc,
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.california,
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
        itemCount: images.length,
        itemBuilder: (context, dayIndex) {
          final imageCount = images[dayIndex].length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel pro Tag
              Text(
                titles[dayIndex],
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                descriptions[dayIndex],
                style: TextStyle(color: textColor, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 12),

              // Bilder pro Tag
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

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FutureBuilder<ui.Image>(
                                future: _getImageSize(path),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final ui.Image img = snapshot.data!;
                                  final isPortrait = img.height > img.width;

                                  return Image.network(
                                    path,
                                    fit: isPortrait
                                        ? BoxFit.cover
                                        : BoxFit.fitWidth,
                                    width: double.infinity,
                                    height: isPortrait ? 300 : 200,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                        ),
                                      );
                                    },
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
