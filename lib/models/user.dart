class User {
  final String userId;
  final String email;
  final String? role;
  final String? name;

  User({
    required this.email,
    required this.userId,
    this.role,
    this.name,
  });

  static User fromJson(Map<String, dynamic> data) {
    return User(
      userId: data['userId'],
      email: data['email'],
      role: data['role'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'role': role,
      'name': name,
    };
  }
}
