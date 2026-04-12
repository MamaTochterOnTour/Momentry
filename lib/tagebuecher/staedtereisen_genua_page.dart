import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class GenuaPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const GenuaPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<GenuaPage> createState() => _GenuaPageState();
}

class _GenuaPageState extends State<GenuaPage> {
  int currentImageIndex = 0;

  // Bilder für Genua (Platzhalter – später austauschbar)
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua.HEIC?alt=media&token=0ba6a3a1-3214-4929-b27c-3a318829630b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua2.HEIC?alt=media&token=504da8a5-1909-435d-a75c-1a6d9e718992',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua3.JPG?alt=media&token=676c2e28-14c9-41fe-8889-665a96341390',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua4.HEIC?alt=media&token=febb7b45-3cf5-4d22-a5eb-f001fb9712d2',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua5.HEIC?alt=media&token=f91b4552-33a2-48fe-a8bd-7a2744552f32',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua6.heic?alt=media&token=3b2bac41-816e-46b1-aa1f-587159226158',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua7.jpg?alt=media&token=d9be28bb-5269-4ad9-a3e3-22a22063ad2d',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua8.HEIC?alt=media&token=0a088aa1-6d00-4c65-bbdb-282dba051a87',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua9.JPG?alt=media&token=cc58c1ec-2689-4eaa-a4cd-2bf582346c2f',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua10.HEIC?alt=media&token=9b149ac5-7d06-4897-8b43-a869855f56f2',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FGenua11.JPG?alt=media&token=658a9ede-3a24-4bd4-8445-3adf2cb585bc',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.genoa,
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
            S.of(context)!.titleGenua,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.genua,
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
                    fit: BoxFit.contain,
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
        ],
      ),
    );
  }
}
