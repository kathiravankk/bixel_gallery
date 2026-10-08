import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallery_app/app/core/utils/common_utils.dart';
import 'package:image_gallery_app/app/data/models/pixabay_image_model.dart';
import 'package:image_gallery_app/app/data/models/pixabay_response_model.dart';

void main() {
  group('PixabayImageModel & CommonUtils Tests', () {
    test('PixabayImageModel should deserialize JSON properly', () {
      final jsonMap = {
        'id': 12345,
        'pageURL': 'https://pixabay.com/test',
        'type': 'photo',
        'tags': 'mountain, nature, river',
        'previewURL': 'https://pixabay.com/preview.jpg',
        'previewWidth': 150,
        'previewHeight': 100,
        'webformatURL': 'https://pixabay.com/web.jpg',
        'webformatWidth': 640,
        'webformatHeight': 480,
        'largeImageURL': 'https://pixabay.com/large.jpg',
        'imageWidth': 1920,
        'imageHeight': 1080,
        'imageSize': 2048000,
        'views': 5400,
        'downloads': 1200,
        'likes': 350,
        'comments': 45,
        'user_id': 99,
        'user': 'Kathiravan',
        'userImageURL': 'https://pixabay.com/user.jpg',
      };

      final model = PixabayImageModel.fromJson(jsonMap);

      expect(model.id, 12345);
      expect(model.user, 'Kathiravan');
      expect(model.tagsList, ['mountain', 'nature', 'river']);
      expect(model.aspectRatio, closeTo(1.33, 0.05));
    });

    test('PixabayResponseModel should deserialize hits list properly', () {
      final responseJson = {
        'total': 100,
        'totalHits': 50,
        'hits': [
          {
            'id': 1,
            'user': 'Artist 1',
            'tags': 'sea, water',
            'webformatURL': 'https://example.com/1.jpg',
          },
          {
            'id': 2,
            'user': 'Artist 2',
            'tags': 'forest, trees',
            'webformatURL': 'https://example.com/2.jpg',
          }
        ]
      };

      final response = PixabayResponseModel.fromJson(responseJson);

      expect(response.total, 100);
      expect(response.totalHits, 50);
      expect(response.hits.length, 2);
      expect(response.hits.first.user, 'Artist 1');
    });

    test('CommonUtils formats large numbers correctly', () {
      expect(CommonUtils.formatNumber(450), '450');
      expect(CommonUtils.formatNumber(1500), '1.5K');
      expect(CommonUtils.formatNumber(24000), '24K');
      expect(CommonUtils.formatNumber(1500000), '1.5M');
    });

    test('CommonUtils formats byte sizes accurately', () {
      expect(CommonUtils.formatBytes(500), '500.0 B');
      expect(CommonUtils.formatBytes(1048576), '1.0 MB');
      expect(CommonUtils.formatBytes(3670016), '3.5 MB');
    });
  });
}
