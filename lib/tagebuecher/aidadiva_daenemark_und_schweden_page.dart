import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class DaenemarkSchwedenKreuzfahrtPage extends StatefulWidget {
  final bool isDarkMode;

  const DaenemarkSchwedenKreuzfahrtPage({super.key, required this.isDarkMode});

  @override
  State<DaenemarkSchwedenKreuzfahrtPage> createState() =>
      _DaenemarkSchwedenKreuzfahrtPageState();
}

class _DaenemarkSchwedenKreuzfahrtPageState
    extends State<DaenemarkSchwedenKreuzfahrtPage> {
  final List<int> imagesPerDay = [9, 6, 3, 5, 3, 3, 1, 1];
  List<int> currentImageIndex = List.filled(8, 0);

  final List<List<String>> images = [
    // Tag 1 – Warnemünde (9 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende1.jpg?alt=media&token=189b149f-935e-48d1-a04b-8c3313f28f69',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende2.jpg?alt=media&token=7bd2f7fa-bdda-4b0c-905c-4d871f6b46be',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende3.jpg?alt=media&token=c2f9d784-8186-46e8-a267-287ce41ce723',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende4.jpg?alt=media&token=1e223f69-b33c-4f6e-997b-22b20a183646',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende5.jpg?alt=media&token=a2a103b2-868d-4b7e-88c3-665a8a2899aa',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende6.jpg?alt=media&token=07a5edeb-b35c-4888-aedc-81c642387562',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende7.jpg?alt=media&token=23b2aded-ae63-4e45-b19a-ebcd762ded15',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende8.jpg?alt=media&token=b2be4d8f-d8fa-446a-997a-689fd6e3abf6',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende9.jpg?alt=media&token=f065776a-038f-4090-a34c-01dfcbc41ed8',
    ],

    // Tag 2 – Aarhus (6 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus1.jpg?alt=media&token=9008b18a-db95-4831-bcd3-2fc5ae3b7a20',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus2.jpg?alt=media&token=6c517e78-aae9-4742-bfe4-4c2d6dd664f1',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus3.jpg?alt=media&token=bad02d4f-f225-44c3-9cd7-cd418f922d4b',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus4.jpg?alt=media&token=a1e57a5e-7cc3-459c-9e9b-05c2b189d3b7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus5.jpg?alt=media&token=ca0d95ca-2171-4917-97c1-a04085e3bafa',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus6.jpg?alt=media&token=ce1e3ec8-fc55-4596-936f-54fb63a5bead',
    ],

    // Tag 3 – Kopenhagen (3 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen1.jpg?alt=media&token=fb818a05-dbc3-4c00-8e96-270178f4a8d4',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen2.jpg?alt=media&token=b6c794ea-45ad-4ea0-9791-b60e8ae37b6e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen3.jpg?alt=media&token=161506e2-5728-44f3-8841-48b25047870b',
    ],

    // Tag 4 – Seetag (5 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag1.jpg?alt=media&token=7d253d12-fa5b-4257-b178-e273a31cb792',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag2.jpg?alt=media&token=91ada434-a15f-450e-b07a-58d545084da7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag3.jpg?alt=media&token=4c85ec42-ba2e-44e6-9d0d-ea12af585ae9',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag4.jpg?alt=media&token=6dd2e227-9de3-49e4-917d-9dab22555a22',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag5.jpg?alt=media&token=1153fd2a-f4bf-4964-8e83-b4f746e3dd56',
    ],

    // Tag 5 – Visby (3 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby1.jpg?alt=media&token=bf0451fd-790d-41c9-b289-2f8120bfbc4d',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby2.jpg?alt=media&token=fe78be43-4e03-4bbc-840d-f59f760012a6',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby3.jpg?alt=media&token=d9d99b19-4235-44a4-8dd9-bf41bb436938',
    ],

    // Tag 6 – Stockholm (3 Bilder)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm1.jpg?alt=media&token=9f720881-961e-4b29-8b4c-6995f3336fca',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm2.jpg?alt=media&token=94f1c404-d896-49cb-9b96-22a81bee6ce4',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm3.jpg?alt=media&token=2ccfc76d-6329-49b0-92c7-9d6b9050e812',
    ],

    // Tag 7 – Seetag (1 Bild, quer)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2F2Seetag1.jpg?alt=media&token=283e257d-39a6-4814-adfc-8de7f9433ab7',
    ],

    // Tag 8 – Warnemünde Abreise (1 Bild, hochkant)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FAbreise.jpg?alt=media&token=76bc3632-6c6a-49bd-9e8e-a65f1b4cbf42',
    ],
  ];

  final Map<String, bool> imageOrientation = {
    // Warnemünde Tag 1
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende1.jpg?alt=media&token=189b149f-935e-48d1-a04b-8c3313f28f69':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende2.jpg?alt=media&token=7bd2f7fa-bdda-4b0c-905c-4d871f6b46be':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende3.jpg?alt=media&token=c2f9d784-8186-46e8-a267-287ce41ce723':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende4.jpg?alt=media&token=1e223f69-b33c-4f6e-997b-22b20a183646':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende5.jpg?alt=media&token=a2a103b2-868d-4b7e-88c3-665a8a2899aa':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende6.jpg?alt=media&token=07a5edeb-b35c-4888-aedc-81c642387562':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende7.jpg?alt=media&token=23b2aded-ae63-4e45-b19a-ebcd762ded15':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende8.jpg?alt=media&token=b2be4d8f-d8fa-446a-997a-689fd6e3abf6':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FWarnemuende9.jpg?alt=media&token=f065776a-038f-4090-a34c-01dfcbc41ed8':
        true,

    // Aarhus
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus1.jpg?alt=media&token=9008b18a-db95-4831-bcd3-2fc5ae3b7a20':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus2.jpg?alt=media&token=6c517e78-aae9-4742-bfe4-4c2d6dd664f1':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus3.jpg?alt=media&token=bad02d4f-f225-44c3-9cd7-cd418f922d4b':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus4.jpg?alt=media&token=a1e57a5e-7cc3-459c-9e9b-05c2b189d3b7':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus5.jpg?alt=media&token=ca0d95ca-2171-4917-97c1-a04085e3bafa':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FArhus6.jpg?alt=media&token=ce1e3ec8-fc55-4596-936f-54fb63a5bead':
        false,

    // Kopenhagen
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen1.jpg?alt=media&token=fb818a05-dbc3-4c00-8e96-270178f4a8d4':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen2.jpg?alt=media&token=b6c794ea-45ad-4ea0-9791-b60e8ae37b6e':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FKopenhagen3.jpg?alt=media&token=161506e2-5728-44f3-8841-48b25047870b':
        true,

    // Seetag 1
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag1.jpg?alt=media&token=7d253d12-fa5b-4257-b178-e273a31cb792':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag2.jpg?alt=media&token=91ada434-a15f-450e-b07a-58d545084da7':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag3.jpg?alt=media&token=4c85ec42-ba2e-44e6-9d0d-ea12af585ae9':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag4.jpg?alt=media&token=6dd2e227-9de3-49e4-917d-9dab22555a22':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FSeetag5.jpg?alt=media&token=1153fd2a-f4bf-4964-8e83-b4f746e3dd56':
        true,

    // Visby
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby1.jpg?alt=media&token=bf0451fd-790d-41c9-b289-2f8120bfbc4d':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby2.jpg?alt=media&token=fe78be43-4e03-4bbc-840d-f59f760012a6':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FVisby3.jpg?alt=media&token=d9d99b19-4235-44a4-8dd9-bf41bb436938':
        true,

    // Stockholm
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm1.jpg?alt=media&token=9f720881-961e-4b29-8b4c-6995f3336fca':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm2.jpg?alt=media&token=94f1c404-d896-49cb-9b96-22a81bee6ce4':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FStockholm3.jpg?alt=media&token=2ccfc76d-6329-49b0-92c7-9d6b9050e812':
        true,

    // Seetag 2
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2F2Seetag1.jpg?alt=media&token=283e257d-39a6-4814-adfc-8de7f9433ab7':
        false,

    // Warnemünde Abreise
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAdivaDaenemark%26Schweden%2FAbreise.jpg?alt=media&token=76bc3632-6c6a-49bd-9e8e-a65f1b4cbf42':
        true,
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
          S.of(context)!.titleDenmark,
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
                  s.aidaDenmarkDay1,
                  s.aidaDenmarkDay2,
                  s.aidaDenmarkDay3,
                  s.aidaDenmarkDay4,
                  s.aidaDenmarkDay5,
                  s.aidaDenmarkDay6,
                  s.aidaDenmarkDay7,
                  s.aidaDenmarkDay8,
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
                  s.aidaDenmark1,
                  s.aidaDenmark2,
                  s.aidaDenmark3,
                  s.aidaDenmark4,
                  s.aidaDenmark5,
                  s.aidaDenmark6,
                  s.aidaDenmark7,
                  s.aidaDenmark8,
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
