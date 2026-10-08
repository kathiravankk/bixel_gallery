import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pixabay_image_model.dart';

class LocalStorageService {
  static const String _favoritesKey = 'saved_favorite_images';
  static const String _themeModeKey = 'is_dark_theme_mode';
  static const String _apiKeyKey = 'custom_pixabay_api_key';

  /// Save image to favorites
  static Future<bool> addFavorite(PixabayImageModel image) async {
    final prefs = await SharedPreferences.getInstance();
    List<PixabayImageModel> favorites = await getFavorites();
    if (!favorites.any((item) => item.id == image.id)) {
      favorites.insert(0, image);
      final jsonList = favorites.map((item) => jsonEncode(item.toJson())).toList();
      return await prefs.setStringList(_favoritesKey, jsonList);
    }
    return false;
  }

  /// Remove image from favorites
  static Future<bool> removeFavorite(int imageId) async {
    final prefs = await SharedPreferences.getInstance();
    List<PixabayImageModel> favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == imageId);
    final jsonList = favorites.map((item) => jsonEncode(item.toJson())).toList();
    return await prefs.setStringList(_favoritesKey, jsonList);
  }

  /// Check if image is favorited
  static Future<bool> isFavorite(int imageId) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == imageId);
  }

  /// Get all favorites
  static Future<List<PixabayImageModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey);
    if (jsonList == null || jsonList.isEmpty) return [];

    try {
      return jsonList
          .map((item) => PixabayImageModel.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save Theme Mode
  static Future<void> saveThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDark);
  }

  /// Get Theme Mode
  static Future<bool?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey);
  }

  /// Save Custom API Key
  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, key);
  }

  /// Get Custom API Key
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
