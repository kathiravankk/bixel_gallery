import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller; // Ensures SplashController is instantiated immediately
    return Scaffold(
      backgroundColor: AppColors.darkScaffold,
      body: Stack(
        children: [
          // Ambient Gradient Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Central Branding
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.photo_library_rounded,
                      size: 46,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pix",
                      style: AppStyles.customTextStyle(
                        size: 32,
                        weight: FontWeight.w800,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      "Gallery",
                      style: AppStyles.customTextStyle(
                        size: 32,
                        weight: FontWeight.w800,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "Discover & Download High-Res Photography",
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: FontWeight.w400,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Version / Credits
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Powered by Pixabay API",
                  style: AppStyles.customTextStyle(
                    size: 11,
                    weight: FontWeight.w500,
                    color: AppColors.greyColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
