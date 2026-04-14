import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
              decoration: const InputDecoration(
                hintText: "Suche...",
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Text(
              title,
              style: GoogleFonts.pacifico(
                fontSize: 26,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

      // RECHTS: HERZ
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            // später Activity Feed
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
