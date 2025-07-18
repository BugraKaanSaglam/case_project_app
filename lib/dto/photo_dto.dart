class PhotoDTO {
  final String photoUrl;

  PhotoDTO({required this.photoUrl});

  factory PhotoDTO.fromJson(Map<String, dynamic> json) {
    return PhotoDTO(photoUrl: json['photoUrl'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'photoUrl': photoUrl};
  }
}
