import 'package:case_project_app/widget/bottombar_items.dart';
import 'package:case_project_app/widget/movie_card.dart';
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

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(token: loginDTO.token);
    _fetchMovies();
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
    setState(() async {
      await _apiService.toggleFavorite(movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return globalScaffold(title: '', body: _buildMovieFeed(), bottomBarItems: bottomBarItems(context, widget), isBackButtonVisible: false, isAppbarVisible: false);
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
        final isFav = movie.isFavorite;
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
