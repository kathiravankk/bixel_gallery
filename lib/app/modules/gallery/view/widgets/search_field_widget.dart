import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class SearchFieldWidget extends GetView<GalleryController> {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: controller.onSearchChanged,
          style: AppStyles.customTextStyle(
            size: 14,
            weight: FontWeight.w500,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
          ),
          decoration: InputDecoration(
            hintText: "Search high quality photos...",
            hintStyle: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.greyColor,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryColor,
              size: 22,
            ),
            suffixIcon: Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.greyColor,
                  onPressed: controller.clearSearch,
                );
              }
              return const SizedBox.shrink();
            }),
            filled: true,
            fillColor: isDark ? AppColors.darkField : AppColors.lightField,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
