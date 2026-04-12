import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class DubaiPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const DubaiPage({super.key, required this.isDarkMode, required this.userId});

  @override
  State<DubaiPage> createState() => _DubaiPageState();
}

class _DubaiPageState extends State<DubaiPage> {
  int currentImageIndex = 0;

  // Bilder für Dubai
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai.JPG?alt=media&token=01d206f3-579a-4811-96ba-e2232afa9424',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai2.JPG?alt=media&token=471802b4-8c6d-45bb-983f-55bc80685421',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai3.JPG?alt=media&token=c0d81970-c9a8-4ac7-b192-a93dc21bc9b1',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai4.JPG?alt=media&token=8f0a6e05-7158-4998-9f3a-2bdf5361745b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai5.JPG?alt=media&token=8a140fde-236f-4357-ab12-172b5d89ce1b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai6.JPG?alt=media&token=2e282bfd-af54-494a-be97-461000f731fd',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai8.JPG?alt=media&token=d12ac394-5024-4f5b-b380-0b4b775f14e1',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FDubai9.JPG?alt=media&token=2ed90ead-26cb-4175-9378-82edee54cf57',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Dubai",
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
            S.of(context)!.titleDubai,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.dubai,
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
