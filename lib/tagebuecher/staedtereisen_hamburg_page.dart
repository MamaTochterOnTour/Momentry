import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import '../../l10n/s.dart';

class HamburgPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const HamburgPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<HamburgPage> createState() => _HamburgPageState();
}

class _HamburgPageState extends State<HamburgPage> {
  int currentImageIndex = 0;

  // Bilder für Hamburg
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg1.jpg?alt=media&token=3717b2b0-ec19-4e98-a9d9-5a01e44839bd', // 1. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg2.jpg?alt=media&token=72d7faa3-ef46-476f-9f0a-db6bc454d8fc', // 2. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg3.jpg?alt=media&token=fe0c5eab-6fa1-4ea7-a17f-489e3f0a422d', // 3. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg4.jpg?alt=media&token=90d09015-f552-442f-9813-49a6c8856200', // 4. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg5.jpg?alt=media&token=0aeb29c6-4b79-4e65-a257-4336aee7bbb5', // 5. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FHamburg%2FHamburg6.jpg?alt=media&token=4d6bf6a2-2563-4a51-aa69-75ef12b2277d', // 6. hochkant
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Hamburg",
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
            S.of(context)!.titleHamburg,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.hamburg,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 500,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (i) {
                setState(() => currentImageIndex = i);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExtendedImage.network(
                      images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      cache: true,
                      mode: ExtendedImageMode.gesture,
                      handleLoadingProgress: true,
                      loadStateChanged: (state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case LoadState.failed:
                            return const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            );
                          case LoadState.completed:
                            return state.completedWidget;
                        }
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
