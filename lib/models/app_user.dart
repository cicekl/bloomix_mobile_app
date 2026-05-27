class AppUser {
  final String id;
  final String fullName;
  final String email;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
    };
  }
}
