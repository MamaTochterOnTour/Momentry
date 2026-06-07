import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/dark_mode_provider.dart';
import 'liveboard_upload_post_page.dart';
import 'liveboard_postcard_page.dart';

class MallorcaLiveboardPage extends ConsumerStatefulWidget {
  const MallorcaLiveboardPage({super.key});

  @override
  ConsumerState<MallorcaLiveboardPage> createState() =>
      _MallorcaLiveboardPageState();
}

class _MallorcaLiveboardPageState extends ConsumerState<MallorcaLiveboardPage> {
  final allowedCreators = ["8j5OQgROFyXxpTAj8RrVPga42RX2"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(darkModeProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return darkMode.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      data: (isDarkMode) {
        final bg = isDarkMode ? Colors.black : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: bg,

          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Liveboard",
              style: GoogleFonts.pacifico(color: textColor, fontSize: 22),
            ),

            actions: [
              if (allowedCreators.contains(uid))
                IconButton(
                  icon: Icon(Icons.add, color: textColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MallorcaUploadPostPage(isDarkMode: false),
                      ),
                    );
                  },
                ),
            ],
          ),

          // 👇 DAS FEHLT BEI DIR
          body: _liveboard(isDarkMode),
        );
      },
    );
  }

  /// 🌴 LIVEBOARD FEED
  Widget _liveboard(bool isDarkMode) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mallorca_liveboard')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Center(
            child: Text(
              "Es sind noch keine Beiträge im Mallorca Liveboard drin.",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return MallorcaPostCard(
              post: {...data, 'id': docs[index].id},
              isDarkMode: isDarkMode,
            );
          },
        );
      },
    );
  }
}
