import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../data/providers/gallery_provider.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../controller/gallery_controller.dart';
import '../controller/network_controller.dart';

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);

    Get.lazyPut<GalleryProvider>(() => GalleryProvider(dioClient: Dio()));
    Get.lazyPut<GalleryRepository>(
      () => GalleryRepository(galleryProvider: Get.find<GalleryProvider>()),
    );
    Get.lazyPut<GalleryController>(
      () => GalleryController(repository: Get.find<GalleryRepository>()),
    );
  }
}
