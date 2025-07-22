// lib/api/api_service.dart
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
import 'package:case_project_app/helper/token_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiService {
  ApiService._internal() : _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));
  static final ApiService instance = ApiService._internal();

  final Dio _dio;
  final TokenStorageService _tokenStore = TokenStorageService();

  Future<void> login({required BuildContext context, required String email, required String password}) async {
    try {
      final resp = await _dio.post('/user/login', data: {'email': email, 'password': password});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);

      await _tokenStore.saveToken(loginDTO.token!);
      _dio.options.headers['Authorization'] = 'Bearer ${loginDTO.token}';
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenStore.deleteToken();
    loginDTO.token = null;
    _dio.options.headers.remove('Authorization');
  }

  Future<void> register({required BuildContext context, required String name, required String email, required String password}) async {
    try {
      final resp = await _dio.post('/user/register', data: {'name': name, 'email': email, 'password': password});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      loginDTO = LoginDTO.fromJson(data);

      await _tokenStore.saveToken(loginDTO.token!);
      _dio.options.headers['Authorization'] = 'Bearer ${loginDTO.token}';
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      rethrow;
    }
  }

  Future<ProfileDTO?> getProfile({required BuildContext context}) async {
    try {
      final resp = await _dio.get('/user/profile');
      return ProfileDTO.fromJson(resp.data as Map<String, dynamic>);
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  Future<String?> uploadPhoto({required BuildContext context, required File file}) async {
    try {
      final name = file.uri.pathSegments.last;
      final form = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: name)});
      final resp = await _dio.post('/user/upload_photo', data: form, options: Options(headers: {'Content-Type': 'multipart/form-data'}, validateStatus: (s) => s != null && s < 500));

      if (resp.statusCode == 200) {
        return (resp.data['data'] as Map<String, dynamic>)['photoUrl'] as String;
      }
      throw Exception('${'upload_failed'.tr()} (${resp.statusCode})');
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  Future<void> toggleFavorite(String movieId, {required BuildContext context}) async {
    try {
      await _dio.post('/movie/favorite/$movieId');
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
    }
  }

  Future<List<MovieDTO>?> getFavoriteMovies({required BuildContext context}) async {
    try {
      final resp = await _dio.get('/movie/favorites');
      final list = (resp.data as Map<String, dynamic>)['data'] as List;
      return list.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }

  Future<List<MovieDTO>?> fetchMoviePage({required BuildContext context, int page = 1}) async {
    try {
      final resp = await _dio.get('/movie/list', queryParameters: {'page': page});
      if (resp.statusCode != 200) {
        throw DioException(requestOptions: resp.requestOptions, response: resp, error: 'server_error_page'.tr(args: [page.toString(), resp.statusCode.toString()]));
      }
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      final movies = data['movies'] as List<dynamic>;
      return movies.map((e) => MovieDTO.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      await showAnimatedErrorDialog(context, title: 'error'.tr(), message: e.toString());
      return null;
    }
  }
}
