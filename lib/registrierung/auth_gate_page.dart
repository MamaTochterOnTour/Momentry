import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../registrierung/login_page.dart';
import '../registrierung/username_setup_page.dart';
import '../erstellen_tab/main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Firebase lädt noch
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kein Benutzer eingeloggt
        if (!authSnapshot.hasData) {
          return const LoginPage();
        }

        final user = authSnapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get(const GetOptions(source: Source.server)),
          builder: (context, userSnapshot) {
            // Firestore lädt
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Dokument existiert nicht
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return UsernameSetupPage(uid: user.uid);
            }

            final data =
                userSnapshot.data!.data() as Map<String, dynamic>? ??
                <String, dynamic>{};

            final username = (data['username'] ?? '').toString().trim();

            if (username.isEmpty) {
              return UsernameSetupPage(uid: user.uid);
            }

            return const MainNavigationPage();
          },
        );
      },
    );
  }
}
