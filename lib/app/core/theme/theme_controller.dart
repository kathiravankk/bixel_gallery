import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/data/repositories/local_storage_service.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final savedIsDark = await LocalStorageService.getThemeMode();
    if (savedIsDark != null) {
      isDarkMode.value = savedIsDark;
      Get.changeThemeMode(savedIsDark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    LocalStorageService.saveThemeMode(isDarkMode.value);
  }
}
