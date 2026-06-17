class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.accessToken,
    required this.refreshToken,
  });

  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String accessToken;
  final String refreshToken;

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: _toInt(json['id']),
      username: (json['username'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }

  AuthenticatedUser copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthenticatedUser(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}
