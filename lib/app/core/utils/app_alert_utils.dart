import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'app_styles.dart';

class AppAlertUtils {
  /// Show toast with custom success / failure colors matching Internsharks design
  static void showToast({required String message, bool isError = false}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      textColor: isError ? AppColors.failTextColor : AppColors.sucTextColor,
      fontSize: 14,
      backgroundColor: isError ? AppColors.failBgColor : AppColors.sucBgColor,
    );
  }

  /// Show confirmation dialog
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    VoidCallback? onConfirm,
    bool isDestructive = false,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: AppStyles.customTextStyle(
            size: 18,
            weight: FontWeight.w700,
            color: isDark ? AppColors.whiteColor : AppColors.blackColor,
          ),
        ),
        content: Text(
          content,
          style: AppStyles.customTextStyle(
            size: 14,
            color: isDark ? AppColors.greyLight : AppColors.greyDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              cancelText,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.greyColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDestructive ? AppColors.favoriteRed : AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              confirmText,
              style: AppStyles.customTextStyle(
                size: 14,
                color: AppColors.whiteColor,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
