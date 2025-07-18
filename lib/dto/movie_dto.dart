class MovieDTO {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;

  MovieDTO({required this.id, required this.title, required this.description, this.imageUrl});

  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    return MovieDTO(id: json['id'] as String, title: json['title'] as String, description: json['description'] as String, imageUrl: json['imageUrl'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'imageUrl': imageUrl}..removeWhere((key, value) => value == null);
  }
}
