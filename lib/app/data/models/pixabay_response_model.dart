import 'pixabay_image_model.dart';

class PixabayResponseModel {
  final int total;
  final int totalHits;
  final List<PixabayImageModel> hits;

  PixabayResponseModel({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayResponseModel.fromJson(Map<String, dynamic> json) {
    var hitsList = json['hits'] as List? ?? [];
    List<PixabayImageModel> parsedHits =
        hitsList.map((item) => PixabayImageModel.fromJson(item)).toList();

    return PixabayResponseModel(
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      totalHits: json['totalHits'] is int
          ? json['totalHits']
          : int.tryParse(json['totalHits']?.toString() ?? '0') ?? 0,
      hits: parsedHits,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'totalHits': totalHits,
      'hits': hits.map((hit) => hit.toJson()).toList(),
    };
  }
}
