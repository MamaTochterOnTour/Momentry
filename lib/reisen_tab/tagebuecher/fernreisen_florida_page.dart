import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';
import '../../../l10n/s.dart';

class FloridaPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const FloridaPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<FloridaPage> createState() => _FloridaPageState();
}

class _FloridaPageState extends State<FloridaPage> {
  List<int> currentImageIndex = List.filled(8, 0);

  // Bilder pro Tag
  final List<List<String>> images = [
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida1.jpg?alt=media&token=dd00e0ca-a1fa-4da5-892d-b111c761bde1',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida2.jpg?alt=media&token=e0dc5428-c57a-466a-8f99-17e8d200b8d7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida3.jpg?alt=media&token=934d503f-b75c-4091-abb2-67e5f777b177',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida4.jpg?alt=media&token=b5cc5f54-03dc-4297-90bc-b10e5888e6f4',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida5.jpg?alt=media&token=ceb9f1a4-411a-42d8-87d2-2def3ef772f2',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida6.jpg?alt=media&token=cce2ca0d-dfa2-486e-a8e6-7218f693cb0e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida7.jpg?alt=media&token=a2b9d381-dc1a-435e-8c7f-a27e0052b116',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida8.jpg?alt=media&token=a831f91b-962e-4113-842d-db7721b6ae9a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida9.jpg?alt=media&token=13e558c5-7b29-418a-9ba9-53e40ddc1612',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida10.jpg?alt=media&token=cd0a94e4-18a1-4586-a9cb-382194015061',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida11.jpg?alt=media&token=769eef4f-3664-4598-acab-8aac2dcf736a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida12.JPG?alt=media&token=10152b50-a6f2-44d2-9625-8494cc3e0b5d',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida13.jpg?alt=media&token=3ec0bf68-28d7-4b4e-be95-bebd1f0be8de',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida14.jpg?alt=media&token=1dde952d-6dbb-4aa0-aaf1-cd3a2522dca6',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida15.jpg?alt=media&token=673fb3f3-9261-4ef1-ab56-499fb01d7d13',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida16.jpg?alt=media&token=28d727da-df91-444f-a436-4f72e5064955',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida17.jpg?alt=media&token=127c30d2-b7aa-48d7-9473-c449a20b3036',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlorida18.jpg?alt=media&token=6b7768bb-b714-4f74-914f-233b53410e6a',
    ],
    [],
  ];

  // Funktion, um automatisch zu erkennen, ob das Bild Hoch- oder Querformat ist
  Future<bool> isPortraitNetwork(String url) async {
    final Completer<ui.Image> completer = Completer();
    final NetworkImage networkImage = NetworkImage(url);
    final ImageStream stream = networkImage.resolve(const ImageConfiguration());
    final listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(info.image);
      },
      onError: (error, stackTrace) {
        completer.completeError(error);
      },
    );
    stream.addListener(listener);
    final ui.Image image = await completer.future;
    stream.removeListener(listener);
    return image.height > image.width;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    final titles = [
      s.fl1title,
      s.fl2title,
      s.fl3title,
      s.fl4title,
      s.fl5title,
      s.fl6title,
      s.fl7title,
      s.fl8title,
    ];

    final descriptions = [
      s.fl1Desc,
      s.fl2Desc,
      s.fl3Desc,
      s.fl4Desc,
      s.fl5Desc,
      s.fl6Desc,
      s.fl7Desc,
      s.fl8Desc,
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Florida",
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

                          return FutureBuilder<bool>(
                            future: isPortraitNetwork(path),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final portrait = snapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    path,
                                    fit: portrait
                                        ? BoxFit.fitHeight
                                        : BoxFit.cover,
                                    width: double.infinity,
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
                                  ),
                                ),
                              );
                            },
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
