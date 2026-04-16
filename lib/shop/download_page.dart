import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// -------------------- Download-Seite --------------------
class DownloadPage extends StatelessWidget {
  final String pdfUrl;
  const DownloadPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vielen Dank!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Vielen Dank für deinen Einkauf!',
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Hier kannst du dein Produkt downloaden.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                  await launchUrl(Uri.parse(pdfUrl));
                } else {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Download fehlgeschlagen")),
                  );
                }
              },
              child: const Text('Jetzt downloaden'),
            ),
          ],
        ),
      ),
    );
  }
}
