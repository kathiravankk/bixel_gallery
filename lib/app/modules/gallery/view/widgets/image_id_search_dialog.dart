import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class ImageIdSearchDialog extends StatefulWidget {
  const ImageIdSearchDialog({super.key});

  @override
  State<ImageIdSearchDialog> createState() => _ImageIdSearchDialogState();
}

class _ImageIdSearchDialogState extends State<ImageIdSearchDialog> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<GalleryController>();

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.pin_outlined, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 8),
          Text(
            "Lookup by Image ID",
            style: AppStyles.customTextStyle(
              size: 16,
              weight: FontWeight.w700,
              color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Retrieve an individual image directly from Pixabay using its numeric ID (e.g. 7133867).",
            style: AppStyles.customTextStyle(
              size: 12,
              color: isDark ? AppColors.greyLight : AppColors.greyDark,
              lineSpace: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _idController,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: AppStyles.customTextStyle(
              size: 14,
              color: isDark ? AppColors.whiteColor : AppColors.blackColor,
            ),
            decoration: InputDecoration(
              hintText: "Enter Image ID (e.g. 7133867)",
              prefixIcon: const Icon(Icons.tag_rounded, size: 20),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            "Cancel",
            style: AppStyles.customTextStyle(
              size: 13,
              color: AppColors.greyColor,
              weight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final id = _idController.text.trim();
            if (id.isNotEmpty) {
              Get.back();
              controller.searchById(id);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            "Find Image",
            style: AppStyles.customTextStyle(
              size: 13,
              weight: FontWeight.w700,
              color: AppColors.blackColor,
            ),
          ),
        ),
      ],
    );
  }
}
