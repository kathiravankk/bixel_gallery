import 'package:get/get.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/view/favorites_screen.dart';
import '../modules/gallery/bindings/gallery_binding.dart';
import '../modules/gallery/view/gallery_home_screen.dart';
import '../modules/gallery/view/image_detail_screen.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/view/splash_screen.dart';

part 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.galleryHome,
      page: () => const GalleryHomeScreen(),
      binding: GalleryBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.imageDetail,
      page: () => const ImageDetailScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
