import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import '../shop/download_page.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shop/product.dart';
import '../shop/product_box.dart';
import '../shop/travel_guides_date.dart';

final List<String> filters = [
  "Alle",
  "Kurztrips",
  "Hafentage",
  "Fernreisen",
  "Fernweh-Karten",
  "Bundles",
  "Kreuzfahrten",
  "Reiseplanung",
];

class TravelGuidesPage extends StatefulWidget {
  final bool isDarkMode;
  const TravelGuidesPage({super.key, required this.isDarkMode});

  @override
  State<TravelGuidesPage> createState() => _TravelGuidesPageState();
}

class _TravelGuidesPageState extends State<TravelGuidesPage>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  List<Product> displayedProducts = [];
  List<Product> favorites = [];
  List<Product> allProducts = travelGiudes;

  bool _isSearching = false; // für die Suchleiste über AppBar
  final TextEditingController _searchController = TextEditingController();

  bool _isDarkMode = false;
  late String currentUserUid;

  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    _loadFavorites();
    _initRevenueCat();
    _loadUserSettings();

    _updateDisplayedProducts();
  }

  Future<void> _loadUserSettings() async {
    // Achtung: currentUserUid musst du selbst definieren!
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _isDarkMode = userDoc.data()?['isDarkMode'] ?? false;
      });
    }
  }

  Future<void> _initRevenueCat() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final String revenueCatApiKey = defaultTargetPlatform == TargetPlatform.iOS
        ? "appl_gmnyKKlTRKodMPplBKxcOZakfCp"
        : "goog_NfVXmTIFmqrGxsuyGWDsWhqxnbf";
    await Purchases.configure(PurchasesConfiguration(revenueCatApiKey));
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favData = prefs.getString('favorites') ?? '[]';
    setState(() {
      favorites = (json.decode(favData) as List)
          .map((e) => Product.fromJson(e))
          .toList();
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'favorites',
      json.encode(favorites.map((e) => e.toJson()).toList()),
    );
  }

  void _updateDisplayedProducts() {
    setState(() {
      displayedProducts = allProducts.where((p) {
        final matchesSearch =
            p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.description.toLowerCase().contains(searchQuery.toLowerCase());

        final matchesFilter =
            selectedFilter == 0 ||
            p.categories.contains(filters[selectedFilter]);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _toggleFavorite(Product product) {
    setState(() {
      if (favorites.any((p) => p.id == product.id)) {
        favorites.removeWhere((p) => p.id == product.id);
      } else {
        favorites.add(product);
      }
    });
    _saveFavorites();
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

  void _openFavoritesSheet() {
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final darkPurple = const Color(0xFF8C77FF);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Favoriten',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: favorites.isEmpty
                      ? Center(
                          child: Text(
                            'Keine Favoriten',
                            style: TextStyle(color: textColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final product = favorites[index];
                            return ListTile(
                              onTap: () => _showProductSheet(
                                product,
                              ), // <-- Produktseite öffnen
                              leading: Image.network(
                                product.imageUrl,
                                width: 50,
                              ),
                              title: Text(
                                product.name,
                                style: TextStyle(color: textColor),
                              ),
                              subtitle: Text(
                                '${product.price.toStringAsFixed(2)} €',
                                style: TextStyle(color: darkPurple),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    favorites.remove(product);
                                  });
                                  _saveFavorites(); // <-- richtige Funktion zum Speichern
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? Colors.black : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Suche nach Orten & Reisen',
                  hintStyle: TextStyle(color: textColor.withAlpha(150)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  searchQuery = value;
                  _updateDisplayedProducts();
                },
              )
            : Text(
                'Reiseguides',
                style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
              ),
        leading: IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: textColor,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _searchController.clear();
                searchQuery = '';
                _updateDisplayedProducts();
              }
              _isSearching = !_isSearching;
            });
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.favorite, color: textColor),
                onPressed: _openFavoritesSheet,
              ),
              if (favorites.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      favorites.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= FILTER DROPDOWN =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: _isDarkMode
                          ? Colors.grey[900]
                          : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: filters.length,
                          itemBuilder: (context, index) {
                            final isSelected = selectedFilter == index;

                            return ListTile(
                              title: Text(
                                filters[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF8C77FF)
                                      : textColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                  _updateDisplayedProducts();
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8C77FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          filters[selectedFilter],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= PRODUKT GRID =================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 0.7,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                final isFav = favorites.any((p) => p.id == product.id);

                return ProductBox(
                  product: product,
                  isDarkMode: _isDarkMode,
                  onTap: () => _showProductSheet(product),
                  onAddToCart: () {},
                  onToggleFavorite: () => _toggleFavorite(product),
                  isFavorite: isFav,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProductSheet(Product product) {
    final textColor = _isDarkMode ? Colors.white : Colors.black;
    final darkPurple = const Color(0xFF8C77FF);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price.toStringAsFixed(2)} €',
                  style: TextStyle(fontSize: 20, color: darkPurple),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: TextStyle(color: textColor),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _buyProduct(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Jetzt kaufen'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
