import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // Registrierung per E-Mail
  Future<User?> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login per Email
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.reload();
    return credential.user;
  }

  // Google Login – stabile Version
  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await userCredential.user?.reload();

      return _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  // Apple Login
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);

      // DisplayName setzen, falls verfügbar
      if (appleCredential.givenName != null) {
        await userCredential.user?.updateDisplayName(
          "${appleCredential.givenName} ${appleCredential.familyName}",
        );
      }

      await userCredential.user?.reload();
      return _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
