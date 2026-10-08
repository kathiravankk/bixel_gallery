import 'package:dio/dio.dart';
import '../models/pixabay_image_model.dart';
import '../models/pixabay_response_model.dart';
import '../providers/gallery_provider.dart';
import 'local_storage_service.dart';

class GalleryRepository {
  final GalleryProvider galleryProvider;

  GalleryRepository({required this.galleryProvider});

  /// Fetch images with search, category, color filter, ID lookup, and pagination
  Future<PixabayResponseModel> fetchImages({
    String query = '',
    String category = '',
    String colors = '',
    String imageId = '',
    int page = 1,
    int perPage = 20,
  }) async {
    return await galleryProvider.fetchImages(
      query: query,
      category: category,
      colors: colors,
      imageId: imageId,
      page: page,
      perPage: perPage,
    );
  }

  /// Retrieve individual image by Pixabay ID
  Future<PixabayResponseModel> fetchImageById(String id) async {
    return await galleryProvider.fetchImageById(id);
  }

  /// Download image file
  Future<Response> downloadImage({
    required String imageUrl,
    required String savePath,
    required ProgressCallback onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    return await galleryProvider.downloadImage(
      imageUrl: imageUrl,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  /// Toggle favorite status and return new status
  Future<bool> toggleFavorite(PixabayImageModel image) async {
    final alreadyFavorited = await LocalStorageService.isFavorite(image.id);
    if (alreadyFavorited) {
      await LocalStorageService.removeFavorite(image.id);
      return false;
    } else {
      await LocalStorageService.addFavorite(image);
      return true;
    }
  }

  /// Check if image is currently favorited
  Future<bool> isFavorite(int id) async {
    return await LocalStorageService.isFavorite(id);
  }

  /// Get list of favorited images
  Future<List<PixabayImageModel>> getFavorites() async {
    return await LocalStorageService.getFavorites();
  }

  /// Save custom API key
  Future<void> saveApiKey(String key) async {
    await LocalStorageService.saveApiKey(key);
  }

  /// Get custom API key
  Future<String?> getApiKey() async {
    return await LocalStorageService.getApiKey();
  }
}
