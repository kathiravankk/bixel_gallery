import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback buttonFunction;
  final String buttonText;
  final double? width;
  final double height;
  final Color bgColor;
  final Color textColor;
  final IconData? icon;
  final double borderRadius;
  final bool isLoading;

  const CustomButtonWidget({
    super.key,
    required this.buttonFunction,
    required this.buttonText,
    this.width,
    this.height = 46,
    this.bgColor = AppColors.primaryColor,
    this.textColor = AppColors.blackColor,
    this.icon,
    this.borderRadius = 12,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : buttonFunction,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    buttonText,
                    style: AppStyles.customTextStyle(
                      size: 14,
                      weight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
