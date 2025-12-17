class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime registrationDate;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.registrationDate,
  });

  // Factory constructor to create a User from a JSON map (e.g., API response)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
    );
  }
}