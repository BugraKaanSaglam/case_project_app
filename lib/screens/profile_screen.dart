// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/screens/profilephoto_screen.dart';
import 'package:case_project_app/widget/bottombar_items.dart';
import 'package:case_project_app/widget/resolve_image.dart';
import 'package:flutter/material.dart';
import '../global/global_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.favoriteMovies});
  List<MovieDTO> favoriteMovies = [];

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: 'Profil Detayı', body: profileBody(), bottomBarItems: bottomBarItems(context, widget, widget.favoriteMovies), isBackButtonVisible: true, isAppbarVisible: true);
  }

  Widget profileBody() {
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
            Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ProfilephotoScreen())).then((shouldRefresh) {
              if (shouldRefresh == true) setState(() {});
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          child: const Text('Fotoğraf Ekle', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ],
    );
  }

  Widget favoriteMoviesGrid() {
    if (widget.favoriteMovies.isEmpty) return Center(child: Text('Favori film bulunamadı.', style: TextStyle(color: Colors.white)));

    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: widget.favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = widget.favoriteMovies[index];
        return FutureBuilder<String>(
          future: resolveBestImageUrl(movie),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

            final imageUrl = (snapshot.hasData && snapshot.data!.isNotEmpty) ? snapshot.data! : (movie.images.isNotEmpty ? movie.images.first : '');
            return Card(color: Colors.black.withOpacity(0.3), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Image.network(imageUrl, fit: BoxFit.cover)), Padding(padding: EdgeInsets.all(8.0), child: Text(movie.title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))]));
          },
        );
      },
    );
  }
}
