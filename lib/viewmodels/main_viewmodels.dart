// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../api/api_services.dart';
import '../dto/movie_dto.dart';

class MainViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  List<MovieDTO> displayedMovies = [];
  List<MovieDTO> favoriteMovies = [];

  int _currentPage = 0;
  final int pageSize = 5;

  bool isLoading = false;
  bool hasMore = true;

  MainViewModel();

  Future<void> initData(BuildContext context) async {
    await fetchMovies(context);
    await refreshFavorites(context);
  }

  Future<void> fetchMovies(BuildContext context) async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    final fetched = await _apiService.fetchMoviePage(context: context, page: _currentPage + 1);

    if (fetched != null) {
      _currentPage++;
      displayedMovies.addAll(fetched);
      hasMore = fetched.length == pageSize;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshFavorites(BuildContext context) async {
    favoriteMovies = await _apiService.getFavoriteMovies(context: context) ?? [];

    final favIds = favoriteMovies.map((m) => m.id).toSet();
    for (var m in displayedMovies) {
      m.isFavorite = favIds.contains(m.id);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context, String movieId) async {
    await _apiService.toggleFavorite(context: context, movieId);
    await refreshFavorites(context);
  }
}
