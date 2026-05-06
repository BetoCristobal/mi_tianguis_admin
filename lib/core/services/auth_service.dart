import 'package:firebase_auth/firebase_auth.dart';
import 'package:mi_tianguis_admin/core/constants/app_config.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isAllowedUser =>
      currentUser != null &&
      currentUser!.email != null &&
      currentUser!.email!.toLowerCase() == AppConfig.allowedEmail;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final userEmail = credential.user?.email?.toLowerCase() ?? '';
    if (userEmail != AppConfig.allowedEmail) {
      await signOut();
      throw FirebaseAuthException(
        code: 'unauthorized-email',
        message: 'Esta cuenta no tiene permiso para usar el panel.',
      );
    }
  }

  Future<void> signOut() => _auth.signOut();
}
