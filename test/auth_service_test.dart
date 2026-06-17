import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:projeto_final/services/auth_service.dart';

void main() {
  test('login aceita admin/admin usando alias da DummyJSON', () async {
    late Map<String, dynamic> requestBody;
    final service = AuthService(
      client: MockClient((request) async {
        requestBody = jsonDecode(request.body) as Map<String, dynamic>;

        return http.Response(
          jsonEncode({
            'id': 1,
            'username': 'emilys',
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'email': 'emily.johnson@x.dummyjson.com',
            'image': 'https://dummyjson.com/icon/emilys/128',
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      }),
    );

    final user = await service.login(
      username: ' Admin ',
      password: ' admin ',
    );

    expect(requestBody['username'], 'emilys');
    expect(requestBody['password'], 'emilyspass');
    expect(user.username, 'admin');
    expect(user.fullName, 'Administrador');
    expect(user.accessToken, 'access-token');
  });
}
