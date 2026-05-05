import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mi_tianguis_admin/core/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    AuthService? authService,
  }) : _authService = authService ?? AuthService.instance;

  final AuthService _authService;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _mapFirebaseError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo iniciar sesión.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapFirebaseError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta de nuevo más tarde.';
      case 'unauthorized-email':
        return error.message ?? 'Esta cuenta no tiene permiso para entrar.';
      default:
        return error.message ?? 'No se pudo iniciar sesión.';
    }
  }
}
