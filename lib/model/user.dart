class User {
  final int? user_id;
  final String user_name;
  final String user_email;
  final String user_password;
  final String? user_created_at;

  User({
    this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_password,
    required this.user_created_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password,
      'user_created_at': user_created_at,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id'],
      user_name: map['user_name'],
      user_email: map['user_email'],
      user_password: map['user_password'],
      user_created_at: map['user_created_at'],
    );
  }

}
