import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SearchMode { feed, qa }

class MySearchDelegate extends SearchDelegate<String> {
  final String initialQuery;
  final SearchMode mode;

  MySearchDelegate({required this.mode, required this.initialQuery}) {
    query = initialQuery;
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
    if (mode == SearchMode.qa) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Questions')
            .orderBy('question')
            .startAt([query])
            .endAt([query + '\uf8ff'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['question'] ?? ''),
                subtitle: Text(data['username'] ?? ''),
              );
            },
          );
        },
      );
    }

    // DEFAULT = FEED SUCHE (später erweitern)
    return Center(child: Text('Feed Suche: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Tippe um zu suchen...'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: mode == SearchMode.qa
          ? FirebaseFirestore.instance
                .collection('Questions')
                .orderBy('question')
                .startAt([query])
                .endAt([query + '\uf8ff'])
                .snapshots()
          : FirebaseFirestore.instance
                .collection('Posts') // falls du Feed hast
                .orderBy('text')
                .startAt([query])
                .endAt([query + '\uf8ff'])
                .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final docs = snapshot.data!.docs;

        return ListView(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return ListTile(
              title: Text(
                mode == SearchMode.qa
                    ? data['question'] ?? ''
                    : data['text'] ?? '',
              ),
              onTap: () {
                query = mode == SearchMode.qa ? data['question'] : data['text'];

                showResults(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
