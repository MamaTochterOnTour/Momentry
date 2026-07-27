import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../l10n/s.dart';

class CoteDAzurPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const CoteDAzurPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<CoteDAzurPage> createState() => _CoteDAzurPageState();
}

class _CoteDAzurPageState extends State<CoteDAzurPage> {
  int currentImageIndex = 0;

  // ▶️ Deine 6 Bilder
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur1.jpg?alt=media&token=47d5057c-695c-42cb-b871-24e4d1d35a2f',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur2.jpg?alt=media&token=c3b0202f-2eb5-4ab4-be06-d3b6699f24b2',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur3.jpg?alt=media&token=7bfcb3f3-8ec7-4de9-a8e7-0d9b70ade415',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur4.jpg?alt=media&token=7d45fab0-b404-4d80-928b-37732e4199d5',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur5.jpg?alt=media&token=a111f971-378c-4817-b98c-8edfd21fe60a',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FCoteAzur6.jpg?alt=media&token=bbdcc814-93f9-4535-b7eb-3e9afc32bc63',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,

      // ▶️ AppBar passend für Côte d’Azur
      appBar: AppBar(
        title: Text(
          "Côte d'Azur",
          style: GoogleFonts.pacifico(color: textColor, fontSize: 26),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: textColor),
        toolbarHeight: 80,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ▶️ Titel
          Text(
            S.of(context)!.titleCotedazur,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // ▶️ Beschreibung
          Text(
            S.of(context)!.cotedazur,
            style: TextStyle(color: textColor, fontSize: 16),
          ),

          const SizedBox(height: 20),

          // ▶️ Bilder-Slider (PageView)
          SizedBox(
            height: 500,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (i) {
                setState(() {
                  currentImageIndex = i;
                });
              },
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
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

          // ▶️ Dots unter den Bildern
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (dotIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentImageIndex == dotIndex
                      ? Colors.purple
                      : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
