import 'package:flutter/material.dart';
import '../pages/premium_verwalten_page.dart';
import 'insider_geiranger_page.dart';
import '../providers/premium_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/dark_mode_provider.dart';
import 'insider_mallorca_page.dart';
import 'insider_rom_page.dart';
import '../../l10n/s.dart';

class InsiderPage extends ConsumerStatefulWidget {
  final String? userId;

  const InsiderPage({super.key, this.userId});

  @override
  ConsumerState<InsiderPage> createState() => _InsiderPageState();
}

class _InsiderPageState extends ConsumerState<InsiderPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;
    final darkModeAsync = ref.watch(darkModeProvider);

    return darkModeAsync.when(
      data: (isDarkMode) {
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final secondaryColor = isDarkMode ? Colors.white70 : Colors.black54;
        final bgColor = isDarkMode ? Colors.black : Colors.white;

        // 🌍 LOKALISIERTE DATEN
        final insiderData = {
          strings.countryItaly: [
            {'stadt': strings.cityRome, 'beschreibung': strings.descRome},
          ],
          strings.countryNorway: [
            {
              'stadt': strings.cityGeiranger,
              'beschreibung': strings.descGeiranger,
            },
          ],
          strings.countrySpain: [
            {
              'stadt': strings.cityMallorca,
              'beschreibung': strings.descMallorca,
            },
          ],
        };

        final query = _searchQuery.toLowerCase();

        final filteredData = Map.fromEntries(
          insiderData.entries
              .map((entry) {
                final land = entry.key;
                final staedte = entry.value
                    .where(
                      (stadt) =>
                          stadt['stadt']!.toLowerCase().contains(query) ||
                          land.toLowerCase().contains(query),
                    )
                    .toList();
                return MapEntry(land, staedte);
              })
              .where((entry) => entry.value.isNotEmpty),
        );

        return Container(
          color: bgColor,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 🔍 HEADER / SEARCH
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _isSearching
                    ? TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        autofocus: true,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: strings.searchHint,
                          hintStyle: TextStyle(color: secondaryColor),
                          prefixIcon: Icon(Icons.search, color: secondaryColor),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[850]
                              : Colors.purple[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close, color: secondaryColor),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                strings.insiderTitle,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: secondaryColor),
                            onPressed: () =>
                                setState(() => _isSearching = true),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 12),

              // 📍 LISTE
              Expanded(
                child: filteredData.isEmpty
                    ? Center(
                        child: Text(
                          strings.noResults,
                          style: TextStyle(color: secondaryColor),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          ...filteredData.entries.map((entry) {
                            final land = entry.key;
                            final staedte = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  land,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                ...staedte.map(
                                  (stadt) => _OrtCard(
                                    stadt: stadt['stadt']!,
                                    beschreibung: stadt['beschreibung']!,
                                    isDarkMode: isDarkMode,
                                    uid: widget.userId,
                                  ),
                                ),

                                if (land == strings.countrySpain)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      strings.moreComing,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                          const SizedBox(height: 40),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(S.of(context)!.errorLoading)),
    );
  }
}

class _OrtCard extends ConsumerWidget {
  final String stadt;
  final String beschreibung;
  final bool isDarkMode;
  final String? uid;

  const _OrtCard({
    required this.stadt,
    required this.beschreibung,
    required this.isDarkMode,
    this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = S.of(context)!;

    final cardColor = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final premiumAsync = ref.watch(premiumProvider);

    return GestureDetector(
      onTap: () async {
        final isPremium = premiumAsync.when(
          data: (val) => val,
          loading: () => false,
          error: (_, _) => false,
        );

        if (stadt == strings.cityGeiranger) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GeirangerPage()),
          );
        } else if (stadt == strings.cityMallorca) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MallorcaPage()),
          );
        } else if (stadt == strings.cityRome) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RomPage()),
          );
        } else if (!isPremium) {
          final actualUid = uid ?? FirebaseAuth.instance.currentUser?.uid;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.premiumLocked),
              action: SnackBarAction(
                label: strings.premium,
                onPressed: () {
                  if (actualUid != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PremiumPage(uid: actualUid),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stadt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B4DE8),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  beschreibung,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: textColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
