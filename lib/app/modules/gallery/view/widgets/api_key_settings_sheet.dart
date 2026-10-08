import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/utils/app_alert_utils.dart';
import 'package:image_gallery_app/app/core/utils/app_colors.dart';
import 'package:image_gallery_app/app/core/utils/app_styles.dart';
import 'package:image_gallery_app/app/data/repositories/local_storage_service.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';

class ApiKeySettingsSheet extends StatefulWidget {
  const ApiKeySettingsSheet({super.key});

  @override
  State<ApiKeySettingsSheet> createState() => _ApiKeySettingsSheetState();
}

class _ApiKeySettingsSheetState extends State<ApiKeySettingsSheet> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentKey();
  }

  Future<void> _loadCurrentKey() async {
    final key = await LocalStorageService.getApiKey();
    if (key != null) {
      _apiKeyController.text = key;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveKey() async {
    final key = _apiKeyController.text.trim();
    await LocalStorageService.saveApiKey(key);
    Get.back();

    AppAlertUtils.showToast(
      message: key.isEmpty
          ? "Switched to Curated Demo Mode"
          : "Pixabay API Key saved successfully!",
      isError: false,
    );

    // Refresh images
    if (Get.isRegistered<GalleryController>()) {
      Get.find<GalleryController>().fetchImages(isRefresh: true);
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.greyDark : AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.key_rounded, color: AppColors.primaryColor, size: 24),
              const SizedBox(width: 10),
              Text(
                "Pixabay API Key Configuration",
                style: AppStyles.customTextStyle(
                  size: 16,
                  weight: FontWeight.w700,
                  color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            "Enter your Pixabay API key below to query live Pixabay servers. If left empty, the app will run seamlessly in Curated Demo Mode.",
            style: AppStyles.customTextStyle(
              size: 12,
              color: isDark ? AppColors.greyLight : AppColors.greyDark,
              lineSpace: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            TextField(
              controller: _apiKeyController,
              style: AppStyles.customTextStyle(
                size: 14,
                color: isDark ? AppColors.whiteColor : AppColors.blackColor,
              ),
              decoration: InputDecoration(
                hintText: "Paste your Pixabay API key here",
                prefixIcon: const Icon(Icons.vpn_key_outlined, size: 20),
                suffixIcon: _apiKeyController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _apiKeyController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _apiKeyController.clear();
                      _saveKey();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      "Use Demo Mode",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        weight: FontWeight.w600,
                        color: isDark ? AppColors.greyLight : AppColors.greyDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveKey,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Save & Apply",
                      style: AppStyles.customTextStyle(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
