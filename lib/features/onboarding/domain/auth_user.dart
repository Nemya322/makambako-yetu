/// Represents a user account in Makambako Yetu.
class AuthUser {
  const AuthUser({
    required this.name,
    required this.phoneOrEmail,
    this.isGuest = false,
    this.ward = 'Makambako Mjini',
  });

  final String name;
  final String phoneOrEmail;
  final bool isGuest;
  final String ward;

  /// Default guest user profile.
  static const guest = AuthUser(
    name: 'Mgeni wa Makambako',
    phoneOrEmail: 'mgeni@makambako.tz',
    isGuest: true,
    ward: 'Mwembetogwa',
  );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneOrEmail': phoneOrEmail,
        'isGuest': isGuest,
        'ward': ward,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        name: json['name'] as String? ?? 'Mwanajamii wa Makambako',
        phoneOrEmail: json['phoneOrEmail'] as String? ?? '+255 700 000 000',
        isGuest: json['isGuest'] as bool? ?? false,
        ward: json['ward'] as String? ?? 'Makambako Mjini',
      );
}
