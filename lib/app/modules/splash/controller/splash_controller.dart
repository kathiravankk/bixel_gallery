import 'dart:async';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/routes/app_pages.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 1800), () {
      Get.offAllNamed(AppRoutes.galleryHome);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
