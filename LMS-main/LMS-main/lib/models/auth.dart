class User {
  final String name;
  final String email;
  final int roleId;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.roleId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "role_id": roleId,
      "password": password,
    };
  }
}
