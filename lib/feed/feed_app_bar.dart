import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/s.dart';
import '../pages/follow_suggestions_page.dart';

class FeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final bool isSearching;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchToggle;
  final String title;

  const FeedAppBar({
    super.key,
    required this.isDarkMode,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchToggle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context)!;

    return AppBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,

      // LINKS: SEARCH
      leading: IconButton(
        icon: Icon(
          isSearching ? Icons.close : Icons.search,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: onSearchToggle,
      ),

      // MITTE: TITLE ODER SEARCH FIELD
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: strings.searchHint,
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Text(
              "Explore",
              style: GoogleFonts.pacifico(
                fontSize: 26,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.person_add_alt_1, // 👈 "Person + Icon"
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FollowSuggestionsPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
