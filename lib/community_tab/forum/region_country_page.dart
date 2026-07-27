import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dark_mode_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../profil_tab/settings_contact_feedback_page.dart';
import 'topics_page.dart';

class RegionDestinationsPage extends ConsumerWidget {
  final String region;

  const RegionDestinationsPage({super.key, required this.region});

  Map<String, List<String>> get countriesByRegion => {
    "Europa": [
      "Deutschland",
      "Spanien",
      "Italien",
      "Frankreich",
      "Portugal",
      "Griechenland",
      "Österreich",
      "Schweiz",
      "Niederlande",
      "Belgien",
      "Luxemburg",
      "Dänemark",
      "Schweden",
      "Norwegen",
      "Finnland",
      "Island",
      "Irland",
      "Großbritannien",
      "Polen",
      "Tschechien",
      "Slowakei",
      "Ungarn",
      "Slowenien",
      "Kroatien",
      "Montenegro",
      "Albanien",
      "Bosnien und Herzegowina",
      "Serbien",
      "Bulgarien",
      "Rumänien",
      "Estland",
      "Lettland",
      "Litauen",
      "Malta",
      "Zypern",
      "Türkei",
    ],

    "Asien": [
      "Japan",
      "China",
      "Südkorea",
      "Taiwan",
      "Thailand",
      "Vietnam",
      "Kambodscha",
      "Laos",
      "Myanmar",
      "Indonesien",
      "Malaysia",
      "Singapur",
      "Philippinen",
      "Brunei",
      "Indien",
      "Sri Lanka",
      "Nepal",
      "Bhutan",
      "Bangladesch",
      "Malediven",
      "Mongolei",
      "Kasachstan",
      "Usbekistan",
      "Kirgisistan",
      "Georgien",
      "Armenien",
      "Aserbaidschan",
    ],

    "Afrika": [
      "Südafrika",
      "Namibia",
      "Botswana",
      "Simbabwe",
      "Sambia",
      "Mosambik",
      "Tansania",
      "Kenia",
      "Uganda",
      "Ruanda",
      "Äthiopien",
      "Ghana",
      "Senegal",
      "Marokko",
      "Tunesien",
      "Ägypten",
      "Madagaskar",
      "Mauritius",
      "Seychellen",
      "Kap Verde",
    ],

    "Nordamerika": ["USA", "Kanada", "Mexiko"],

    "Zentralamerika": [
      "Costa Rica",
      "Panama",
      "Guatemala",
      "Belize",
      "Honduras",
      "Nicaragua",
      "El Salvador",
    ],

    "Karibik": [
      "Dominikanische Republik",
      "Kuba",
      "Jamaika",
      "Bahamas",
      "Barbados",
      "Aruba",
      "Curaçao",
      "Puerto Rico",
      "Trinidad und Tobago",
      "St. Lucia",
      "Grenada",
      "Antigua und Barbuda",
      "Dominica",
    ],

    "Südamerika": [
      "Brasilien",
      "Argentinien",
      "Chile",
      "Peru",
      "Kolumbien",
      "Bolivien",
      "Ecuador",
      "Uruguay",
      "Paraguay",
      "Venezuela",
      "Guyana",
      "Suriname",
    ],

    "Australien & Pazifik": [
      "Australien",
      "Neuseeland",
      "Fidschi",
      "Samoa",
      "Tonga",
      "Vanuatu",
      "Französisch-Polynesien",
      "Cookinseln",
      "Palau",
      "Neukaledonien",
      "Papua-Neuguinea",
      "Salomonen",
    ],

    "Naher Osten": [
      "Vereinigte Arabische Emirate",
      "Saudi-Arabien",
      "Oman",
      "Katar",
      "Jordanien",
      "Israel",
      "Bahrain",
      "Kuwait",
      "Libanon",
    ],

    "Polarregionen": ["Antarktis", "Grönland", "Spitzbergen"],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A1A);

    final secondaryColor = isDarkMode ? Colors.white60 : Colors.black54;

    final primaryPurple = const Color(0xFF8C77FF);

    final destinations = countriesByRegion[region] ?? [];

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
          region,

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
            "Reiseziele entdecken",

            style: TextStyle(
              color: textColor,

              fontSize: 28,

              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Wähle ein Land aus und entdecke Orte, Erfahrungen und Reisetipps.",

            style: TextStyle(color: secondaryColor, fontSize: 15),
          ),

          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: destinations.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: 14,

              mainAxisSpacing: 14,

              childAspectRatio: 2.2,
            ),

            itemBuilder: (context, index) {
              final destination = destinations[index];

              return InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          TopicsPage(region: region, country: destination),
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
                  ),

                  child: Text(
                    destination,

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

          const SizedBox(height: 24),

          InkWell(
            borderRadius: BorderRadius.circular(20),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactFeedbackPage()),
              );
            },

            child: Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: cardColor,

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: primaryPurple.withValues(alpha: 0.20),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Fehlt ein Land oder eine Region?",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Du findest dein Reiseziel nicht? Tippe hier und teile uns mit, welches Land oder welche Region ergänzt werden soll.",
                    style: TextStyle(color: secondaryColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
