// api_service.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:case_project_app/global/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:case_project_app/global/global_constants.dart';
import 'package:case_project_app/helper/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:case_project_app/dto/login_dto.dart';
import 'package:case_project_app/dto/profile_dto.dart';
import 'package:case_project_app/dto/movie_dto.dart';

class ApiService {
  ApiService._internal() : _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));
  static final ApiService instance = ApiService._internal();

  final Dio _dio;

  void _updateAuthHeader() {
    final t = loginDTO.token;
    if (t != null) {
      _dio.options.headers['Authorization'] = 'Bearer $t';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<void> login({required BuildContext context, required String email, required String password}) async {
    try {
      final response = await _dio.post('/user/login', data: {'email': email, 'password': password});
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);
      _updateAuthHeader();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      rethrow;
    }
  }

  Future<void> register({required BuildContext context, required String name, required String email, required String password}) async {
    try {
      final response = await _dio.post('/user/register', data: {'name': name, 'email': email, 'password': password});
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);
      _updateAuthHeader();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      rethrow;
    }
  }

  Future<ProfileDTO?> getProfile({required BuildContext context}) async {
    try {
      final response = await _dio.get('/user/profile');
      return ProfileDTO.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      return null;
    }
  }

  Future<String?> uploadPhoto({required BuildContext context, required File file}) async {
    try {
      final fileName = file.uri.pathSegments.last;
      final formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: fileName)});

      final response = await _dio.post('/user/upload_photo', data: formData, options: Options(headers: {'Content-Type': 'multipart/form-data'}, validateStatus: (status) => status != null && status < 500));

      if (response.statusCode == 200) {
        return (response.data['data'] as Map<String, dynamic>)['photoUrl'] as String;
      }
      throw Exception('Upload failed (${response.statusCode})');
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      return null;
    }
  }

  Future<void> toggleFavorite(String movieId, {required BuildContext context}) async {
    try {
      await _dio.post('/movie/favorite/$movieId');
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
    }
  }

  Future<List<MovieDTO>?> getFavoriteMovies({required BuildContext context}) async {
    try {
      final response = await _dio.get('/movie/favorites');
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      return null;
    }
  }

  Future<List<MovieDTO>?> fetchMoviePage({required BuildContext context, int page = 1}) async {
    try {
      final response = await _dio.get('/movie/list', queryParameters: {'page': page});
      if (response.statusCode != 200) {
        throw DioException(requestOptions: response.requestOptions, response: response, error: 'Sunucu sayfa $page döndürmedi (status ${response.statusCode})');
      }
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final moviesJson = data['movies'] as List<dynamic>;
      return moviesJson.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'HATA', message: e.toString());
      return null;
    }
  }
}
