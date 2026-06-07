import 'package:flutter/material.dart';
import 'guide_detail_page.dart';
import 'product.dart';
import 'travel_guides_date.dart';
import '../providers/dark_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/mama_tochter_tagebuch_page.dart';

class GuidesMockPage extends ConsumerWidget {
  const GuidesMockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true, // 👈 wichtig für zentriert

        title: Text(
          "Reiseinsider", // 👈 oder "Mama-Tochter Reisen"
          style: GoogleFonts.pacifico(fontSize: 26, color: textColor),
        ),

        iconTheme: IconThemeData(color: textColor),

        actions: [],
      ),

      // ================= BODY =================
      body: ListView(
        children: [
          // ---------------- HERO ----------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MamaTochterTagebuchPage(),
                  ),
                );
              },
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[900]
                      : const Color(0xFFE6E0F8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "❤️ Mama-Tochter Reisetagebücher",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ================= BELIEBT =================
          _SectionTitle(title: "🔥 Beliebt", isDarkMode: isDarkMode),

          const SizedBox(height: 8),

          _BeliebteGuidesRow(isDarkMode: isDarkMode),

          const SizedBox(height: 24),

          // ================= KREUZFAHRT =================
          _SectionTitle(title: "🚢 Kreuzfahrtguides", isDarkMode: isDarkMode),

          const SizedBox(height: 8),

          _SubSection(title: "AIDA Kreuzfahrten", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('aida'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 28),

          // ================= REGIONEN =================
          _SectionTitle(title: "🗺️ Regionen", isDarkMode: isDarkMode),

          const SizedBox(height: 8),

          _SubSection(title: "Spanien", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('spanien'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Italien", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('italien'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Norwegen", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('norwegen'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Kanaren", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('kanaren'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Karibik", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('karibik'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Deutschland", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('deutschland'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Frankreich", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('frankreich'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Niederlande", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('niederlande'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "England", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('england'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 16),

          _SubSection(title: "Belgien", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('belgien'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 28),

          // ================= REISEPLANUNG =================
          _SectionTitle(title: "🧭 Reiseplanung", isDarkMode: isDarkMode),

          _HorizontalList(
            products: travelGiudes
                .where((p) => p.categories.contains('reiseplanung'))
                .toList(),
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------------- SECTION TITLE ----------------
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const _SectionTitle({required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// ---------------- SUB SECTION TITLE ----------------
class _SubSection extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const _SubSection({required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}

// ---------------- HORIZONTAL LIST MOCK ----------------
class _HorizontalList extends StatelessWidget {
  final List<Product> products;
  final bool isDarkMode;

  const _HorizontalList({required this.products, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _GuideCardImage(
            product: products[index],
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }
}

class _BeliebteGuidesRow extends StatelessWidget {
  final bool isDarkMode;

  const _BeliebteGuidesRow({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final List<Product> guides = travelGiudes
        .where((p) => p.categories.contains('beliebt'))
        .toList();

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: guides.length,
        itemBuilder: (context, index) {
          return _GuideCardImage(
            product: guides[index],
            isDarkMode: isDarkMode,
          );
        },
      ),
    );
  }
}

class _GuideCardImage extends StatelessWidget {
  final Product product;
  final bool isDarkMode;

  const _GuideCardImage({required this.product, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? Colors.grey[900]! : Colors.grey[200]!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuideDetailPage(product: product)),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
