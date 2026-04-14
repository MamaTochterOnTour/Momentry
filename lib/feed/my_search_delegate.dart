import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final String initialQuery;

  MySearchDelegate({required this.initialQuery}) {
    query = initialQuery; // Startwert setzen
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Suche abbrechen
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Hier gibst du das Ergebnis zurück
    // z.B. einfach den String
    return Center(child: Text('Suchergebnis für "$query"'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Vorschläge während der Eingabe
    final suggestions = query.isEmpty
        ? []
        : ['Beispiel 1', 'Beispiel 2', 'Beispiel 3']
              .where((s) => s.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
