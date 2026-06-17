import 'package:flutter/foundation.dart';

import '../models/authenticated_user.dart';
import '../services/auth_service.dart';

class SessionProvider extends ChangeNotifier {
  SessionProvider({
    AuthService? service,
    AuthenticatedUser? initialUser,
  })  : _service = service ?? AuthService(),
        _user = initialUser;

  final AuthService _service;

  AuthenticatedUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthenticatedUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _service.login(
        username: username.trim(),
        password: password,
      );
      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'Nao foi possivel entrar. Tente novamente.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }
}
