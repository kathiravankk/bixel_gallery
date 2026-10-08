import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class ColorFilterBarWidget extends GetView<GalleryController> {
  const ColorFilterBarWidget({super.key});

  Color _getColorValue(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return const Color(0xFFEF4444);
      case 'orange':
        return const Color(0xFFF97316);
      case 'yellow':
        return const Color(0xFFFACC15);
      case 'green':
        return const Color(0xFF22C55E);
      case 'turquoise':
        return const Color(0xFF14B8A6);
      case 'blue':
        return const Color(0xFF3B82F6);
      case 'lilac':
        return const Color(0xFFC084FC);
      case 'pink':
        return const Color(0xFFEC4899);
      case 'white':
        return const Color(0xFFFFFFFF);
      case 'gray':
        return const Color(0xFF9CA3AF);
      case 'black':
        return const Color(0xFF18181B);
      case 'brown':
        return const Color(0xFF78350F);
      case 'grayscale':
        return const Color(0xFF6B7280);
      case 'transparent':
        return const Color(0xFFE0E7FF);
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.colorOptions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final colorName = controller.colorOptions[index];
          final dotColor = _getColorValue(colorName);

          return Obx(() {
            final isSelected = controller.selectedColor.value == colorName;
            return GestureDetector(
              onTap: () => controller.selectColor(colorName),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkField : AppColors.lightField)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (colorName.toLowerCase() != 'all') ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColor,
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                            width: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ] else ...[
                      Icon(
                        Icons.palette_outlined,
                        size: 13,
                        color: isSelected
                            ? AppColors.primaryColor
                            : (isDark ? AppColors.whiteColor : AppColors.blackColor),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      colorName,
                      style: AppStyles.customTextStyle(
                        size: 11,
                        weight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryColor
                            : (isDark ? AppColors.greyLight : AppColors.greyDark),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
