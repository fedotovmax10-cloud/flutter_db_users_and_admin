class User {
  final int? id;
  final String login;
  final String password;
  final String email;
  final DateTime birthday;
  final String phoneNumber;
  final String? description;
  final bool isAdmin;

  User({
    this.id,
    required this.login,
    required this.password,
    required this.email,
    required this.birthday,
    required this.phoneNumber,
    this.description,
    this.isAdmin = false,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      login: map['login'] as String,
      password: map['password'] as String,
      email: map['email'] as String,
      birthday: DateTime.parse(map['birthday'] as String),
      phoneNumber: map['phone_number'] as String,
      description: map['description'] as String?,
      isAdmin: (map['isAdmin'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'login': login,
      'password': password,
      'email': email,
      'birthday': birthday.toIso8601String().split('T')[0],
      'phone_number': phoneNumber,
      'description': description,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }
}
