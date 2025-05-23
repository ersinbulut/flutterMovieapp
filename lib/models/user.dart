class User {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final String? fullName;
  final String? phoneNumber;
  final String? bio;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.fullName,
    this.phoneNumber,
    this.bio,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bio': bio,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImage,
    String? fullName,
    String? phoneNumber,
    String? bio,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
    );
  }
} 