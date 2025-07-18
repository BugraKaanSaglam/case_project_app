class LoginDTO {
  final String token;
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  LoginDTO({required this.token, required this.id, required this.name, required this.email, this.photoUrl});

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(token: json['token'] as String, id: json['id'] as String, name: json['name'] as String, email: json['email'] as String, photoUrl: json['photoUrl'] as String?);
  }
}
