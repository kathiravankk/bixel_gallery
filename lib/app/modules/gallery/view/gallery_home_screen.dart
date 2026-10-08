import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/theme/theme_controller.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/core/widgets/custom_shimmer.dart';
import 'package:image_gallery_app/app/modules/favorites/controller/favorites_controller.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';
import 'package:image_gallery_app/app/routes/app_pages.dart';
import 'widgets/api_key_settings_sheet.dart';
import 'widgets/category_chips_widget.dart';
import 'widgets/image_grid_card.dart';
import 'widgets/search_field_widget.dart';

class GalleryHomeScreen extends GetView<GalleryController> {
  const GalleryHomeScreen({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = Get.find<ThemeController>();
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkScaffold : AppColors.lightScaffold,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.photo_library_rounded,
                size: 20,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Pix",
                    style: AppStyles.customTextStyle(
                      size: 20,
                      weight: FontWeight.w800,
                      color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  TextSpan(
                    text: "Gallery",
                    style: AppStyles.customTextStyle(
                      size: 20,
                      weight: FontWeight.w800,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Theme Toggle Button
          Obx(() => IconButton(
                icon: Icon(
                  themeController.isDarkMode.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                  size: 22,
                ),
                tooltip: "Toggle Theme",
                onPressed: themeController.toggleTheme,
              )),

          // API Key Settings
          IconButton(
            icon: Icon(
              Icons.key_rounded,
              color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              size: 22,
            ),
            tooltip: "Configure Pixabay Key",
            onPressed: () {
              Get.bottomSheet(
                const ApiKeySettingsSheet(),
                isScrollControlled: true,
              );
            },
          ),

          // Favorites Screen Shortcut with Badge Counter
          Obx(() {
            final count = favoritesController.favorites.length;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: AppColors.favoriteRed, size: 23),
                  tooltip: "Saved Favorites",
                  onPressed: () => Get.toNamed(AppRoutes.favorites),
                ),
                if (count > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () => controller.fetchImages(isRefresh: true),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Search Bar
            const SearchFieldWidget(),
            const SizedBox(height: 14),

            // Category Horizontal Filter Bar
            const CategoryChipsWidget(),
            const SizedBox(height: 12),

            // Main Content Area
            Expanded(
              child: Obx(() {
                // Initial Loading Shimmer Grid
                if (controller.isLoading.value) {
                  return _buildShimmerGrid(context);
                }

                // Error State View
                if (controller.hasError.value && controller.images.isEmpty) {
                  return _buildErrorState(context);
                }

                // Empty State View
                if (controller.images.isEmpty) {
                  return _buildEmptyState(context);
                }

                // Masonry Responsive Gallery Grid
                return CustomScrollView(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: _getCrossAxisCount(context),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        itemBuilder: (context, index) {
                          final image = controller.images[index];
                          return ImageGridCard(image: image);
                        },
                        childCount: controller.images.length,
                      ),
                    ),

                    // Pagination Loader at Bottom
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.isLoadingMore.value) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                          );
                        }

                        if (!controller.hasMore.value && controller.images.length > 10) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                "You've reached the end of the gallery",
                                style: AppStyles.customTextStyle(
                                  size: 12,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                          );
                        }

                        return const SizedBox(height: 16);
                      }),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MasonryGridView.count(
        crossAxisCount: _getCrossAxisCount(context),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        itemCount: 8,
        itemBuilder: (context, index) {
          final heights = [220.0, 160.0, 260.0, 180.0, 240.0, 170.0, 210.0, 190.0];
          return CustomShimmer(
            width: double.infinity,
            height: heights[index % heights.length],
            borderRadius: BorderRadius.circular(16),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.failTextColor.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 50,
                color: AppColors.failTextColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Something Went Wrong",
              style: AppStyles.customTextStyle(
                size: 18,
                weight: FontWeight.w700,
                color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : "Unable to load photos. Please check your internet connection.",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.greyColor,
                lineSpace: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchImages(isRefresh: true),
              icon: const Icon(Icons.refresh_rounded, color: AppColors.blackColor),
              label: Text(
                "Try Again",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 50,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "No Photos Found",
              style: AppStyles.customTextStyle(
                size: 18,
                weight: FontWeight.w700,
                color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? "We couldn't find any photos matching '${controller.searchQuery.value}'."
                  : "No images available in this category.",
              textAlign: TextAlign.center,
              style: AppStyles.customTextStyle(
                size: 13,
                color: AppColors.greyColor,
                lineSpace: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: controller.clearSearch,
              child: Text(
                "Clear Search Filter",
                style: AppStyles.customTextStyle(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
