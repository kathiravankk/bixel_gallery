import 'package:dio/dio.dart';
import '../../core/utils/app_api_urls.dart';
import '../models/pixabay_response_model.dart';
import '../repositories/local_storage_service.dart';
import 'curated_mock_data.dart';

class GalleryProvider {
  final Dio client;

  GalleryProvider({Dio? dioClient})
      : client = dioClient ??
            Dio(
              BaseOptions(
                baseUrl: AppApiUrls.baseUrl,
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 12),
                responseType: ResponseType.json,
              ),
            ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  /// Fetch images with search query, category, color filter, ID lookup, and pagination
  Future<PixabayResponseModel> fetchImages({
    String query = '',
    String category = '',
    String colors = '',
    String imageId = '',
    int page = 1,
    int perPage = 20,
  }) async {
    String? storedKey = await LocalStorageService.getApiKey();
    String activeKey = (storedKey != null && storedKey.trim().isNotEmpty)
        ? storedKey.trim()
        : AppApiUrls.pixabayApiKey.trim();

    if (activeKey.isEmpty) {
      return CuratedMockData.getCuratedResponse(
        query: query,
        category: category,
        page: page,
        perPage: perPage,
      );
    }

    try {
      final Map<String, dynamic> queryParams = {
        'key': activeKey,
        'image_type': 'photo',
        'safesearch': 'true',
      };

      // ID lookup takes priority if provided
      if (imageId.trim().isNotEmpty) {
        queryParams['id'] = imageId.trim();
        final response = await client.get('', queryParameters: queryParams);
        if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
          return PixabayResponseModel.fromJson(response.data);
        }
      }

      queryParams['page'] = page;
      queryParams['per_page'] = perPage;

      if (query.trim().isNotEmpty) {
        queryParams['q'] = query.trim();
      }

      if (category.trim().isNotEmpty && category.toLowerCase() != 'all') {
        queryParams['category'] = category.trim().toLowerCase();
      }

      if (colors.trim().isNotEmpty && colors.toLowerCase() != 'all') {
        queryParams['colors'] = colors.trim().toLowerCase();
      }

      final response = await client.get(
        '',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return PixabayResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Unexpected server response format',
        );
      }
    } on DioException catch (dioErr) {
      if (dioErr.response?.statusCode == 400 && activeKey.isEmpty) {
        return CuratedMockData.getCuratedResponse(
          query: query,
          category: category,
          page: page,
          perPage: perPage,
        );
      }
      rethrow;
    }
  }

  /// Retrieve single image by Pixabay ID
  Future<PixabayResponseModel> fetchImageById(String id) async {
    return await fetchImages(imageId: id);
  }

  /// Download file with real-time byte tracking progress
  Future<Response> downloadImage({
    required String imageUrl,
    required String savePath,
    required ProgressCallback onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    return await client.download(
      imageUrl,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}
