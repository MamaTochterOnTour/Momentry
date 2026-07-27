import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/s.dart';

class NorwegenKreuzfahrtPage extends StatefulWidget {
  final bool isDarkMode;

  const NorwegenKreuzfahrtPage({super.key, required this.isDarkMode});

  @override
  State<NorwegenKreuzfahrtPage> createState() => _NorwegenKreuzfahrtPageState();
}

class _NorwegenKreuzfahrtPageState extends State<NorwegenKreuzfahrtPage> {
  // Anzahl der Bilder pro Tag
  final List<int> imagesPerDay = [2, 3, 3, 1, 2, 1, 3, 1, 2, 1, 0];

  // Aktueller Bildindex pro Tag
  List<int> currentImageIndex = List.filled(11, 0);

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final s = S.of(context)!;

    final titles = [
      s.aidaDay1_de,
      s.aidaDay2_de,
      s.aidaDay3_de,
      s.aidaDay4_de,
      s.aidaDay5_de,
      s.aidaDay6_de,
      s.aidaDay7_de,
      s.aidaDay8_de,
      s.aidaDay9_de,
      s.aidaDay10_de,
      s.aidaDay11_de,
    ];

    final texts = [
      s.norwegenPrequelDay1,
      s.norwegenPrequelDay2,
      s.norwegenPrequelDay3,
      s.norwegenPrequelDay4,
      s.norwegenDoublePortDay,
      s.norwegenTrondheimDay,
      s.norwegenAlesundDay,
      s.norwegenEidfjordDay,
      s.norwegenStavangerDay,
      s.norwegenSeetagFinalDay,
      s.norwegenFinalDeparture,
    ];

    // Bilderpfade pro Tag
    final List<List<String>> images = [
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg4.jpg?alt=media&token=ac2700b3-a5f5-4486-8986-ba6985988b8c',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FStella.jpg?alt=media&token=106e0c01-e7b7-4143-b929-3bb9a9c06f2f',
      ], // Tag 1
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHeckwellen3.jpg?alt=media&token=1802aad2-fd3f-48c5-ae61-b0e01efa86c4',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBett.jpg?alt=media&token=579073d1-e8ce-4128-a4f6-8da2852efd14',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FErdbeeren.jpg?alt=media&token=9b253391-a6e8-4773-a4d9-3e76f125576f',
      ], // Tag 2
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FTroll.jpg?alt=media&token=a25b239e-3c53-4f07-bc55-a8345c7e71bd',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBergen3.jpg?alt=media&token=d0379f84-25a8-4ee5-9d00-893414240b82',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBergenAussicht.jpg?alt=media&token=50617af2-6632-4cac-b12e-0ea39529657f',
      ], // Tag 3
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2F360Foto.jpg?alt=media&token=b72f2b4a-fcd7-46dc-9199-8e51255b771a',
      ], // Tag 4
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FZug.jpg?alt=media&token=4612c3d3-233d-4e85-8c03-46f17cd08786',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMolde3.jpg?alt=media&token=5fc5069d-aaca-45a8-81ff-95ec64a1e1c2',
      ], // Tag 5
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FTrondheim3.jpg?alt=media&token=f13c0c08-42c6-46f8-b2aa-3d170d8c8f10',
      ], // Tag 6
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAlesund5.jpg?alt=media&token=4a01fff3-4925-49ed-8053-9892de18a0fe',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FAlesund4.jpg?alt=media&token=75edf4b3-0c2f-4734-bbae-45e9118e64cd',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBimmelbahn.jpg?alt=media&token=a41ecd3f-f8fc-4159-92d1-0e9ba7957c45',
      ], // Tag 7
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNebel.jpg?alt=media&token=a09a7e80-64a2-4522-a180-8a158c963c24',
      ], // Tag 8
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWichteltuer.jpg?alt=media&token=c77c71c7-5370-4fde-a4d6-63c83e7e320a',
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FStavanger3.jpg?alt=media&token=ddb6c794-ba13-498e-ba73-b74b3b6b8ae7',
      ], // Tag 9
      [
        'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHandtuchtiere.jpg?alt=media&token=f3322503-599d-4b59-a366-684792a06e58',
      ], // Tag 10
      [], // Tag 11
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.titleNorwegen,
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
          // Hochkant-Tage: 2,3,4,8,9,10
          final isPortraitDay = [1, 2, 3, 7, 8, 9].contains(dayIndex);
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

              const SizedBox(height: 4),

              Text(texts[dayIndex], style: TextStyle(color: textColor)),

              const SizedBox(height: 8),

              if (imageCount > 0)
                Column(
                  children: [
                    SizedBox(
                      height: isPortraitDay ? 500 : 300,
                      child: PageView.builder(
                        itemCount: imageCount,
                        onPageChanged: (index) {
                          setState(() {
                            currentImageIndex[dayIndex] = index;
                          });
                        },
                        itemBuilder: (context, imageIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              images[dayIndex][imageIndex],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
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

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
