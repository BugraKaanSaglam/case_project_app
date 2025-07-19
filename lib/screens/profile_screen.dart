// ignore_for_file: deprecated_member_use

import 'package:case_project_app/api/api_services.dart';
import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/widget/bottombar_items.dart';
import 'package:flutter/material.dart';
import '../global/global_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  List<MovieDTO> _favoriteMovies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final movies = await _apiService.getFavoriteMovies();
      setState(() {
        _favoriteMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: 'Profil Detayı', body: profileBody(), bottomBarItems: bottomBarItems(context, widget));
  }

  Widget profileBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            profileRow(),

            const SizedBox(height: 24),
            const Text('Beğendiğim Filmler', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            //Favorite Movies Grid
            favoriteMoviesGrid(),
          ],
        ),
      ),
    );
  }

  Widget profileRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 36, backgroundImage: NetworkImage(loginDTO.photoUrl ?? 'https://via.placeholder.com/150')),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(loginDTO.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('ID: ${loginDTO.id}', style: const TextStyle(color: Colors.white54, fontSize: 14))])),
        ElevatedButton(
          onPressed: () {
            //* Photo Add Area
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          child: const Text('Fotoğraf Ekle', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ],
    );
  }

  Widget favoriteMoviesGrid() {
    if (_favoriteMovies.isEmpty) {
      return const Center(child: Text('Favori film bulunamadı.', style: TextStyle(color: Colors.white)));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: _favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = _favoriteMovies[index];
        return Card(color: Colors.black.withOpacity(0.3), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Image.network(movie.images.first, fit: BoxFit.cover)), Padding(padding: const EdgeInsets.all(8.0), child: Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))]));
      },
    );
  }
}
