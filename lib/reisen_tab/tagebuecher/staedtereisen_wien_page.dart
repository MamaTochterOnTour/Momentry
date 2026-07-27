import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import '../../../l10n/s.dart';

class WienPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const WienPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<WienPage> createState() => _WienPageState();
}

class _WienPageState extends State<WienPage> {
  int currentImageIndex = 0;

  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien1.jpg?alt=media&token=596a5e1f-c42b-4fdb-8d0b-70197ca3b1b1', // 1. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien2.jpg?alt=media&token=cdadbcf5-5bf9-4c2b-86df-439861c89426', // 2. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien3.jpeg?alt=media&token=c67ccd1b-7a36-464b-89f9-7320d912c918', // 3. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien4.jpg?alt=media&token=e481191e-3335-48d4-964c-19d406968ec7', // 4. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien5.jpg?alt=media&token=e06c890a-b1d6-4d47-aa13-5901f4b4f6b1', // 5. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien6.JPG?alt=media&token=944bfbef-0b9e-45b3-81ba-ac1ffc55a604', // 6. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien7.JPG?alt=media&token=bbfd57da-36b5-4a93-86fd-4b09a7d4bac1', // 7. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien8.JPG?alt=media&token=89f6b0e9-a50d-4712-b0aa-ee2adf9d3858', // 8. hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien9.JPG?alt=media&token=47600dd7-93d8-4a4a-9549-c35aa223fb14', // 9. quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FWien%2FWien10.JPG?alt=media&token=b8b7bc12-0830-45ad-8430-3b795df8c100', // 10. hochkant
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          S.of(context)!.vienna,
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
            S.of(context)!.titleWien,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.wien,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          const SizedBox(height: 20),

          if (images.isNotEmpty) ...[
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

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
