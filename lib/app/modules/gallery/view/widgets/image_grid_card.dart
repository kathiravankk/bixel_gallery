import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/core/utils/common_utils.dart';
import 'package:image_gallery_app/app/core/widgets/custom_network_image.dart';
import 'package:image_gallery_app/app/data/models/pixabay_image_model.dart';
import 'package:image_gallery_app/app/modules/favorites/controller/favorites_controller.dart';
import 'package:image_gallery_app/app/routes/app_pages.dart';

class ImageGridCard extends StatelessWidget {
  final PixabayImageModel image;

  const ImageGridCard({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.imageDetail, arguments: image);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Hero Image with dynamic aspect ratio
              AspectRatio(
                aspectRatio: image.aspectRatio,
                child: Hero(
                  tag: "hero_image_${image.id}",
                  child: CustomNetworkImage(
                    imageUrl: image.webformatURL,
                    fit: BoxFit.cover,
                    memCacheWidth: 600,
                    memCacheHeight: 800,
                  ),
                ),
              ),

              // Bottom Gradient Overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                  decoration: const BoxDecoration(
                    gradient: AppColors.cardOverlayGradient,
                  ),
                  child: Row(
                    children: [
                      // Author Avatar
                      if (image.userImageURL.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomNetworkImage(
                            imageUrl: image.userImageURL,
                            width: 22,
                            height: 22,
                            memCacheWidth: 60,
                            memCacheHeight: 60,
                          ),
                        )
                      else
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              image.user.isNotEmpty ? image.user[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),

                      // Author Name
                      Expanded(
                        child: Text(
                          image.user,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: 11,
                            weight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),

                      // Likes Badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 13,
                            color: AppColors.favoriteRed,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            CommonUtils.formatNumber(image.likes),
                            style: AppStyles.customTextStyle(
                              size: 10,
                              weight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite Heart Button (Top Right)
              Positioned(
                top: 8,
                right: 8,
                child: GetBuilder<FavoritesController>(
                  builder: (favController) {
                    return Obx(() {
                      final isFav = favController.isFavorite(image.id);
                      return GestureDetector(
                        onTap: () => favController.toggleFavorite(image),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withValues(alpha: 0.45),
                          ),
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isFav ? AppColors.favoriteRed : AppColors.whiteColor,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
