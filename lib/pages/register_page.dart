import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/auth_service.dart';
import '../pages/main_navigation.dart';
import 'login_page.dart';
import 'package:flutter/gestures.dart';
import '../einstellungen/privacy_policy_page.dart';
import '../einstellungen/terms_conditions_page.dart';
import 'dart:developer';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'username_setup_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();
  final _firestore = FirebaseFirestore.instance;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  bool _agreedToTerms = false;
  String? _errorMessage;

  void _showErrorMessage(String message) {
    setState(() => _errorMessage = message);
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _errorMessage = null);
    });
  }

  Future<void> _saveFCMToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('Users').doc(uid).update({
          'fcmToken': token,
        });
      }
    } catch (e) {
      log("Fehler beim Speichern des FCM-Tokens: $e");
    }
  }

  Future<void> _registerUser({
    required String uid,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String displayName,
    bool isPremium = false,
  }) async {
    await _firestore.collection('Users').doc(uid).set({
      'firstname': firstName,
      'lastname': lastName,
      'username': username,
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'isPremium': isPremium,
    });

    await _saveFCMToken(uid);
  }

  Future<void> _registerWithEmail() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if ([
      firstName,
      lastName,
      username,
      email,
      password,
      confirmPassword,
    ].any((e) => e.isEmpty)) {
      _showErrorMessage("Bitte fülle alle Felder aus.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorMessage("Passwort und Wiederholung stimmen nicht überein.");
      return;
    }

    if (!_agreedToTerms) {
      _showErrorMessage(
        "Bitte stimme den Nutzungsbedingungen und der Datenschutzerklärung zu.",
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Username prüfen
      final usernameQuery = await _firestore
          .collection('Users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        if (!mounted) return;
        _showErrorMessage(
          "Username ist schon vergeben. Bitte wähle einen anderen.",
        );
        setState(() => _isLoading = false);
        return;
      }

      final user = await _authService.registerWithEmail(
        email,
        password,
        "$firstName $lastName",
      );

      if (user != null) {
        await _registerUser(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          displayName: user.displayName ?? "$firstName $lastName",
        );

        await Purchases.logIn(user.uid);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationPage()),
        );
      } else {
        if (!mounted) return;
        _showErrorMessage(
          "Firebase-Authentifizierung konnte nicht abgeschlossen werden.",
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'email-already-in-use') {
        _showErrorMessage(
          "Die E-Mail-Adresse wird bereits genutzt. Bitte wähle eine andere.",
        );
      } else if (e.code == 'invalid-email') {
        _showErrorMessage("Bitte gib eine gültige E-Mail-Adresse ein.");
      } else {
        _showErrorMessage("Fehler: ${e.message}");
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage("Fehler: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _registerWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        final doc = _firestore.collection('Users').doc(user.uid);
        final snapshot = await doc.get();

        final nameParts = user.displayName?.split(' ') ?? ["", ""];
        final firstName = nameParts.first;
        final lastName = nameParts.length > 1
            ? nameParts.skip(1).join(' ')
            : "";

        // Wenn Dokument noch nicht existiert: komplett neu anlegen
        if (!snapshot.exists) {
          await _registerUser(
            uid: user.uid,
            firstName: firstName,
            lastName: lastName,
            username: "",
            email: user.email ?? "",
            displayName: user.displayName ?? "$firstName $lastName",
          );
        } else {
          // Dokument existiert schon -> Daten ergänzen (wenn fehlen)
          await doc.set({
            'firstname': firstName,
            'lastname': lastName,
            'username': user.displayName ?? firstName,
            'email': user.email ?? "",
            'displayName': user.displayName ?? "$firstName $lastName",
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // FCM Token aktualisieren
          await _saveFCMToken(user.uid);
        }

        // RevenueCat Login
        await Purchases.logIn(user.uid);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UsernameSetupPage(uid: user.uid)),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage("Fehler bei Google-Login: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _registerWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.signInWithApple();

      if (user != null) {
        final doc = _firestore.collection('Users').doc(user.uid);
        final snapshot = await doc.get();

        final nameParts = user.displayName?.split(' ') ?? ["", ""];
        final firstName = nameParts.first;
        final lastName = nameParts.length > 1
            ? nameParts.skip(1).join(' ')
            : "";

        if (!snapshot.exists) {
          await _registerUser(
            uid: user.uid,
            firstName: firstName,
            lastName: lastName,
            username: "",
            email: user.email ?? "",
            displayName: user.displayName ?? "$firstName $lastName",
          );
        } else {
          await doc.set({
            'firstname': firstName,
            'lastname': lastName,
            'username': user.displayName ?? firstName,
            'email': user.email ?? "",
            'displayName': user.displayName ?? "$firstName $lastName",
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          await _saveFCMToken(user.uid);
        }

        await Purchases.logIn(user.uid);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UsernameSetupPage(uid: user.uid)),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage("Fehler bei Apple-Login: ${e.toString()}");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account erstellen"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: "Vorname"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: "Nachname"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "E-Mail"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Passwort",
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
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: "Passwort wiederholen",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) =>
                          setState(() => _agreedToTerms = value ?? false),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "Ich stimme den ",
                          children: [
                            TextSpan(
                              text: "Nutzungsbedingungen",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsConditionsPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: " und der "),
                            TextSpan(
                              text: "Datenschutzerklärung",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PrivacyPolicyPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: " zu."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerWithEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Konto erstellen"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Oder fortfahren mit"),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _registerWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.g_mobiledata, size: 24),
                        SizedBox(width: 10),
                        Text("Google"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (Theme.of(context).platform == TargetPlatform.iOS)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _registerWithApple,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.apple, size: 24),
                          SizedBox(width: 10),
                          Text("Apple"),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Du hast schon ein Konto? Hier geht's zum Login",
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
