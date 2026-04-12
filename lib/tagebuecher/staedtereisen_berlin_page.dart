import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extended_image/extended_image.dart';
import '../../l10n/s.dart';

class BerlinPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const BerlinPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<BerlinPage> createState() => _BerlinPageState();
}

class _BerlinPageState extends State<BerlinPage> {
  int currentImageIndex = 0;

  // Bilder für Genua (Platzhalter – später austauschbar)
  final List<String> images = [
    // die ersten 3 sind quer
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin1.jpg?alt=media&token=179c275d-bf68-417e-bcfd-c7b2942cf3d6',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin2.jpg?alt=media&token=9cbf326e-34b2-4e09-a00d-8acb55f188b5',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin3.jpg?alt=media&token=3fd85796-1328-4610-91fb-7f5be6debeb1',
    // die restlichen hochkant
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin4.png?alt=media&token=6041097c-4f44-402a-bbe5-b88e6d54f48c',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin5.jpg?alt=media&token=f962f569-de2f-42bf-a4c2-0a8092997de4',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin6.jpg?alt=media&token=263ddb89-3efe-42aa-976c-6ec2c9a14845',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin7.jpg?alt=media&token=09732199-2cf2-45bd-8a32-aaa6c574cef3',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin8.jpg?alt=media&token=c3ec14ee-6fa4-4e3b-99d0-a35d33464a97',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin9.jpg?alt=media&token=f6b4ad08-d80f-40d7-8c20-52275f97a1a7',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin10.jpg?alt=media&token=c3928c4a-01d1-48b4-b2b9-629e37d3df56',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin11.jpg?alt=media&token=15c89640-d070-4307-bd51-f416dde0a1dc',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FBerlin%2FBerlin12.jpg?alt=media&token=45f86e82-5c31-41d4-99bf-262ffed72619',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Berlin",
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
            S.of(context)!.titleBerlin,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.berlin,
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
                      mode: ExtendedImageMode.gesture, // Zoom & Scroll möglich
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
                            return state.completedWidget; // fertiges Bild
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
