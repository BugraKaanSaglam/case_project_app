// ignore_for_file: use_build_context_synchronously

import 'package:case_project_app/viewmodels/profilephoto_viewmodels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:case_project_app/global/global_scaffold.dart';
import 'package:case_project_app/global/global_variables.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilephotoScreen extends StatelessWidget {
  const ProfilephotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfilePhotoViewModel>(
      create: (_) => ProfilePhotoViewModel(),
      child: Consumer<ProfilePhotoViewModel>(
        builder: (context, vm, _) {
          return globalScaffold(title: 'profil_fotografi_ekle'.tr(), body: _body(context, vm), isBackButtonVisible: false);
        },
      ),
    );
  }

  Widget _body(BuildContext context, ProfilePhotoViewModel vm) {
    final imageUrl = loginDTO.photoUrl;
    final localImage = vm.selectedImage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text('fotograflarinizi_yukleyin'.tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('fotograf_yukleme_aciklama'.tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: () async {
                try {
                  await vm.pickAndUpload(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('fotograf_yuklenirken_hata'.tr(args: [e.toString()]))));
                }
              },
              child: Container(
                width: screenWidth / 3,
                height: screenWidth / 3,
                decoration: BoxDecoration(
                  color: (localImage != null || (imageUrl != null && imageUrl.isNotEmpty)) ? null : Colors.grey[850],
                  borderRadius: BorderRadius.circular(20),
                  image:
                      localImage != null
                          ? DecorationImage(image: FileImage(localImage), fit: BoxFit.cover)
                          : (imageUrl != null && imageUrl.isNotEmpty)
                          ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
                          : null,
                ),
                child:
                    vm.isUploading
                        ? const CircularProgressIndicator()
                        : (localImage == null && (imageUrl == null || imageUrl.isEmpty))
                        ? const Icon(Icons.add, size: 48, color: Colors.white54)
                        : null,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), padding: const EdgeInsets.symmetric(vertical: 16)), child: Text('devam_et'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
