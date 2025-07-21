import 'package:flutter/material.dart';
import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/helper/navigator_services.dart';
import 'package:case_project_app/screens/profilephoto_screen.dart';
import 'package:case_project_app/widget/bottombar_items.dart';
import 'package:case_project_app/widget/limitedoffer_bottombarsheet.dart';
import 'package:case_project_app/widget/resolve_image.dart';
import '../global/global_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  final List<MovieDTO> favoriteMovies;
  const ProfileScreen({super.key, required this.favoriteMovies});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _actionButton() {
    return ElevatedButton(onPressed: () => showLimitedOfferBottomSheet(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.local_offer, color: Colors.white), SizedBox(width: 8), Text('Sınırlı Teklif', style: TextStyle(fontSize: 14, color: Colors.white))]));
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: 'Profil Detayı', body: _buildBody(), bottomBarItems: bottomBarItems(context, widget, widget.favoriteMovies), isBackButtonVisible: true, isAppbarVisible: true, trailingButton: _actionButton());
  }

  Widget _buildBody() {
    final favs = widget.favoriteMovies;
    return Padding(
      padding: const EdgeInsets.all(16),
      child:
          favs.isEmpty
              ? Center(child: Text('Favori film bulunamadı.', style: TextStyle(color: Colors.white, fontSize: 16)))
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //*Profile Header
                    _profileHeader(),
                    const SizedBox(height: 24),
                    const Text('Beğendiğim Filmler', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    //*Movies List
                    _moviesGrid(favs),
                  ],
                ),
              ),
    );
  }

  Widget _profileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 36, backgroundImage: NetworkImage(loginDTO.photoUrl ?? 'https://via.placeholder.com/150')),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(loginDTO.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('ID: ${loginDTO.id}', style: const TextStyle(color: Colors.white54, fontSize: 14))])),
        ElevatedButton(
          onPressed: () {
            NavigationService.instance.navigatorKey.currentState!.push<bool>(MaterialPageRoute(builder: (_) => const ProfilephotoScreen())).then((shouldRefresh) {
              if (shouldRefresh == true) setState(() {});
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
          child: const Text('Fotoğraf Ekle', style: TextStyle(fontSize: 14, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _moviesGrid(List<MovieDTO> favs) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 16, mainAxisSpacing: 16),
      itemCount: favs.length,
      itemBuilder: (context, index) {
        final movie = favs[index];
        return FutureBuilder<String>(
          future: resolveBestImageUrl(movie),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final imageUrl = (snapshot.hasData && snapshot.data!.isNotEmpty) ? snapshot.data! : (movie.images.isNotEmpty ? movie.images.first : '');
            return Card(
              color: Colors.black.withValues(alpha: 0.3), // ← eski withOpacity(0.3) yerine
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(8)), child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity))), Padding(padding: const EdgeInsets.all(8.0), child: Text(movie.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))]),
            );
          },
        );
      },
    );
  }
}
