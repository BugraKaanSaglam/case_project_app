import 'package:case_project_app/widget/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../global/global_scaffold.dart';
import '../global/global_variables.dart';
import '../api/api_services.dart';
import '../dto/movie_dto.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ApiService _apiService;
  final PageController _pageController = PageController();

  List<MovieDTO> _displayedMovies = [];
  Set<String> _favoriteIds = {};

  int _currentPage = 0;
  final int _pageSize = 5;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(token: loginDTO.token);
    _initFavorites();
    _fetchMovies();
  }

  Future<void> _initFavorites() async {
    final favs = await _apiService.getFavoriteMovies();
    setState(() {
      _favoriteIds = favs.map((m) => m.id).toSet();
    });
  }

  Future<void> _fetchMovies() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final fetched = await _apiService.fetchMoviePage(page: _currentPage + 1);

    setState(() {
      _currentPage++;
      _displayedMovies.addAll(fetched);
      _hasMore = fetched.length == _pageSize;
      _isLoading = false;
    });
  }

  Future<void> _toggleFavorite(String movieId) async {
    await _apiService.toggleFavorite(movieId);
    setState(() {
      if (_favoriteIds.contains(movieId)) {
        _favoriteIds.remove(movieId);
      } else {
        _favoriteIds.add(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: '', body: _buildMovieFeed(), bottomBarItems: _bottomBarItems(context), isBackButtonVisible: false, isAppbarVisible: false);
  }

  List<Widget> _bottomBarItems(BuildContext context) {
    return [
      // Home button
      OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/home'), icon: FaIcon(FontAwesomeIcons.house, color: Colors.white), label: Text('Anasayfa', style: TextStyle(color: Colors.white)), style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white54), shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), backgroundColor: Colors.black.withOpacity(0.3))),

      // Profile button
      OutlinedButton.icon(onPressed: () => Navigator.pushNamed(context, '/profile'), icon: FaIcon(FontAwesomeIcons.user, color: Colors.white), label: Text('Profil', style: TextStyle(color: Colors.white)), style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white54), shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), backgroundColor: Colors.black.withOpacity(0.3))),
    ];
  }

  Widget _buildMovieFeed() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _displayedMovies.length + (_hasMore ? 1 : 0),
      onPageChanged: (index) {
        if (index >= _displayedMovies.length - 2 && !_isLoading && _hasMore) _fetchMovies();
      },
      itemBuilder: (context, index) {
        //* Spinner
        if (index == _displayedMovies.length) return const Center(child: CircularProgressIndicator());

        final movie = _displayedMovies[index];
        final isFav = _favoriteIds.contains(movie.id);
        final imageUrl = movie.images.isNotEmpty ? movie.images.first : null;

        return MovieCard(movie: movie, isFavorite: isFav, imageUrl: imageUrl, onToggleFavorite: () => _toggleFavorite(movie.id));
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
