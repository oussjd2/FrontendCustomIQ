class User {
  final String id;
  final String name;
  final String userId;
  final String? avatarUrl;
  final String email;
  final String password;
  List<String> modelUrls;  // List to store multiple model URLs

  User({
    required this.id,
    required this.name,
    required this.userId,
    this.avatarUrl,
    required this.email,
    this.password = '',
    this.modelUrls = const [],  // Default to an empty list
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      userId: json['user_id'] ?? '',
      avatarUrl: json['avatar_url'],
      email: json['email'] ?? '',
      password: '',
      modelUrls: json['modelUrls'] != null ? List<String>.from(json['modelUrls']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': this.id,
      'name': this.name,
      'user_id': this.userId,
      'email': this.email,
      'modelUrls': this.modelUrls,  // Add modelUrls to the serialized data
    };

    if (this.avatarUrl != null) {
      data['avatar_url'] = this.avatarUrl;
    }
    if (this.password.isNotEmpty) {
      data['password'] = this.password;
    }

    return data;
  }
}
