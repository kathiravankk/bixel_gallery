import 'dart:math';

class CommonUtils {
  /// Format large numbers like 14200 -> '14.2K'
  static String formatNumber(int? number) {
    if (number == null) return "0";
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      double result = number / 1000.0;
      return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}K";
    }
    double result = number / 1000000.0;
    return "${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M";
  }

  /// Format bytes into human readable string: 1048576 -> '1.0 MB'
  static String formatBytes(int? bytes, [int decimals = 1]) {
    if (bytes == null || bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
