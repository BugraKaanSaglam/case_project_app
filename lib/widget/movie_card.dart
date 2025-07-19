import 'package:case_project_app/dto/movie_dto.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final MovieDTO movie;
  final bool isFavorite;
  final String? imageUrl;
  final VoidCallback onToggleFavorite;

  const MovieCard({super.key, required this.movie, required this.isFavorite, required this.imageUrl, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [_buildBackgroundImage(), _buildGradientOverlay(), _buildMovieDetails(), _buildSideActionButtons()]);
  }

  Widget _buildBackgroundImage() {
    return imageUrl != null
        ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error, color: Colors.white));
          },
        )
        : Container(color: Colors.black);
  }

  Widget _buildGradientOverlay() {
    return Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black38], stops: const [0.5, 1.0])));
  }

  Widget _buildMovieDetails() {
    return Positioned(
      bottom: 80,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10.0, color: Colors.black)])),
          const SizedBox(height: 8),
          Text(movie.plot, maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 16, shadows: [Shadow(blurRadius: 8.0, color: Colors.black)])),
        ],
      ),
    );
  }

  Widget _buildSideActionButtons() {
    return Positioned(bottom: 200, right: 16, child: Column(children: [IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white, size: 35), onPressed: onToggleFavorite)]));
  }
}
