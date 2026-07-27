import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dark_mode_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'posts_page.dart';

class TopicsPage extends ConsumerWidget {
  final String? region;
  final String? country;
  final bool isGeneral;

  const TopicsPage({
    super.key,
    this.region,
    this.country,
    this.isGeneral = false,
  });

  List<String> get topics {
    if (isGeneral) {
      return [
        "Reiseplanung",

        "Flüge & Airlines",

        "Budget & Sparen",

        "Unterkünfte",

        "Transport & Mobilität",

        "Apps & Technik",

        "Geld & Bezahlen",

        "Einreise & Visa",

        "Gesundheit & Versicherung",

        "Ausrüstung & Packlisten",

        "Reisesicherheit",

        "Reisestile",

        "Langzeitreisen & Auswandern",

        "Erfahrungen & Fragen",
      ];
    }

    return [
      "Sehenswürdigkeiten\n& Natur",

      "Erlebnisse &\nAktivitäten",

      "Essen & Trinken",

      "Unterkünfte",

      "Transport & Apps",

      "Einreise & Visa",

      "Kosten & Preise",

      "Beste Reisezeit & Wetter",

      "Sicherheit",

      "Kultur & Verhalten",

      "Geheimtipps & Orte",

      "Reisestile",

      "Erfahrungen & Reiseberichte",

      "Fragen & Hilfe",
    ];
  }

  String get pageTitle {
    if (isGeneral) {
      return "Allgemeine Reisethemen";
    }

    return country ?? "Themen";
  }

  String get subtitle {
    if (isGeneral) {
      return "Tipps, Wissen und Erfahrungen rund ums Reisen.";
    }

    return "$country entdecken und Erfahrungen teilen.";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

      appBar: AppBar(
        backgroundColor: backgroundColor,

        elevation: 0,

        centerTitle: true,

        iconTheme: IconThemeData(color: textColor),

        title: Text(
          "Reisethemen",

          style: GoogleFonts.pacifico(
            color: textColor,

            fontSize: 26,

            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),

        children: [
          Text(
            pageTitle,

            style: TextStyle(
              color: textColor,

              fontSize: 28,

              fontWeight: FontWeight.w700,

              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 6),

          Text(subtitle, style: TextStyle(color: secondaryColor, fontSize: 15)),

          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: topics.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: 14,

              mainAxisSpacing: 14,

              childAspectRatio: 2.2,
            ),

            itemBuilder: (context, index) {
              final topic = topics[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostsPage(
                        region: region ?? "",
                        country: country ?? "",
                        topic: topic,
                        isGeneral: isGeneral,
                      ),
                    ),
                  );
                },

                child: Container(
                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: cardColor,

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(
                      color: primaryPurple.withValues(alpha: 0.20),
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
                    topic,

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: textColor,

                      fontSize: 16,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
