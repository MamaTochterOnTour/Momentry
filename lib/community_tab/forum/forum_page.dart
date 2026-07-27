import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dark_mode_provider.dart';
import 'region_country_page.dart';
import 'topics_page.dart';
import 'forum_search_page.dart';

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({super.key});

  @override
  ConsumerState<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends ConsumerState<ForumPage> {
  final TextEditingController _searchController = TextEditingController();

  bool isSearching = false;
  String searchQuery = "";

  bool matchesSearch(Map<String, dynamic> data) {
    if (searchQuery.trim().isEmpty) {
      return true;
    }

    final query = searchQuery.toLowerCase().trim();

    final searchableText = [
      data["text"] ?? "",
      data["titel"] ?? "",
      data["beschreibung"] ?? "",
      data["caption"] ?? "",
      data["location"] ?? "",
      data["username"] ?? "",
      data["region"] ?? "",
      data["country"] ?? "",
      data["topic"] ?? "",
      data["forumRegion"] ?? "",
      data["forumCountry"] ?? "",
      data["forumTopic"] ?? "",
      if (data["hashtag"] != null) (data["hashtag"] as List).join(" "),
      if (data["hashtags"] != null) (data["hashtags"] as List).join(" "),
    ].join(" ").toLowerCase();

    return searchableText.contains(query);
  }

  final List<String> regions = [
    "Europa",
    "Asien",
    "Afrika",
    "Nordamerika",
    "Südamerika",
    "Zentralamerika",
    "Karibik",
    "Australien & Pazifik",
    "Naher Osten",
    "Polarregionen",
  ];

  final List<String> generalTopics = ["Allgemeine Reisethemen"];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A1A);

    final secondaryColor = isDarkMode ? Colors.white60 : Colors.black54;

    final primaryPurple = const Color(0xFF8C77FF);

    final cardColor = isDarkMode
        ? const Color(0xFF241E3A)
        : const Color(0xFFF3F0FF);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),

          children: [
            // -------------------------
            // SEARCH
            // -------------------------
            Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),

                    child: isSearching
                        ? Container(
                            key: const ValueKey("search"),

                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF171717)
                                  : const Color(0xFFF3F0FF),

                              borderRadius: BorderRadius.circular(16),

                              border: Border.all(
                                color: isDarkMode
                                    ? primaryPurple.withValues(alpha: 0.25)
                                    : primaryPurple.withValues(alpha: 0.18),
                              ),
                            ),

                            child: TextField(
                              controller: _searchController,

                              autofocus: true,

                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },

                              style: TextStyle(color: textColor),

                              decoration: InputDecoration(
                                hintText: "Reiseziel oder Thema suchen...",

                                hintStyle: TextStyle(color: secondaryColor),

                                prefixIcon: Icon(
                                  Icons.search,
                                  color: secondaryColor,
                                ),

                                border: InputBorder.none,

                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(key: ValueKey("empty")),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: Icon(
                    isSearching ? Icons.close : Icons.search,
                    color: textColor,
                    size: 30,
                  ),

                  onPressed: () {
                    setState(() {
                      if (isSearching) {
                        _searchController.clear();
                        searchQuery = "";
                        isSearching = false;
                      } else {
                        isSearching = true;
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            if (searchQuery.trim().isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height - 120,
                child: PostsSearchPage(initialQuery: searchQuery),
              )
            else ...[
              // -------------------------
              // GENERAL TRAVEL TOPICS
              // -------------------------
              Text(
                "Reiseforum",

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Tausche dich über Reisen aus, teile Erfahrungen und finde Tipps aus aller Welt.",

                style: TextStyle(fontSize: 15, color: secondaryColor),
              ),

              const SizedBox(height: 22),

              InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TopicsPage(isGeneral: true),
                    ),
                  );
                },

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    vertical: 28,
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    color: cardColor,

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(
                      color: isDarkMode
                          ? primaryPurple.withValues(alpha: 0.25)
                          : primaryPurple.withValues(alpha: 0.18),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Allgemeine Reisethemen",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.w700,

                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // -------------------------
              // REGION CARDS
              // -------------------------
              GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: regions.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 2.2,
                ),

                itemBuilder: (context, index) {
                  final region = regions[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(20),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RegionDestinationsPage(region: region),
                        ),
                      );
                    },

                    child: Container(
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: cardColor,

                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: isDarkMode
                              ? primaryPurple.withValues(alpha: 0.25)
                              : primaryPurple.withValues(alpha: 0.18),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Text(
                        region,

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,

                          color: textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
