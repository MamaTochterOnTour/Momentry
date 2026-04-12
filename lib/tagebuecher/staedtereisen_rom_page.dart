import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import '../../l10n/s.dart';

class RomPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const RomPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<RomPage> createState() => _RomPageState();
}

class _RomPageState extends State<RomPage> {
  int currentImageIndex = 0;

  // 📸 Bilder für Rom
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom1.jpeg?alt=media&token=209b8ed3-c98d-4a2b-80ec-b4c3329570e8', // 1. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom2.jpg?alt=media&token=5b143c43-7482-402d-a09a-3310266cc470', // 2. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom3.jpg?alt=media&token=ba6fb829-f466-4478-adf5-e1c5c5396383', // 3. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom4.jpg?alt=media&token=1cbe51a9-d2e7-477e-b2ca-9d6dd2b954ed', // 4. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom5.jpg?alt=media&token=9d608267-4b96-410d-b728-b13f38569def', // 5. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom6.jpg?alt=media&token=1c6b1ce4-b075-4341-8b75-229fa104d7fd', // 6. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom7.jpg?alt=media&token=189fb2fa-4eea-4382-b105-bdfc9e943c45', // 7. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FRom%2FRom8.jpg?alt=media&token=a59cf100-4c36-4400-af5b-ba2768e5e792', // 8. quer
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.rome,
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
            S.of(context)!.titleRome,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.rom,
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
                      loadStateChanged: (ExtendedImageState state) {
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
