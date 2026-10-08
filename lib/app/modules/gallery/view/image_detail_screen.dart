import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/core/utils/common_utils.dart';
import 'package:image_gallery_app/app/core/widgets/custom_network_image.dart';
import 'package:image_gallery_app/app/data/models/pixabay_image_model.dart';
import 'package:image_gallery_app/app/modules/favorites/controller/favorites_controller.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PixabayImageModel image = Get.arguments as PixabayImageModel;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final galleryController = Get.find<GalleryController>();
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      appBar: AppBar(
        title: Text(
          "Photo Details",
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
          // Favorite Button
          Obx(() {
            final isFav = favoritesController.isFavorite(image.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav
                    ? AppColors.favoriteRed
                    : (isDark ? AppColors.whiteColor : AppColors.blackColor),
              ),
              onPressed: () => favoritesController.toggleFavorite(image),
            );
          }),

          // Share Button
          IconButton(
            icon: const Icon(Icons.share_rounded, size: 22),
            onPressed: () => galleryController.shareImage(image),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
          ),
          child: Row(
            children: [
              // Download Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => galleryController.downloadImage(image),
                  icon: const Icon(Icons.file_download_rounded, color: AppColors.blackColor),
                  label: Text(
                    "Download HD Photo",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Hero Image with Pinch-to-Zoom
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.48,
              ),
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Hero(
                    tag: "hero_image_${image.id}",
                    child: CustomNetworkImage(
                      imageUrl: image.largeImageURL.isNotEmpty
                          ? image.largeImageURL
                          : image.webformatURL,
                      fit: BoxFit.contain,
                      memCacheWidth: 1200,
                      memCacheHeight: 1600,
                    ),
                  ),
                ),
              ),
            ),

            // Zoom helper hint
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pinch_rounded, size: 14, color: AppColors.greyColor),
                  const SizedBox(width: 6),
                  Text(
                    "Pinch or double tap to zoom photo",
                    style: AppStyles.customTextStyle(
                      size: 11,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Info Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (image.userImageURL.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CustomNetworkImage(
                              imageUrl: image.userImageURL,
                              width: 44,
                              height: 44,
                              memCacheWidth: 100,
                              memCacheHeight: 100,
                            ),
                          )
                        else
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                            ),
                            child: Center(
                              child: Text(
                                image.user.isNotEmpty
                                    ? image.user[0].toUpperCase()
                                    : 'A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                image.user,
                                style: AppStyles.customTextStyle(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "Pixabay Verified Creator • ID: ${image.userId}",
                                style: AppStyles.customTextStyle(
                                  size: 11,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Image Stats Grid
                  Text(
                    "Photo Statistics",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w700,
                      color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildStatTile(
                        context,
                        icon: Icons.visibility_outlined,
                        iconColor: AppColors.infoBlue,
                        title: "Views",
                        value: CommonUtils.formatNumber(image.views),
                      ),
                      const SizedBox(width: 10),
                      _buildStatTile(
                        context,
                        icon: Icons.favorite_outline_rounded,
                        iconColor: AppColors.favoriteRed,
                        title: "Likes",
                        value: CommonUtils.formatNumber(image.likes),
                      ),
                      const SizedBox(width: 10),
                      _buildStatTile(
                        context,
                        icon: Icons.download_rounded,
                        iconColor: AppColors.primaryColor,
                        title: "Downloads",
                        value: CommonUtils.formatNumber(image.downloads),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _buildStatTile(
                        context,
                        icon: Icons.aspect_ratio_rounded,
                        iconColor: Colors.purpleAccent,
                        title: "Dimensions",
                        value: "${image.imageWidth} × ${image.imageHeight}",
                      ),
                      const SizedBox(width: 10),
                      _buildStatTile(
                        context,
                        icon: Icons.sd_storage_outlined,
                        iconColor: Colors.orangeAccent,
                        title: "File Size",
                        value: image.imageSize > 0
                            ? CommonUtils.formatBytes(image.imageSize)
                            : "High Res",
                      ),
                      const SizedBox(width: 10),
                      _buildStatTile(
                        context,
                        icon: Icons.tag_rounded,
                        iconColor: AppColors.primaryColor,
                        title: "Image ID",
                        value: "#${image.id}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Tags & Description
                  Text(
                    "Keywords & Tags",
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w700,
                      color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: image.tagsList.map((tag) {
                      return GestureDetector(
                        onTap: () {
                          // Tap tag to search gallery
                          Get.back();
                          galleryController.searchController.text = tag;
                          galleryController.onSearchChanged(tag);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkField
                                : AppColors.lightField,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tag_rounded,
                                size: 14,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                CommonUtils.capitalize(tag),
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  weight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.customTextStyle(
                size: 13,
                weight: FontWeight.w700,
                color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppStyles.customTextStyle(
                size: 10,
                color: AppColors.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
