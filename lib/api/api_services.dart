import 'dart:io';
import 'package:dio/dio.dart';
import 'package:case_project_app/global/global_constants.dart';
import 'package:case_project_app/dto/login_dto.dart';
import 'package:case_project_app/dto/profile_dto.dart';
import 'package:case_project_app/dto/photo_dto.dart';
import 'package:case_project_app/dto/movie_dto.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));

  // Login: authenticate user and receive JWT token
  Future<LoginDTO> login({required String email, required String password}) async {
    final resp = await _dio.post('/user/login', data: {'email': email, 'password': password});
    final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return LoginDTO.fromJson(data);
  }

  // Get Profile: retrieve current user's profile information
  Future<ProfileDTO> getProfile() async {
    final resp = await _dio.get('/user/profile');
    // data comes as root JSON
    return ProfileDTO.fromJson(resp.data as Map<String, dynamic>);
  }

  // Register: create a new user and receive JWT token
  Future<LoginDTO> register({required String email, required String name, required String password}) async {
    final resp = await _dio.post('/user/register', data: {'email': email, 'name': name, 'password': password});
    final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return LoginDTO.fromJson(data);
  }

  // Upload Photo: upload a profile picture and receive URL
  Future<PhotoDTO> uploadPhoto(File file) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last)});
    final resp = await _dio.post('/user/upload_photo', data: form);
    return PhotoDTO.fromJson(resp.data as Map<String, dynamic>);
  }

  // Toggle Favorite: add or remove a movie from favorites
  Future<void> toggleFavorite(String movieId) async {
    await _dio.post('/movie/favorite/$movieId');
  }

  // Get Favorite Movies: fetch list of user's favorite movies
  Future<List<MovieDTO>> getFavoriteMovies() async {
    final resp = await _dio.get('/movie/favorites');
    final list = resp.data as List;
    return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Get Movie List: fetch list of all movies
  Future<List<MovieDTO>> getMovieList() async {
    final resp = await _dio.get('/movie/list');
    final list = resp.data as List;
    return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
  }
}
