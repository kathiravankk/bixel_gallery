import 'package:get/get.dart';
import 'package:image_gallery_app/app/core/theme/theme_controller.dart';
import 'package:image_gallery_app/app/data/providers/gallery_provider.dart';
import 'package:image_gallery_app/app/data/repositories/gallery_repository.dart';
import 'package:image_gallery_app/app/modules/favorites/controller/favorites_controller.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/gallery_controller.dart';
import 'package:image_gallery_app/app/modules/gallery/controller/network_controller.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);

    Get.lazyPut<GalleryProvider>(() => GalleryProvider(), fenix: true);
    Get.lazyPut<GalleryRepository>(
      () => GalleryRepository(galleryProvider: Get.find<GalleryProvider>()),
      fenix: true,
    );
    Get.lazyPut<GalleryController>(
      () => GalleryController(repository: Get.find<GalleryRepository>()),
      fenix: true,
    );
  }
}
