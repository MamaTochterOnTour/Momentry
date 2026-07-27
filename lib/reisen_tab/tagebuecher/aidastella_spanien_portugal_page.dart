import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/s.dart';

class SpanienPortugalPage extends StatefulWidget {
  final bool isDarkMode;

  const SpanienPortugalPage({super.key, required this.isDarkMode});

  @override
  State<SpanienPortugalPage> createState() => _SpanienPortugalPageState();
}

class _SpanienPortugalPageState extends State<SpanienPortugalPage> {
  // Anzahl Bilder pro Tag
  final List<int> imagesPerDay = [12, 1, 2, 0, 5, 0, 2, 1, 0, 4];
  List<int> currentImageIndex = List.filled(10, 0);

  // Bilder pro Tag (Platzhalter-URLs)
  final List<List<String>> images = [
    // Tag 1 Palma de Mallorca – 12 Bilder (9 hoch, 1 quer, 2 hoch)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca1.jpg?alt=media&token=9f96e022-5459-488f-897f-8138850d1fe9',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca2.jpg?alt=media&token=76eebcc8-dd1c-4ed2-92d9-41b5fd4def67',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca3.jpg?alt=media&token=78d89ce8-29d9-417c-9e8f-6c8545e40c95',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca4.jpg?alt=media&token=50aeeafe-a79e-49b1-bc55-4ffc17f27c3f',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca5.jpg?alt=media&token=c3eb0aaf-e9cf-4748-9577-c420c98e8ab9',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca6.jpg?alt=media&token=ad0c4623-f2d7-4bb5-85eb-2e2480587d64',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca7.jpg?alt=media&token=fdb51c7f-bb47-4903-b616-3c8704fca5be',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca8.jpg?alt=media&token=2d7773a0-c769-43bc-9f7d-75c9d60f9ee7',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca9.jpg?alt=media&token=e09d72d9-fe48-4336-9d75-6cc303d66c69',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise1.jpg?alt=media&token=50f9c82b-48c6-46e9-9b9c-af105fb65eed', // quer
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise2.jpg?alt=media&token=e5c6bf12-366e-43d2-ab0b-116780fb7acf',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise3.jpg?alt=media&token=8c187aff-e23f-49f5-b6cf-14d1e4e2168c',
    ],
    // Tag 2 Seetag – 1 hochkant
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2F1Seetag1.jpg?alt=media&token=fc8131eb-6a6e-4627-8317-0b519d01d295',
    ],
    // Tag 3 Malaga – 2 hochkant
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallaga1.jpg?alt=media&token=ee2ee0c8-7fc5-4d57-a07d-68eaff23eb25',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMalaga2.jpg?alt=media&token=a1873fb6-c0c1-40e6-97f7-6b5ae3854e24',
    ],
    // Tag 4 Cadiz – 0 Bilder
    [],
    // Tag 5 + 6 Lissabon – 5 hochkant
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon1.jpg?alt=media&token=e3376dc4-1d98-4d06-93ea-c14e406bc330',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon2.jpg?alt=media&token=aef059cd-c53a-444e-ba1f-fb8bb9b6b3ee',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon3.jpg?alt=media&token=d7f243ed-3211-4cef-979a-5b56368b4f4b',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon4.jpg?alt=media&token=fc5632fe-f9b6-4b5d-bfe9-dc516a23f9e8',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon5.jpg?alt=media&token=46457565-e9fd-4c71-a571-11456fbdfdfa',
    ],
    // Tag 7 Seetag – 0 Bilder
    [],
    // Tag 8 Cartagena – 2 hochkant
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FCartagena1.jpg?alt=media&token=195ef7d3-e32f-42d5-9561-98a8c5d4e130',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FCartagna2.jpg?alt=media&token=6dd21779-e7c2-4a8e-8cf3-fe232b56bc0b',
    ],
    // Tag 9 Valencia – 1 hochkant
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FValencia1.jpg?alt=media&token=3e8afaa3-aa74-427c-8e2d-e4c73feb97f0',
    ],
    // Tag 10 Barcelona – 0 Bilder
    [],
    // Tag 11 Palma Abreise – 4 Bilder (hoch, hoch, quer, hoch)
    [
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise1.jpg?alt=media&token=094e6d8e-250b-4cd7-9ebf-77e71f158ee8',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise2.jpg?alt=media&token=7d6cd23c-66d3-4eb0-bbf9-55c6e76a2902',
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise3.jpg?alt=media&token=b682adee-5673-4bcd-9bf8-47f125d03d67', // quer
      'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise4.jpg?alt=media&token=1069b9d3-89cf-4b8c-8898-0abea246465c',
    ],
  ];

  // Orientierung der Bilder (true = hochkant, false = quer)
  final Map<String, bool> imageOrientation = {
    // Tag 1 – Palma de Mallorca (12 Bilder)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca1.jpg?alt=media&token=9f96e022-5459-488f-897f-8138850d1fe9':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca2.jpg?alt=media&token=76eebcc8-dd1c-4ed2-92d9-41b5fd4def67':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca3.jpg?alt=media&token=78d89ce8-29d9-417c-9e8f-6c8545e40c95':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca4.jpg?alt=media&token=50aeeafe-a79e-49b1-bc55-4ffc17f27c3f':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca5.jpg?alt=media&token=c3eb0aaf-e9cf-4748-9577-c420c98e8ab9':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca6.jpg?alt=media&token=ad0c4623-f2d7-4bb5-85eb-2e2480587d64':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca7.jpg?alt=media&token=fdb51c7f-bb47-4903-b616-3c8704fca5be':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca8.jpg?alt=media&token=2d7773a0-c769-43bc-9f7d-75c9d60f9ee7':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorca9.jpg?alt=media&token=e09d72d9-fe48-4336-9d75-6cc303d66c69':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise1.jpg?alt=media&token=50f9c82b-48c6-46e9-9b9c-af105fb65eed':
        false, // quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise2.jpg?alt=media&token=e5c6bf12-366e-43d2-ab0b-116780fb7acf':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAnreise3.jpg?alt=media&token=8c187aff-e23f-49f5-b6cf-14d1e4e2168c':
        true,

    // Tag 2 – Seetag (1 Bild, hochkant)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2F1Seetag1.jpg?alt=media&token=fc8131eb-6a6e-4627-8317-0b519d01d295':
        true,

    // Tag 3 – Malaga (2 Bilder, beide hochkant)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallaga1.jpg?alt=media&token=ee2ee0c8-7fc5-4d57-a07d-68eaff23eb25':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMalaga2.jpg?alt=media&token=a1873fb6-c0c1-40e6-97f7-6b5ae3854e24':
        true,

    // Tag 5 Lissabon (5 Bilder, alle hochkant)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon1.jpg?alt=media&token=e3376dc4-1d98-4d06-93ea-c14e406bc330':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon2.jpg?alt=media&token=aef059cd-c53a-444e-ba1f-fb8bb9b6b3ee':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon3.jpg?alt=media&token=d7f243ed-3211-4cef-979a-5b56368b4f4b':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon4.jpg?alt=media&token=fc5632fe-f9b6-4b5d-bfe9-dc516a23f9e8':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FLissabon5.jpg?alt=media&token=46457565-e9fd-4c71-a571-11456fbdfdfa':
        true,

    // Tag 8 Cartagena (2 Bilder, beide hochkant)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FCartagena1.jpg?alt=media&token=195ef7d3-e32f-42d5-9561-98a8c5d4e130':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FCartagna2.jpg?alt=media&token=6dd21779-e7c2-4a8e-8cf3-fe232b56bc0b':
        true,

    // Tag 9 Valencia (1 Bild, hochkant)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FValencia1.jpg?alt=media&token=3e8afaa3-aa74-427c-8e2d-e4c73feb97f0':
        true,

    // Tag 11 Palma Abreise (4 Bilder: hoch, hoch, quer, hoch)
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise1.jpg?alt=media&token=094e6d8e-250b-4cd7-9ebf-77e71f158ee8':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise2.jpg?alt=media&token=7d6cd23c-66d3-4eb0-bbf9-55c6e76a2902':
        true,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise3.jpg?alt=media&token=b682adee-5673-4bcd-9bf8-47f125d03d67':
        false,
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAIDAstellaSpanienPortugal%2FMallorcaAbreise4.jpg?alt=media&token=1069b9d3-89cf-4b8c-8898-0abea246465c':
        true,
  };

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    final titles = [
      s.cruiseSpainDay1,
      s.cruiseSpainDay2,
      s.cruiseSpainDay3,
      s.cruiseSpainDay4,
      s.cruiseSpainDay5_6,
      s.cruiseSpainDay7,
      s.cruiseSpainDay8,
      s.cruiseSpainDay9,
      s.cruiseSpainDay10,
      s.cruiseSpainDay11,
    ];

    final descriptions = [
      s.cruiseSpainDayStart,
      s.cruiseSpainDaySea1,
      s.cruiseSpainDayMalaga,
      s.cruiseSpainDayCadiz,
      s.cruiseSpainDayLisbon,
      s.cruiseSpainDaySea2,
      s.cruiseSpainDayCartagena,
      s.cruiseSpainDayValencia,
      s.cruiseSpainDayBarcelona,
      s.cruiseSpainDayEndMallorca,
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleStellaSpainPortugal,
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
