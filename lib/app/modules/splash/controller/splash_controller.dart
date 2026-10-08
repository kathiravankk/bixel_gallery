import 'dart:async';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(milliseconds: 1800), () {
      Get.offNamed(AppRoutes.galleryHome);
    });
  }
}
