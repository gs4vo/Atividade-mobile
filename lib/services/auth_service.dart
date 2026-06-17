import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/authenticated_user.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://dummyjson.com/auth';
  final http.Client _client;

  Future<AuthenticatedUser> login({
    required String username,
    required String password,
  }) async {
    final normalizedUsername = username.trim();
    final normalizedPassword = password.trim();
    final useAdminAlias = normalizedUsername.toLowerCase() == 'admin' &&
        normalizedPassword == 'admin';
    final loginUsername = useAdminAlias ? 'emilys' : normalizedUsername;
    final loginPassword = useAdminAlias ? 'emilyspass' : normalizedPassword;

    final response = await _client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': loginUsername,
        'password': loginPassword,
        'expiresInMins': 30,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map<String, dynamic>
          ? (body['message'] ?? 'Usuario ou senha invalidos.').toString()
          : 'Usuario ou senha invalidos.';
      throw AuthException(message);
    }

    if (body is! Map<String, dynamic>) {
      throw const AuthException('Resposta inesperada no login.');
    }

    final user = AuthenticatedUser.fromJson(body);
    if (user.accessToken.isEmpty) {
      throw const AuthException('Login sem token de acesso.');
    }

    if (useAdminAlias) {
      return user.copyWith(
        username: 'admin',
        firstName: 'Administrador',
        lastName: '',
      );
    }

    return user;
  }
}
