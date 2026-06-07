import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/s.dart';

class PremiumPage extends StatefulWidget {
  final String uid;

  const PremiumPage({super.key, required this.uid});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _isDarkMode = doc['isDarkMode'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Fehler beim Laden des DarkMode: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;

    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final secondaryColor = _isDarkMode ? Colors.white70 : Colors.black54;
    final featureTextColor = _isDarkMode ? Colors.white : Colors.black;
    final darkPurple = const Color(0xFF7B4DE8);

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: featureTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.premiumTitle,
          style: GoogleFonts.pacifico(color: featureTextColor, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium-Vorteile
            Card(
              color: _isDarkMode ? Colors.grey[850] : Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.premiumBenefitsTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureItem(
                      strings.premiumBenefit1,
                      featureTextColor,
                    ),
                    _buildFeatureItem(
                      strings.premiumBenefit2,
                      featureTextColor,
                    ),
                    _buildFeatureItem(
                      strings.premiumBenefit3,
                      featureTextColor,
                    ),
                    _buildFeatureItem(
                      strings.premiumBenefit4,
                      featureTextColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      strings.premiumComingSoon,
                      style: TextStyle(color: featureTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Abo-Status
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                bool isPremium = false;
                if (snapshot.hasData && snapshot.data!.exists) {
                  isPremium = snapshot.data!['isPremium'] ?? false;
                }

                return Card(
                  color: _isDarkMode ? Colors.grey[850] : Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.premiumStatusTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isPremium
                              ? strings.premiumStatusActive
                              : strings.premiumStatusInactive,
                          style: TextStyle(
                            color: featureTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Premium-Angebote
            Row(
              children: [
                Expanded(
                  child: _buildPremiumPackage(
                    context,
                    strings.premiumMonthly,
                    false,
                    strings,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPremiumPackage(
                    context,
                    strings.premiumYearly,
                    true,
                    strings,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kauf wiederherstellen
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDarkMode
                      ? Colors.deepPurple
                      : Colors.purple,
                  foregroundColor: Colors.white,
                ),
                onPressed: _restorePurchase,
                child: Text(strings.premiumRestoreButton),
              ),
            ),
            const SizedBox(height: 10),

            // Hinweistext
            Center(
              child: Column(
                children: [
                  Text(
                    strings.premiumLegalIntro,
                    style: TextStyle(fontSize: 12, color: secondaryColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _launchURL(strings.premiumPrivacyUrl),
                        child: Text(
                          strings.premiumPrivacy,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: darkPurple,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        ' ${strings.premiumLegalAnd} ',
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                      ),
                      GestureDetector(
                        onTap: () => _launchURL(strings.premiumTermsUrl),
                        child: Text(
                          strings.premiumTerms,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: darkPurple,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        strings.premiumLegalDot,
                        style: TextStyle(fontSize: 12, color: secondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPackage(
    BuildContext context,
    String title,
    bool highlight,
    S strings,
  ) {
    final textColor = Colors.black;
    final price = title.contains('monatlich') ? '4,99 €' : '49,99 €';

    return FutureBuilder<Offerings>(
      future: Purchases.getOfferings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.current == null) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const Text("Keine Angebote verfügbar"),
          );
        }

        final offerings = snapshot.data!;
        final currentOffering = offerings.current!;
        final Package package = title.contains('monatlich')
            ? currentOffering.availablePackages.firstWhere(
                (p) => p.packageType == PackageType.monthly,
                orElse: () => currentOffering.availablePackages.first,
              )
            : currentOffering.availablePackages.firstWhere(
                (p) => p.packageType == PackageType.annual,
                orElse: () => currentOffering.availablePackages.first,
              );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: highlight ? Colors.purple[50] : Colors.grey[100],
            border: Border.all(
              color: highlight ? Colors.deepPurple : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (highlight)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          strings.premiumBestPrice,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async => _purchasePackage(package),
                  child: Text(strings.premiumBuyButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _restorePurchase() async {
    try {
      CustomerInfo purchaserInfo = await Purchases.restorePurchases();
      final isActive =
          purchaserInfo.entitlements.all["all_access"]?.isActive ?? false;
      if (isActive) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.uid)
            .update({'isPremium': true});
        debugPrint("Firestore isPremium = true gesetzt");
      } else {
        debugPrint("Entitlement all_access ist nicht aktiv!");
      }
    } catch (e) {
      debugPrint("Fehler beim Wiederherstellen: $e");
    }
  }

  Future<void> _purchasePackage(Package package) async {
    try {
      PurchaseResult result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      final isActive =
          result.customerInfo.entitlements.all["all_access"]?.isActive ?? false;
      if (isActive) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.uid)
            .update({'isPremium': true});
        debugPrint("Firestore isPremium = true gesetzt");
      } else {
        debugPrint("Entitlement all_access ist nicht aktiv!");
      }
    } catch (e) {
      debugPrint("Fehler beim Kauf: $e");
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
