// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:case_project_app/api/api_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:case_project_app/global/global_scaffold.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:flutter/material.dart';

class ProfilephotoScreen extends StatefulWidget {
  const ProfilephotoScreen({super.key});

  @override
  State<ProfilephotoScreen> createState() => _ProfilephotoScreenState();
}

class _ProfilephotoScreenState extends State<ProfilephotoScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800, imageQuality: 80);
    if (picked != null) {
      try {
        String resUrl = await ApiService().uploadPhoto(File(picked.path));
        // Update the global loginDTO with the new photo URL
        loginDTO.photoUrl = resUrl;
        setState(() {
          _selectedImage = File(picked.path);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fotoğraf yüklenirken hata oluştu: $e')));
      }
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('Fotoğraf Kaynağı', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text('Kamera', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Galeriden Seç', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return globalScaffold(
      title: 'Profil Fotoğrafı Ekle',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text('Fotoğraflarınızı Yükleyin', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Resources out incentivize\nrelaxation floor loss cc.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  _showImageSourceActionSheet(context);
                },
                child: Container(
                  width: screenWidth / 3,
                  height: screenWidth / 3,
                  decoration: BoxDecoration(
                    color: (_selectedImage != null || (loginDTO.photoUrl != null && loginDTO.photoUrl!.isNotEmpty)) ? null : Colors.grey[850],
                    borderRadius: BorderRadius.circular(20),
                    image:
                        _selectedImage != null
                            ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                            : (loginDTO.photoUrl != null && loginDTO.photoUrl!.isNotEmpty)
                            ? DecorationImage(image: NetworkImage(loginDTO.photoUrl!), fit: BoxFit.cover)
                            : null,
                  ),
                  child: (_selectedImage == null && (loginDTO.photoUrl == null || loginDTO.photoUrl!.isEmpty)) ? const Icon(Icons.add, size: 48, color: Colors.white54) : null,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Devam Et', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
