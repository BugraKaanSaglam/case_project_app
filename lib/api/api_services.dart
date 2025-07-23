// lib/api/api_service.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:case_project_app/global/global_variables.dart';
import 'package:case_project_app/helper/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:case_project_app/global/global_constants.dart';
import 'package:case_project_app/helper/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:case_project_app/dto/login_dto.dart';
import 'package:case_project_app/dto/profile_dto.dart';
import 'package:case_project_app/dto/movie_dto.dart';
import 'package:case_project_app/helper/token_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Centralized service for handling all API requests.
class ApiService {
  /// Private constructor for singleton pattern.
  ApiService._internal() : _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'})) {
    // Attach Dio interceptor for HTTP logs
    _dio.interceptors.add(LogInterceptor(request: true, requestHeader: true, requestBody: true, responseHeader: false, responseBody: true, error: true));
  }

  /// Singleton instance of ApiService.
  static final ApiService instance = ApiService._internal();

  final Dio _dio;
  final TokenStorageService _tokenStore = TokenStorageService();

  /// Logs in the user with [email] and [password], saves token, and sets auth header.
  Future<void> login({required BuildContext context, required String email, required String password}) async {
    LoggerService().i('Attempting login for: $email');
    try {
      final resp = await _dio.post('/user/login', data: {'email': email, 'password': password});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);

      // Store the JWT token locally
      await _tokenStore.saveToken(loginDTO.token!);
      // Set the Authorization header for future requests
      _dio.options.headers['Authorization'] = 'Bearer ${loginDTO.token}';

      LoggerService().i('Login successful, token stored');
    } catch (e, st) {
      LoggerService().e('Login error: $e', e as Exception, st);
      // Show localized error dialog and rethrow
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      rethrow;
    }
  }

  /// Logs out the current user by deleting stored token and clearing header.
  Future<void> logout() async {
    LoggerService().i('Logging out user');
    await _tokenStore.deleteToken();
    loginDTO.token = null;
    _dio.options.headers.remove('Authorization');
    LoggerService().i('Logout complete, token cleared');
  }

  /// Registers a new user with [name], [email], and [password], then saves token.
  Future<void> register({required BuildContext context, required String name, required String email, required String password}) async {
    LoggerService().i('Attempting registration for: $email');
    try {
      final resp = await _dio.post('/user/register', data: {'name': name, 'email': email, 'password': password});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);

      // Store and apply the new token
      await _tokenStore.saveToken(loginDTO.token!);
      _dio.options.headers['Authorization'] = 'Bearer ${loginDTO.token}';

      LoggerService().i('Registration successful, token stored');
    } catch (e, st) {
      LoggerService().e('Registration error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      rethrow;
    }
  }

  /// Retrieves the current user's profile information.
  Future<ProfileDTO?> getProfile({required BuildContext context}) async {
    LoggerService().i('Fetching user profile');
    try {
      final resp = await _dio.get('/user/profile');
      LoggerService().i('Profile fetched successfully');
      return ProfileDTO.fromJson(resp.data as Map<String, dynamic>);
    } catch (e, st) {
      LoggerService().e('getProfile error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  /// Uploads a photo file and returns the new photo URL on success.
  Future<String?> uploadPhoto({required BuildContext context, required File file}) async {
    final name = file.uri.pathSegments.last;
    LoggerService().i('Uploading photo: $name');
    try {
      final form = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: name)});
      final resp = await _dio.post('/user/upload_photo', data: form, options: Options(headers: {'Content-Type': 'multipart/form-data'}, validateStatus: (status) => status != null && status < 500));

      if (resp.statusCode == 200) {
        final url = (resp.data['data'] as Map<String, dynamic>)['photoUrl'] as String;
        LoggerService().i('Photo uploaded successfully: $url');
        return url;
      }
      throw Exception('${'upload_failed'.tr()} (${resp.statusCode})');
    } catch (e, st) {
      LoggerService().e('uploadPhoto error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  /// Toggles favorite status for a movie by its [movieId].
  Future<void> toggleFavorite(String movieId, {required BuildContext context}) async {
    LoggerService().i('Toggling favorite for movie: $movieId');
    try {
      await _dio.post('/movie/favorite/$movieId');
      LoggerService().i('toggleFavorite successful');
    } catch (e, st) {
      LoggerService().e('toggleFavorite error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
    }
  }

  /// Fetches the list of favorite movies for the current user.
  Future<List<MovieDTO>?> getFavoriteMovies({required BuildContext context}) async {
    LoggerService().i('Fetching favorite movies');
    try {
      final resp = await _dio.get('/movie/favorites');
      final list = (resp.data as Map<String, dynamic>)['data'] as List;
      LoggerService().i('Favorite movies fetched: length=${list.length}');
      return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      LoggerService().e('getFavoriteMovies error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  /// Retrieves a paged list of movies. Default [page] is 1.
  Future<List<MovieDTO>?> fetchMoviePage({required BuildContext context, int page = 1}) async {
    LoggerService().i('Fetching movie page: $page');
    try {
      final resp = await _dio.get('/movie/list', queryParameters: {'page': page});
      if (resp.statusCode != 200) {
        throw DioException(requestOptions: resp.requestOptions, response: resp, error: 'server_error_page'.tr(args: [page.toString(), resp.statusCode.toString()]));
      }
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final movies = data['movies'] as List<dynamic>;
      LoggerService().i('fetchMoviePage successful: count=${movies.length}');
      return movies.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      LoggerService().e('fetchMoviePage error: $e', e as Exception, st);
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }
}
