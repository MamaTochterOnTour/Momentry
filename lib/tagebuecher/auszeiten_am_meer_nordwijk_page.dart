import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class NordwijkPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const NordwijkPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<NordwijkPage> createState() => _NordwijkPageState();
}

class _NordwijkPageState extends State<NordwijkPage> {
  int currentImageIndex = 0;

  // Bilder für Nordwijk (Platzhalter, später austauschbar)
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk.HEIC?alt=media&token=c0bdced0-5c9d-4c8d-97b9-38df0b76da02',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk2.HEIC?alt=media&token=9bce4128-94e8-4c6b-b2bd-3c5e7a655f22',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk3.heic?alt=media&token=009e802d-b971-40e5-a96c-cf895526ae7b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk4.HEIC?alt=media&token=4a7ae1b7-896c-49b4-af35-b08dfeaf9402',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk5.HEIC?alt=media&token=e118e0ea-bdcf-4850-a094-fe6b4a021716',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FNordwijk6.heic?alt=media&token=a9f64264-2615-434e-b7ad-718f49ec7295',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Nordwijk",
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
          Text(
            S.of(context)!.titleNordwijk,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.nordwijk,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 20),
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
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
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
