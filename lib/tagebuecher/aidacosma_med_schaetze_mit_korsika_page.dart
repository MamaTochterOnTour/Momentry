import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class MediterraneSchaetzeMitKorsikaPage extends StatefulWidget {
  final bool isDarkMode;

  const MediterraneSchaetzeMitKorsikaPage({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<MediterraneSchaetzeMitKorsikaPage> createState() =>
      _MediterraneSchaetzeMitKorsikaPageState();
}

class _MediterraneSchaetzeMitKorsikaPageState
    extends State<MediterraneSchaetzeMitKorsikaPage> {
  final List<int> imagesPerDay = [3, 3, 3, 3, 8, 7, 5, 4];
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
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FStern.jpg?alt=media&token=d959aed7-f8bb-49e6-9d41-6384f1b4a6d4',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlieger.jpg?alt=media&token=6e9e2169-7173-48d4-a0aa-5becf01a7bd0',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCosma.jpg?alt=media&token=c9a8a986-867d-4577-b6f5-6cfa5fcd4f58',
    ],

    // Tag 2
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBalkon.jpg?alt=media&token=214fa834-276d-4203-b332-d2cc2e0fed43',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSeepferd.jpg?alt=media&token=757dd6a0-eee1-4652-a3a6-140bf3b4e198',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBordkarte.jpg?alt=media&token=b9f31e7f-0d7c-4e73-b1c3-1351f34145ea',
    ],

    // Tag 3
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBimmelbahnLaSpezia.jpg?alt=media&token=bc6c1bda-489b-4f6a-a8d0-39f6163ff35e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHaeuser.jpg?alt=media&token=6312a8b7-8683-4ea7-86ac-abfb3520b193',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMilchshake.jpg?alt=media&token=0c272a03-cb43-4276-934b-b2ccc73b4d0d',
    ],

    // Tag 4
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMeerCivi.jpg?alt=media&token=87c53de2-895b-4d08-886f-7e83e51828e2',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGebaudeCivi.jpg?alt=media&token=7f58d95c-1607-4ab9-9fa8-51409b4874cb',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAbendMeerCivi.jpg?alt=media&token=ffe3d1bf-a657-40a1-bd5c-3b0beda54ff0',
    ],

    // Tag 5
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKorsika3.jpg?alt=media&token=bc54a5d6-e27b-445f-8922-67c38000edbb',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGaleani.jpg?alt=media&token=cdcd9625-bfa3-414b-9af4-447d6eb3c653',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHaseGeleani.jpg?alt=media&token=7b9e68cc-61c4-4e43-b487-50bc4e5956fd',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBaellchenKorsika.jpg?alt=media&token=7ed1e422-4dca-4382-8678-fe06589c373d',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBrauhaus.jpg?alt=media&token=1eb096b6-3010-4ecc-8403-3c26f057b87f',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMeerKorsika.jpg?alt=media&token=11de58e3-66bc-4e01-be23-ad3ae7f02e21',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMeerKorsika2.jpg?alt=media&token=f8f31ddf-a411-4643-8db7-9ad0204b5a46',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKorsika4.jpg?alt=media&token=2e71247b-f34e-4e5f-a123-7ea6cec3d83a',
    ],

    // Tag 6
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSteakhouse.jpg?alt=media&token=010395f6-4a89-4568-9ed4-52bee622adcc',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSteakhouse1.jpg?alt=media&token=c090632f-293a-42c3-bc6f-ecd95c27bf35',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSteakhouse2.jpg?alt=media&token=25747531-0eae-4444-966d-60aa1466cb94',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSteakhouse3.jpg?alt=media&token=6ec951d5-6d76-4b2e-933a-3f407c9ee70c',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPandora.jpg?alt=media&token=ba4213a9-b6b4-4206-8897-bf85da0a6e43',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FKuchenMed.jpg?alt=media&token=52decda2-aa77-4124-a65e-b00ec247570e',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSteakhouse4.jpg?alt=media&token=9e5a8027-6129-4194-b44c-b2414578c0be',
    ],

    // Tag 7
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMarkt.jpg?alt=media&token=a8262232-17f9-4be6-90ce-baaba33295f3',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FErdbeerNutella.jpg?alt=media&token=8d4ef36a-7545-4709-9fd7-0ff48c92c3c9',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FShoppenBarcelona.jpg?alt=media&token=ba84cf13-38e2-46a6-946b-781c4d168204',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FPinxto.jpg?alt=media&token=0b57a0eb-a4a5-42ae-9e6d-2a1a967ca604',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FSchmetterling.jpg?alt=media&token=1e267fdc-d9bb-4998-9ece-86a6776ba9b7',
    ],

    // Tag 8
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFliegerTicket.jpg?alt=media&token=bb6a4956-d6c8-413c-bc0b-f56836eb0bb2',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlughafenMalle.jpg?alt=media&token=cff85c99-3552-4979-a1e6-7bcae4b2714a',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FFlugMalleKoeln.jpg?alt=media&token=7e2e5960-9bda-4f91-b089-59060e39754b',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAbaccos.jpg?alt=media&token=8a2f306e-de27-4cad-ab3e-c9cc61cfc1c4',
    ],
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
                  s.schatzeTitleDay1,
                  s.schatzeTitleDay2,
                  s.schatzeTitleDay3,
                  s.schatzeTitleDay4,
                  s.schatzeTitleDay5,
                  s.schatzeTitleDay6,
                  s.schatzeTitleDay7,
                  s.schatzeTitleDay8,
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
                  s.schaetzeDay1,
                  s.schaetzeDay2,
                  s.schaetzeDay3,
                  s.schaetzeDay4,
                  s.schaetzeDay5,
                  s.schaetzeDay6,
                  s.schaetzeDay7,
                  s.schaetzeDay8,
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
