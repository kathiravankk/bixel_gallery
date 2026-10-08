import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class CategoryChipsWidget extends GetView<GalleryController> {
  const CategoryChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : (isDark ? AppColors.darkField : AppColors.lightField),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 1,
                  ),
                ),
                child: Text(
                  cat,
                  style: AppStyles.customTextStyle(
                    size: 13,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.blackColor
                        : (isDark ? AppColors.whiteColor : AppColors.blackColor),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
