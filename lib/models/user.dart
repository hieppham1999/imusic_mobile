class User {
  String name;
  String email;
  String role;
  String avatar;

  User({required this.name, required this.email, required this.role, required this.avatar});

  User.fromJson(Map<String, dynamic> json)
  : name = json['name'],
    email = json['email'],
    role = json['role'],
    avatar = json['avatar'];
}