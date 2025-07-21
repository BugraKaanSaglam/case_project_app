import 'dart:io';
import 'package:dio/dio.dart';
import 'package:case_project_app/global/global_constants.dart';
import 'package:case_project_app/dto/login_dto.dart';
import 'package:case_project_app/dto/profile_dto.dart';
import 'package:case_project_app/dto/movie_dto.dart';

class ApiService {
  final Dio _dio;
  String? _token;

  ApiService({String? token}) : _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'})) {
    _token = token;
    _updateAuthHeader();
  }

  void _updateAuthHeader() {
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  // Login: authenticate user and store JWT
  Future<LoginDTO> login({required String email, required String password}) async {
    final response = await _dio.post('/user/login', data: {'email': email, 'password': password});
    final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final loginDTO = LoginDTO.fromJson(data);
    _token = loginDTO.token;
    _updateAuthHeader();
    return loginDTO;
  }

  // Get Profile: retrieve current user's profile information
  Future<ProfileDTO> getProfile() async {
    final response = await _dio.get('/user/profile');
    return ProfileDTO.fromJson(response.data as Map<String, dynamic>);
  }

  // Register: create a new user and receive JWT
  Future<LoginDTO> register({required String name, required String email, required String password}) async {
    final response = await _dio.post('/user/register', data: {'name': name, 'email': email, 'password': password});
    final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final loginDTO = LoginDTO.fromJson(data);
    _token = loginDTO.token;
    _updateAuthHeader();
    return loginDTO;
  }

  // Upload Photo: upload a profile picture and receive URL
  Future<String> uploadPhoto(File file) async {
    final fileName = file.uri.pathSegments.last;
    final formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: fileName)});

    final response = await _dio.post('/user/upload_photo', data: formData, options: Options(headers: {'Content-Type': 'multipart/form-data', if (_token != null) 'Authorization': 'Bearer $_token'}, validateStatus: (status) => status != null && status < 500));

    if (response.statusCode == 200) return (response.data as Map<String, dynamic>)['photoUrl'] as String;

    throw Exception('Upload failed (${response.statusCode}): ${response.data}');
  }

  // Toggle Favorite: add or remove a movie from favorites
  Future<void> toggleFavorite(String movieId) async {
    await _dio.post('/movie/favorite/$movieId');
  }

  // Get Favorite Movies: fetch list of user's favorite movies
  Future<List<MovieDTO>> getFavoriteMovies() async {
    final response = await _dio.get('/movie/favorites');
    final list = (response.data as Map<String, dynamic>)['data'] as List;
    return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Get Movie List: fetch list of all movies
  Future<List<MovieDTO>> fetchMoviePage({int page = 1}) async {
    final response = await _dio.get('/movie/list', queryParameters: {'page': page});
    if (response.statusCode != 200) {
      throw DioException(requestOptions: response.requestOptions, response: response, error: 'Sunucu $page. sayfayı döndürmedi (status ${response.statusCode})');
    }
    final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    final moviesJson = data['movies'] as List<dynamic>;
    return moviesJson.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
  }
}
