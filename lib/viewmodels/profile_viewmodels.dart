import 'package:flutter/material.dart';
import 'package:case_project_app/api/api_services.dart';
import 'package:case_project_app/dto/movie_dto.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService.instance;

  List<MovieDTO> favoriteMovies = [];
  bool isLoading = false;

  /// Initial data load
  Future<void> initData(BuildContext context) async {
    await fetchFavorites(context);
  }

  /// Fetch favorite movies
  Future<void> fetchFavorites(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    favoriteMovies = await _apiService.getFavoriteMovies(context: context) ?? [];

    isLoading = false;
    notifyListeners();
  }
}
