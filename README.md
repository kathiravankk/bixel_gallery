# PixGallery – Infinite Image Gallery App

A production-ready Flutter image gallery application consuming the Pixabay API, architected with **Clean Architecture**, **GetX State Management**, and **Dio Networking**. Built with high-performance responsive masonry layouts, infinite pagination, offline persistence, dark/light themes, and image downloading capabilities.

---

## 👨‍💻 Candidate Information
- **Name:** Kathiravan K
- **Role:** Flutter Developer
- **Assessment:** Flutter Intermediate Level Interview Assignment (Infinite Image Gallery App)
- **Company:** Gnxtace Technologies Pvt. Ltd.
- **HR Contact:** PopeDivya (`popedivya@gnxtace.com`)

---

## 🌟 Core Features & Implementation Highlights

### 1. Responsive Gallery Grid (Masonry Layout)
- Built using `flutter_staggered_grid_view` with dynamic aspect ratios calculated from image metadata.
- Adaptive column count based on device screen width:
  - **Mobile Screens (< 600px):** 2 columns
  - **Tablet Screens (600px - 900px):** 3 columns
  - **Desktop / Large Displays (> 900px):** 4 columns
- Zero UI overflows and responsive constraints on all orientations and screen sizes.

### 2. Infinite Scroll & Pagination
- `ScrollController` listener triggers `loadMoreImages()` when the user scrolls within 300px of the list bottom.
- Guarded against duplicate calls via `isLoadingMore` and `hasMore` flags.
- Bottom loading spinner indicator and friendly "end of gallery" indicator.

### 3. Image Performance & Memory Optimization
- Utilizes `cached_network_image` with explicit `memCacheWidth: 600` and `memCacheHeight: 800` parameters.
- Prevents out-of-memory (OOM) crashes and frame drops during heavy infinite scrolling.
- Smooth image fading with placeholder shimmer skeletons and graceful broken image fallbacks.

### 4. Robust Error Handling & Network Resilience
- **Dio Interceptors:** Request/response logging and centralized exception handling.
- **Connection Monitoring:** `NetworkController` with `connectivity_plus` detects offline and online status changes reactively, displaying alerts and enabling offline viewing of cached content.
- **Error UI:** Fullscreen error state with illustration, human-friendly error messages, and a "Try Again" retry button.
- **Custom Toasts:** Styled toast notifications for both successes (green) and errors (red) via `AppAlertUtils`.

### 5. Detailed Image View & Zoom
- Smooth **Hero Animation** transitions from grid thumbnail to full-screen view.
- **Pinch-to-Zoom & Pan:** Built with Flutter's `InteractiveViewer` (1.0x to 4.0x zoom ratio).
- **Metadata Display:**
  - Creator profile avatar, name, and creator ID.
  - Photo statistics: Views, Likes, Downloads, Resolution (Width × Height), and File Size.
  - Interactive keyword/tag chips that allow one-tap search filtering.

### 6. Image Download with Progress Tracking
- Downloads high-resolution photos using Dio with byte-level progress reporting (`onReceiveProgress`).
- Real-time download modal with percentage progress bar and byte counters (`MB / MB`).
- Graceful storage permission handling via `permission_handler`.
- Files saved to device application storage.

### 7. Favorites & Offline Persistence
- Bookmark and un-bookmark photos with animated heart icons across Home, Detail, and Favorites screens.
- Persisted locally using `SharedPreferences` in `LocalStorageService`.
- Dedicated **Favorites Screen** with reactive count badge and instant state synchronization.

### 8. Bonus Features Implemented
- 🔍 **Real-time Search:** 500ms debounce timer prevents unnecessary API flooding while typing.
- 🔄 **Pull-to-Refresh:** Refreshes gallery with pull-down gesture.
- 🏷️ **Category Filter Bar:** Horizontal filter chips (All, Nature, Architecture, Animals, Travel, Technology, Food, Sports).
- 🌓 **Theme Support:** Dark Theme (default) and Light Theme with instant toggle and preference persistence.
- 🔗 **Image Sharing:** Deep-link and photo sharing via `share_plus`.
- 🔑 **In-App API Key Switcher:** Evaluators can enter their Pixabay API key directly in the app or run in Curated Demo Mode.
- 🧪 **Test Suite:** Unit tests and smoke tests passing (`flutter test`).

---

## 🏗️ Architecture & State Management

The application is structured following Clean Architecture principles with separation of concerns:

```
lib/
├── app/
│   ├── core/
│   │   ├── theme/          # Light & Dark Theme definitions and ThemeController
│   │   ├── utils/          # AppColors, AppStyles, AppApiUrls, AppAlertUtils, CommonUtils
│   │   └── widgets/        # Reusable buttons, shimmer skeletons, cached images
│   ├── data/
│   │   ├── models/         # PixabayImageModel & PixabayResponseModel (JSON serialization)
│   │   ├── providers/      # GalleryProvider (Dio client, interceptors, curated demo data)
│   │   └── repositories/   # GalleryRepository & LocalStorageService (SharedPreferences)
│   ├── modules/
│   │   ├── splash/         # Splash screen and routing controller
│   │   ├── gallery/        # Gallery home, search, masonry grid, image detail, network monitoring
│   │   └── favorites/      # Bookmarked photos screen and reactive state
│   └── routes/
│       ├── app_pages.dart  # GetPage definitions and bindings
│       └── app_routes.dart # Static route constants
└── main.dart               # App entrypoint with orientations and theme setup
```

### Why GetX?
- **Separation of Concerns:** Clean boundary between UI (`GetView`), business logic (`GetxController`), and dependency injection (`Bindings`).
- **Reactive State Management:** Lightweight observable primitives (`.obs`, `Obx`) eliminate boilerplate while ensuring minimal rebuilds.
- **Route Navigation:** Predictable named routing (`Get.toNamed`, `Get.back`) without requiring `BuildContext`.

---

## ⚙️ Setup & Configuration

### Prerequisites
- Flutter SDK `^3.13.0` (tested on Flutter `3.47.5`)
- Dart SDK `^3.10.0`
- Android Studio / Xcode / VS Code

### Installation
1. Clone or download the repository:
   ```bash
   cd image_gallery_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Pixabay API Key (Optional):
   - **Method A (In-App):** Launch the app, tap the **Key (🔑)** icon in the top AppBar, enter your Pixabay API key, and tap **Save & Apply**.
   - **Method B (In Code):** Open `lib/app/core/utils/app_api_urls.dart` and set `pixabayApiKey`:
     ```dart
     static String pixabayApiKey = "YOUR_PIXABAY_API_KEY";
     ```
   > **Note:** If no key is provided, the application automatically runs in **Curated High-Definition Demo Mode** with full pagination, category filtering, search, downloading, and bookmarking functionality intact!

4. Run the application:
   ```bash
   flutter run
   ```

5. Run Tests:
   ```bash
   flutter test
   ```

---

## 📱 Evaluation Criteria Mapping

| Area | Weight | Implementation Details |
|---|---|---|
| **Flutter/Dart Code Quality** | 20% | Zero lint errors (`flutter analyze` clean), strong typing, clean code conventions |
| **State Management & Architecture** | 20% | Clean Architecture, GetX controllers, repository pattern, modular bindings |
| **API Integration & Pagination** | 20% | Dio client, interceptors, query debounce, infinite scroll with `ScrollController` |
| **UI/UX & Responsiveness** | 15% | Staggered masonry grid, pinch-zoom `InteractiveViewer`, Hero animations, Dark/Light modes |
| **Favorites / Local Persistence** | 10% | `SharedPreferences` cache with real-time reactive sync across all screens |
| **Download & Permissions** | 10% | Dio byte-level progress reporting modal, `permission_handler` integration |
| **Testing & Documentation** | 5% | Model unit tests, formatting helper tests, smoke widget tests, comprehensive README |

---

## 📝 Assumptions & Limitations
- **Pixabay Free Tier Rate Limits:** Pixabay's public API limits free keys to 100 requests per minute. Debouncing (500ms) is implemented on search to prevent accidental rate-limiting.
- **Download Storage:** Downloaded files are stored in the application document storage for sandboxed security across iOS and Android without requiring deprecated full-disk permissions.
