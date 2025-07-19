import 'package:case_project_app/widget/bottombar_items.dart';
import 'package:case_project_app/widget/movie_card.dart';
import 'package:case_project_app/widget/resolve_image.dart';
import 'package:flutter/material.dart';
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
  final List<MovieDTO> _displayedMovies = [];
  int _currentPage = 0;
  final int _pageSize = 5;
  bool _isLoading = false;
  bool _hasMore = true;
  List<MovieDTO> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(token: loginDTO.token);
    _initData();
  }

  Future<void> _initData() async {
    await _fetchMovies();
    await _refreshFavorites();
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

  Future<void> _refreshFavorites() async {
    _favoriteMovies = await _apiService.getFavoriteMovies();
    final favIds = _favoriteMovies.map((m) => m.id).toSet();
    setState(() {
      for (var m in _displayedMovies) {
        m.isFavorite = favIds.contains(m.id);
      }
    });
  }

  Future<void> _toggleFavorite(String movieId) async {
    await _apiService.toggleFavorite(movieId);
    await _refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: '', body: mainBody(), bottomBarItems: bottomBarItems(context, widget, _favoriteMovies), isBackButtonVisible: false, isAppbarVisible: false);
  }

  Widget mainBody() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _displayedMovies.length + (_hasMore ? 1 : 0),
      onPageChanged: (index) {
        if (index >= _displayedMovies.length - 2 && !_isLoading && _hasMore) {
          _fetchMovies();
        }
      },
      itemBuilder: (context, index) {
        if (index == _displayedMovies.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = _displayedMovies[index];
        final isFav = movie.isFavorite;

        return FutureBuilder<String>(
          future: resolveBestImageUrl(movie),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final imageUrl = (snapshot.hasData && snapshot.data!.isNotEmpty) ? snapshot.data! : (movie.images.isNotEmpty ? movie.images.first : '');
            return MovieCard(movie: movie, isFavorite: isFav, imageUrl: imageUrl, onToggleFavorite: () => _toggleFavorite(movie.id));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
