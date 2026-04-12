import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import '../../l10n/s.dart';

class LondonPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const LondonPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<LondonPage> createState() => _LondonPageState();
}

class _LondonPageState extends State<LondonPage> {
  int currentImageIndex = 0;

  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLondon%2FLondon1.JPG?alt=media&token=4a3021f8-2ab0-46e6-978b-e588670f5e0d', // 1. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLondon%2FLondon2.JPG?alt=media&token=2301e369-be9b-4325-a44a-9f8fa6fc7f56', // 2. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLondon%2FLondon3.JPG?alt=media&token=4c991633-21a2-4266-a70d-2fd8a15e6d5d', // 3. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLondon%2FLondon4.JPG?alt=media&token=ddca487c-14ee-45c2-92b8-260f2770a42e', // 4. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FLondon%2FLondon5.JPG?alt=media&token=0c6c756f-8280-4687-bb5d-77eae462aafe', // 5. hochkant
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "London",
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
            S.of(context)!.titleLondon,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.london,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 20),

          // 🖼️ Bilder-Slider
          if (images.isNotEmpty)
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
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
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

          if (images.isNotEmpty) const SizedBox(height: 8),

          // 🔵 Punkte
          if (images.isNotEmpty)
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
