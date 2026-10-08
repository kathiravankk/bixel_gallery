import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/favorites/controller/favorites_controller.dart';
import 'package:image_gallery_app/app/modules/gallery/view/widgets/image_grid_card.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      appBar: AppBar(
        title: Text(
          "Favorite Photos",
          style: AppStyles.customTextStyle(
            size: 18,
            weight: FontWeight.w700,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final count = controller.favorites.length;
            if (count == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    "$count Saved",
                    style: AppStyles.customTextStyle(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.favoriteRed.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 52,
                      color: AppColors.favoriteRed,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Favorites Saved Yet",
                    style: AppStyles.customTextStyle(
                      size: 18,
                      weight: FontWeight.w700,
                      color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Explore the image gallery and tap the heart icon on any photo to save it for offline quick access.",
                    textAlign: TextAlign.center,
                    style: AppStyles.customTextStyle(
                      size: 13,
                      color: AppColors.greyColor,
                      lineSpace: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Explore Gallery",
                      style: AppStyles.customTextStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: MasonryGridView.count(
            crossAxisCount: _getCrossAxisCount(context),
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            itemCount: controller.favorites.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final image = controller.favorites[index];
              return ImageGridCard(image: image);
            },
          ),
        );
      }),
    );
  }
}
