import 'package:flutter/material.dart';
import 'product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dark_mode_provider.dart';
import 'download_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class GuideDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const GuideDetailPage({super.key, required this.product});

  @override
  ConsumerState<GuideDetailPage> createState() => _GuideDetailPageState();
}

class _GuideDetailPageState extends ConsumerState<GuideDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initRevenueCat();
  }

  Future<void> _initRevenueCat() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final String revenueCatApiKey = defaultTargetPlatform == TargetPlatform.iOS
        ? "appl_gmnyKKlTRKodMPplBKxcOZakfCp"
        : "goog_NfVXmTIFmqrGxsuyGWDsWhqxnbf";
    await Purchases.configure(PurchasesConfiguration(revenueCatApiKey));
  }

  Future<void> _buyProduct(Product product) async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        throw Exception("Keine Offerings verfügbar.");
      }

      final Package package = offerings.current!.availablePackages.firstWhere(
        (p) => p.identifier == product.rcProductId,
        orElse: () => throw Exception(
          "Package '${product.rcProductId}' nicht im Offering gefunden.",
        ),
      );

      final PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      final CustomerInfo customerInfo = result.customerInfo;
      debugPrint("✅ Kauf erfolgreich: $customerInfo");

      if (!mounted) {
        return; // Prüft, ob das State-Objekt noch im Widget-Baum ist
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DownloadPage(pdfUrl: product.pdfUrl)),
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      debugPrint("❌ PlatformException: $errorCode — ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kauf fehlgeschlagen: ${e.message ?? errorCode}'),
        ),
      );
    } catch (e) {
      debugPrint("❌ Kauf fehlgeschlagen: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kauf fehlgeschlagen: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryText = isDarkMode ? Colors.white70 : Colors.black87;

    final product = widget.product;

    return Scaffold(
      backgroundColor: bgColor,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),

      // ---------------- BODY ----------------
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- IMAGE (FULL VISIBILITY) ----------------
                  SizedBox(
                    width: double.infinity,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain, // ❗ wichtig: nicht mehr crop
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // PRICE
                        Text(
                          "${product.price.toStringAsFixed(2)} €",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DESCRIPTION
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: secondaryText,
                          ),
                        ),

                        const SizedBox(height: 100), // Platz für Button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- FIXED BUY BUTTON (VISIBLE) ----------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _buyProduct(product);
              },

              child: const Text(
                "Jetzt kaufen",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
