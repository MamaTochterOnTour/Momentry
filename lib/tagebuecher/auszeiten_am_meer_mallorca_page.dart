import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class MallorcaPage extends StatefulWidget {
  final bool isDarkMode;
  final String userId;

  const MallorcaPage({
    super.key,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  State<MallorcaPage> createState() => _MallorcaPageState();
}

class _MallorcaPageState extends State<MallorcaPage> {
  // Aktueller Bildindex
  int currentImageIndex = 0;

  // Bilderpfade für Mallorca (bitte durch echte Bilder ersetzen)
  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca11.jpg?alt=media&token=d320437a-65f3-45d9-a08f-12166aa80529',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca12.jpg?alt=media&token=0442e455-904e-47a2-ac28-891092407598',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca13.jpg?alt=media&token=895e0fe7-0325-4185-90b3-8afe283efe74',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca14.jpg?alt=media&token=8a4d08d9-3ff7-45f3-948e-e32ffcc893db',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca15.jpg?alt=media&token=7c8505d5-fa83-46c7-9632-aae60433d275',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca16.jpg?alt=media&token=c628a7c7-e1b6-4f8d-b7d8-deff6aafecd5',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca17.jpg?alt=media&token=69717cfc-f016-4c7f-a73b-6b981dc726f0',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca18.jpg?alt=media&token=bf43cf6f-f2c9-430f-bdcc-492f34b79f20',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca19.jpg?alt=media&token=02720570-6234-44d7-aec6-205f46f60f24',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca20.jpg?alt=media&token=a80afbaf-cab7-4894-887a-9f84dc7e883c',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca21.jpg?alt=media&token=bd8f625a-0b88-4d2e-a65e-62a4ad648b0f',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca22.jpg?alt=media&token=d8c2433e-2c0f-401a-88c0-3899e394a7f7',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca23.jpg?alt=media&token=ada25019-9633-492a-9798-de23d5184606',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca24.jpg?alt=media&token=74264b52-e983-4564-abfc-cb3716654bce',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca25.jpg?alt=media&token=d2784bcc-6d03-4931-bf82-3d9a2b09823b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca26.jpg?alt=media&token=e308d1af-33ae-4fe4-8981-3b092fb8986a',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca27.jpg?alt=media&token=9d8bf62a-d55f-41ac-a537-d9f8c1dfc358',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca28.jpg?alt=media&token=566f9774-27bb-411d-b527-d4938a59053b',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca29.jpg?alt=media&token=d3f4908a-4dfb-48b8-a844-2ca6dc029f93',
    'https://firebasestorage.googleapis.com/v0/b/reiseapp-mamatocherontour.firebasestorage.app/o/bilder%2FMallorca30.jpg?alt=media&token=af7c2482-70a6-4a34-b4ee-a6007e3c2b41',
  ];

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Mallorca",
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
            S.of(context)!.titleMallorca,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context)!.mallorca,
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
                    fit: BoxFit.contain, // Hoch-/Querformat korrekt
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
