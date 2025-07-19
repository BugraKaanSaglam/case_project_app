import 'package:http/http.dart' as http;
import '../dto/movie_dto.dart';

Future<String> resolveBestImageUrl(MovieDTO movie) async {
  final posterUrl = movie.poster;
  if (posterUrl.isNotEmpty) {
    try {
      final response = await http.head(Uri.parse(posterUrl));
      if (response.statusCode == 200) {
        return posterUrl;
      }
    } catch (_) {}
  }

  for (final url in movie.images) {
    if (url.isEmpty) continue;
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return url;
      }
    } catch (_) {}
  }

  return 'https://via.placeholder.com/300x450?text=No+Image';
}
