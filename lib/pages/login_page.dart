import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Für Google & Apple Icons
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';
import 'package:reisetagebuch/pages/main_navigation.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final logger = Logger();

  bool _isLoading = false;
  String? _errorMessage;

  bool _obscurePassword = true;

  Future<void> _saveFCMToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          await FirebaseFirestore.instance.collection('Users').doc(uid).update({
            'fcmToken': token,
          });
        }
      }
    } catch (e, st) {
      logger.e(
        "Fehler beim Speichern des FCM-Tokens",
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _loginWithEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'User ist null nach Login',
        );
      }

      await _saveFCMToken(user.uid);
      await Purchases.logIn(user.uid);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    } on FirebaseAuthException catch (e) {
      // 🔥 DAS ist das Entscheidende
      debugPrint("🔥 LOGIN ERROR CODE: ${e.code}");
      debugPrint("🔥 LOGIN ERROR MESSAGE: ${e.message}");

      setState(() {
        _errorMessage = "Firebase Fehler: ${e.code}";
      });
    } catch (e) {
      debugPrint("🔥 UNBEKANNTER LOGIN FEHLER: $e");
      setState(() {
        _errorMessage = "Unbekannter Fehler: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        final doc = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid);
        final snapshot = await doc.get();

        // Wenn kein Dokument existiert, anlegen
        if (!snapshot.exists) {
          await doc.set({
            'email': user.email ?? "",
            'displayName': user.displayName ?? "",
            'createdAt': FieldValue.serverTimestamp(),
            'isPremium': false,
            'language': "de",
          });
        }

        await _saveFCMToken(user.uid);
        await Purchases.logIn(user.uid);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Google Login fehlgeschlagen.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithApple();

      if (user != null) {
        final doc = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid);
        final snapshot = await doc.get();

        // Wenn kein Dokument existiert, anlegen
        if (!snapshot.exists) {
          await doc.set({
            'email': user.email ?? "",
            'displayName': user.displayName ?? "",
            'createdAt': FieldValue.serverTimestamp(),
            'isPremium': false,
            'language': "de",
          });
        }

        await _saveFCMToken(user.uid);
        await Purchases.logIn(user.uid);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = 'Apple Login fehlgeschlagen.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Willkommen bei Momentry",
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(fontSize: 32, color: labelColor),
              ),
              const SizedBox(height: 32),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextField(
                controller: _emailController,
                style: TextStyle(color: labelColor),
                decoration: InputDecoration(
                  labelText: "E-Mail",
                  labelStyle: TextStyle(color: labelColor),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: labelColor),
                decoration: InputDecoration(
                  labelText: "Passwort",
                  labelStyle: TextStyle(color: labelColor),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithEmail,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Einloggen"),
                ),
              ),
              const SizedBox(height: 32),
              Text("Oder fortfahren mit", style: TextStyle(color: labelColor)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _loginWithGoogle,
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  label: const Text("Mit Google einloggen"),
                ),
              ),
              const SizedBox(height: 12),
              if (Theme.of(context).platform == TargetPlatform.iOS)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _loginWithApple,
                    icon: const FaIcon(
                      FontAwesomeIcons.apple,
                      color: Colors.black,
                    ),
                    label: const Text("Mit Apple einloggen"),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Du hast noch kein Konto? ",
                    style: TextStyle(color: labelColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text("Hier Konto erstellen"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
