import 'package:get/get.dart';
import '../../../core/utils/app_alert_utils.dart';
import '../../../data/models/pixabay_image_model.dart';
import '../../../data/repositories/local_storage_service.dart';

class FavoritesController extends GetxController {
  final RxList<PixabayImageModel> favorites = <PixabayImageModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      final list = await LocalStorageService.getFavorites();
      favorites.assignAll(list);
    } catch (e) {
      // Fallback
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(int id) {
    return favorites.any((item) => item.id == id);
  }

  Future<void> toggleFavorite(PixabayImageModel image) async {
    final exists = isFavorite(image.id);
    if (exists) {
      await LocalStorageService.removeFavorite(image.id);
      favorites.removeWhere((item) => item.id == image.id);
      AppAlertUtils.showToast(message: "Removed from favorites", isError: false);
    } else {
      await LocalStorageService.addFavorite(image);
      favorites.insert(0, image);
      AppAlertUtils.showToast(message: "Saved to favorites", isError: false);
    }
  }

  Future<void> removeFavorite(int id) async {
    await LocalStorageService.removeFavorite(id);
    favorites.removeWhere((item) => item.id == id);
    AppAlertUtils.showToast(message: "Removed from favorites", isError: false);
  }
}
