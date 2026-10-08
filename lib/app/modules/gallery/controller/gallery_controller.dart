import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/app_alert_utils.dart';
import '../../../core/utils/common_utils.dart';
import '../../../data/models/pixabay_image_model.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../favorites/controller/favorites_controller.dart';

class GalleryController extends GetxController {
  final GalleryRepository repository;

  GalleryController({required this.repository});

  // State Observables
  final RxList<PixabayImageModel> images = <PixabayImageModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Categories list matching Pixabay standard categories
  final List<String> categories = [
    'All',
    'Nature',
    'Architecture',
    'Animals',
    'Travel',
    'Technology',
    'Food',
    'Sports',
  ];

  // Search & Pagination Controllers
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounceTimer;

  // Download state observables
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxString downloadProgressText = ''.obs;
  CancelToken? _downloadCancelToken;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    fetchImages(isRefresh: true);
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      // Trigger load more when 300px away from bottom
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300 &&
          !isLoading.value &&
          !isLoadingMore.value &&
          hasMore.value) {
        loadMoreImages();
      }
    });
  }

  /// Initial or pull-to-refresh fetch
  Future<void> fetchImages({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      hasMore.value = true;
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
    }

    try {
      final response = await repository.fetchImages(
        query: searchQuery.value,
        category: selectedCategory.value,
        page: currentPage.value,
        perPage: 20,
      );

      if (isRefresh) {
        images.assignAll(response.hits);
      } else {
        images.addAll(response.hits);
      }

      // Check if more items exist
      if (response.hits.length < 20 || images.length >= response.totalHits) {
        hasMore.value = false;
      }
      hasError.value = false;
    } on DioException catch (dioErr) {
      hasError.value = true;
      errorMessage.value = _formatDioError(dioErr);
      AppAlertUtils.showToast(message: errorMessage.value, isError: true);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to load images. Please try again.";
      AppAlertUtils.showToast(message: errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// Load next page for infinite scrolling
  Future<void> loadMoreImages() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final response = await repository.fetchImages(
        query: searchQuery.value,
        category: selectedCategory.value,
        page: currentPage.value,
        perPage: 20,
      );

      if (response.hits.isEmpty) {
        hasMore.value = false;
      } else {
        images.addAll(response.hits);
        if (response.hits.length < 20 || images.length >= response.totalHits) {
          hasMore.value = false;
        }
      }
    } on DioException {
      currentPage.value--; // Revert page on failure
      AppAlertUtils.showToast(
        message: "Failed to load more images. Check network.",
        isError: true,
      );
    } catch (e) {
      currentPage.value--;
      AppAlertUtils.showToast(
        message: "Unable to load next page",
        isError: true,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Debounced Search handler (500ms delay)
  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (searchQuery.value != query) {
        searchQuery.value = query.trim();
        fetchImages(isRefresh: true);
      }
    });
  }

  /// Clear search input
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    fetchImages(isRefresh: true);
  }

  /// Select category chip
  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    fetchImages(isRefresh: true);
  }

  /// Toggle favorite via FavoritesController
  void toggleFavorite(PixabayImageModel image) {
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().toggleFavorite(image);
    }
  }

  /// Check if image is bookmarked
  bool isFavorite(int id) {
    if (Get.isRegistered<FavoritesController>()) {
      return Get.find<FavoritesController>().isFavorite(id);
    }
    return false;
  }

  /// Share image URL
  Future<void> shareImage(PixabayImageModel image) async {
    try {
      final shareText =
          "Check out this high quality photo by ${image.user} on PixGallery: ${image.largeImageURL}";
      await Share.share(shareText, subject: "Photo by ${image.user}");
    } catch (e) {
      AppAlertUtils.showToast(message: "Failed to share photo", isError: true);
    }
  }

  /// Download high resolution image with real-time percentage progress
  Future<void> downloadImage(PixabayImageModel image) async {
    try {
      // Request permission on mobile platforms
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        final photosStatus = await Permission.photos.request();
        if (status.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
          AppAlertUtils.showToast(
            message: "Storage permission needed to save image. Please enable in Settings.",
            isError: true,
          );
          return;
        }
      }

      isDownloading.value = true;
      downloadProgress.value = 0.0;
      downloadProgressText.value = 'Connecting...';
      _downloadCancelToken = CancelToken();

      // Show download progress dialog
      Get.dialog(
        _buildDownloadProgressDialog(),
        barrierDismissible: false,
      );

      final dir = await getApplicationDocumentsDirectory();
      final fileName = "PixGallery_${image.id}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final filePath = "${dir.path}/$fileName";

      await repository.downloadImage(
        imageUrl: image.largeImageURL.isNotEmpty ? image.largeImageURL : image.webformatURL,
        savePath: filePath,
        cancelToken: _downloadCancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            downloadProgress.value = progress;
            final percent = (progress * 100).toInt();
            downloadProgressText.value =
                "$percent% (${CommonUtils.formatBytes(received)} / ${CommonUtils.formatBytes(total)})";
          } else {
            downloadProgressText.value =
                "Downloading ${CommonUtils.formatBytes(received)}...";
          }
        },
      );

      if (Get.isDialogOpen ?? false) Get.back();

      AppAlertUtils.showToast(
        message: "Image saved successfully!",
        isError: false,
      );
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      if (CancelToken.isCancel(e)) {
        AppAlertUtils.showToast(message: "Download cancelled", isError: false);
      } else {
        AppAlertUtils.showToast(
          message: "Failed to download image. Try again.",
          isError: true,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      AppAlertUtils.showToast(
        message: "Error saving image: $e",
        isError: true,
      );
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      _downloadCancelToken = null;
    }
  }

  void cancelDownload() {
    _downloadCancelToken?.cancel("User cancelled");
    if (Get.isDialogOpen ?? false) Get.back();
  }

  /// Download progress dialog widget
  Widget _buildDownloadProgressDialog() {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cloud_download_rounded, color: Color(0xFF01CDCD)),
            SizedBox(width: 10),
            Text(
              "Downloading Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: downloadProgress.value > 0 ? downloadProgress.value : null,
                  minHeight: 8,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF01CDCD)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                downloadProgressText.value,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: cancelDownload,
            child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  String _formatDioError(DioException dioErr) {
    switch (dioErr.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timed out. Check your internet connection.";
      case DioExceptionType.badResponse:
        final status = dioErr.response?.statusCode;
        if (status == 400) return "Invalid API key provided. Please verify in settings.";
        if (status == 429) return "Rate limit exceeded. Please wait a moment.";
        return "Server returned error: $status";
      case DioExceptionType.connectionError:
        return "No network connection detected.";
      default:
        return "An unexpected network error occurred.";
    }
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
