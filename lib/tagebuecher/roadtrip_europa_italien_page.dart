import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'dart:async';
import '../../l10n/s.dart';

class ItalienPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const ItalienPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<ItalienPage> createState() => _ItalienPageState();
}

class _ItalienPageState extends State<ItalienPage> {
  List<int> currentImageIndex = List.filled(13, 0);

  List<String> getTitles(S s) {
    return [s.it1Title, s.it2Title, s.it3Title, s.it4Title, s.it5Title];
  }

  List<String> getDescriptions(S s) {
    return [s.it1Desc, s.it2Desc, s.it3Desc, s.it4Desc, s.it5Desc];
  }

  final List<List<String>> images = [
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand.HEIC?alt=media&token=fbceabdd-9081-4d86-8e70-58e18f3c086f',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand2.HEIC?alt=media&token=48d4065c-852a-4e92-a1b8-27bd0ac3d716',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand3.HEIC?alt=media&token=275668b3-006a-4fd3-a721-57e1509e2030',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand4.HEIC?alt=media&token=046becbb-32e8-47c0-b34f-9e06daa99877',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand5.HEIC?alt=media&token=f290eed8-6721-4236-ae40-9522c3dfc46b',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMailand6.HEIC?alt=media&token=de217382-388d-4bbd-a519-9806fee48605',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPortofino.HEIC?alt=media&token=9bc2569f-93b6-40fb-a893-85513fba34ad',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPortofino2.HEIC?alt=media&token=b386b351-0240-4933-9e6f-54eb29d646ce',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPortofino3.HEIC?alt=media&token=1004b2d3-8122-4af7-8a4e-e38568f1560a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPortofino4.HEIC?alt=media&token=4523921c-843a-4947-969f-aa7c790342ed',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPortofino5.JPG?alt=media&token=593e32c0-cc74-4fa8-9a00-a07907d7357b',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom.HEIC?alt=media&token=c83eef6e-6259-44a5-88cd-846eaf2e883f',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom2.HEIC?alt=media&token=875b1966-dbcf-433d-a6ec-376b562c993f',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom3.HEIC?alt=media&token=3ac4b632-fb11-498e-be26-d6413fa2f444',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom4.HEIC?alt=media&token=a9cabca2-6b6b-45d1-b7a8-d50ac3513ca3',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAmalfi.HEIC?alt=media&token=14b18ace-97e3-4d7f-a43a-d81f50ce9c72',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAmalfi2.HEIC?alt=media&token=4235a9c3-d47e-45cd-9744-1dcb51d511b5',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAmalfi3.HEIC?alt=media&token=01dc3869-195f-4a9d-88bc-ba71d0032d46',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCapri.HEIC?alt=media&token=18fc9f1b-c8a1-4f2b-9011-40b37848603e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCapri2.HEIC?alt=media&token=adbd1a1b-bc6e-4ec9-9254-5317c1800d1a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCapri3.heic?alt=media&token=2165ddb6-f7e4-4e5b-a49d-a737c88b994c',
    ],
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRimini.HEIC?alt=media&token=94156872-45de-4465-b1c0-1e14eab9bc84',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig.JPG?alt=media&token=ef77948c-1b9b-463a-a0a8-24d49eb8e4ff',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig2.HEIC?alt=media&token=92264a51-9e20-4903-bbf0-f07d228e11b4',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig3.jpg?alt=media&token=42a99e6c-0b5f-4026-b8f7-f9a023aeacaf',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig4.JPG?alt=media&token=6ae9c45c-5219-4d49-96e4-be8f9a09a3be',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig5.HEIC?alt=media&token=d6789905-48e7-49e9-977f-241f33576175',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FVenedig6.JPG?alt=media&token=e013b3fa-249a-4678-aea8-bdb947e75133',
    ],
  ];

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
    final titles = getTitles(s);
    final descriptions = getDescriptions(s);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.italy,
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

                                  return Center(
                                    child: Image.network(
                                      path,
                                      fit: BoxFit
                                          .contain, // Originalproportionen beibehalten
                                      width: isPortrait
                                          ? 200
                                          : double
                                                .infinity, // optional kleiner für Hochkant
                                      height: isPortrait
                                          ? 400
                                          : 300, // nur zur Orientierung, Bild wird nicht verzerrt
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            );
                                          },
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
                    const SizedBox(height: 32),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
