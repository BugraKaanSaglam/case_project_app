// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:case_project_app/api/api_services.dart';
import 'package:case_project_app/global/global_variables.dart';

class ProfilePhotoViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false;

  /// Picks image and uploads it
  Future<void> pickAndUpload(BuildContext context) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    if (picked == null) return;

    selectedImage = File(picked.path);
    isUploading = true;
    notifyListeners();

    try {
      final resUrl = await ApiService.instance.uploadPhoto(context: context, file: selectedImage!);
      if (resUrl != null) {
        loginDTO.photoUrl = resUrl;
      }
    } catch (e) {
      // Bubble up error for view to handle
      rethrow;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
