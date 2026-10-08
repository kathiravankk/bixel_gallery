# Technical Assessment Submission: Infinite Image Gallery App

**Company:** Gnxtace Technologies Pvt. Ltd.  
**HR Contact:** PopeDivya ([popedivya@gnxtace.com](mailto:popedivya@gnxtace.com))  
**Position:** Flutter Developer  
**Candidate:** Kathiravan K  
**Contact:** +91-9360491343 | kathirkannan2002@gmail.com | [LinkedIn](https://linkedin.com)  

---

## 1. Project Overview & Architecture

The assignment required developing a production-style Flutter image gallery application consuming the Pixabay API, supporting infinite scrolling, responsive masonry grid layout, image detail view with pinch-zoom, high-definition download with progress tracking, persistent favorites, and comprehensive error/network handling.

### Architectural Pattern: Clean Architecture + Feature-First GetX
The codebase follows a modular Clean Architecture structure with strict separation of concerns, identical to enterprise production Flutter standards:

```
lib/
├── app/
│   ├── core/
│   │   ├── theme/           # AppTheme (Light & Dark), ThemeController
│   │   ├── utils/           # AppColors, AppStyles, AppApiUrls, AppAlertUtils, CommonUtils
│   │   └── widgets/         # CustomNetworkImage, CustomShimmer, CustomButtonWidget
│   ├── data/
│   │   ├── models/          # PixabayImageModel, PixabayResponseModel (with JSON serialization)
│   │   ├── providers/       # GalleryProvider (Dio client, logging interceptors, Curated dataset)
│   │   └── repositories/    # GalleryRepository & LocalStorageService (SharedPreferences)
│   ├── modules/
│   │   ├── splash/          # Splash branding, routing transition
│   │   ├── gallery/         # Responsive masonry feed, debounced search, categories, detail screen, network monitor
│   │   └── favorites/       # Persistent bookmarks feed, reactive count badge
│   └── routes/
│       ├── app_pages.dart   # Route configuration with dependency injection bindings
│       └── app_routes.dart  # Strongly typed route constants
└── main.dart                # Application entrypoint, orientation locks, theme initialization
```

---

## 2. Key Technical Implementation Details

### A. Responsive UI & Layout Resilience
- **Staggered Masonry Grid:** Implemented via `flutter_staggered_grid_view` using dynamic image aspect ratios (`width / height`) to achieve a Pinterest/Unsplash-style aesthetic without empty gaps or visual stutter.
- **Adaptive Columns:** 
  - Mobile screens (< 600px width): 2 columns.
  - Tablets (600px - 900px): 3 columns.
  - Desktop / wide screens (> 900px): 4 columns.
- **Zero Render Overflows:** All cards, stat boxes, and bottom sheets wrap text with proper truncation, flexible spans, and scroll views.

### B. State Management (GetX)
- Separation of controllers (`GalleryController`, `FavoritesController`, `NetworkController`, `ThemeController`) from presentation views (`GetView`).
- Granular reactive updates using `.obs` observables and `Obx` widgets to ensure only modified UI elements rebuild.
- Dependency injection via `Bindings` ensures memory is freed when routes are popped.

### C. Networking & Error Handling (Dio)
- **Dio Client:** Configured with 12s connect/receive timeouts, base URL, query parameters, and custom `InterceptorsWrapper`.
- **Error Handling:** Centralized parsing for connection timeouts, 400 Bad Request, 429 Rate Limits, 500 Server Errors, and network drops.
- **Connectivity:** Real-time network listener (`connectivity_plus`) provides an offline alert and enables offline viewing of cached images.
- **Custom Toasts:** Styled toast notifications using `Fluttertoast` with distinct feedback colors (Red for errors, Green for successful actions).

### D. Image Performance & Caching
- Handled with `CachedNetworkImage` configured with `memCacheWidth: 600` and `memCacheHeight: 800` to prevent memory bloat and Out-Of-Memory (OOM) crashes during continuous infinite scrolling.
- Dual-layer placeholders: Shimmer skeleton cards during feed loading and micro-shimmers while individual image tiles load.

### E. Image Detail & Pinch-to-Zoom
- Smooth **Hero Animation** transitions from feed thumbnail to detail view.
- **InteractiveViewer:** Smooth 1.0x to 4.0x pinch-to-zoom and pan functionality.
- Displays photographer avatar, name, verified ID badge, views, likes, downloads, dimensions, and estimated file size.
- Interactive keyword tag chips: Tapping any tag automatically initiates a search filter.

### F. High-Resolution Download with Real-Time Progress
- Downloads original image files using Dio's byte-level stream tracker (`onReceiveProgress`).
- Custom progress dialog displaying real-time percentage (0% to 100%) and downloaded data (`MB / MB`).
- Includes a cancel token so users can abort in-flight downloads.
- Permission management handled cleanly with `permission_handler`.

### G. Local Persistence (Favorites & Theme)
- Saved locally in `SharedPreferences` as serialized JSON arrays.
- Real-time synchronization: Toggling a favorite on the detail screen or home screen immediately reflects across all screens.
- Light and Dark theme preferences persist across app restarts.

### H. In-App API Key Configuration & Fallback Demo Mode
- Evaluators can tap the **Key (🔑)** icon in the AppBar to enter their own Pixabay API Key.
- If no key is entered or if the key is invalid, the app automatically switches to **Curated Demo Mode**, ensuring the evaluator can test all features (infinite scroll, search, categories, download, favorites) without setup roadblocks.

---

## 3. Test Coverage & Verification

- **Static Analysis:** `flutter analyze` completed with **0 issues found**.
- **Unit & Smoke Tests:** 5 passing automated tests in `test/`:
  - `PixabayImageModel` serialization & deserialization.
  - `PixabayResponseModel` hits list parsing.
  - `CommonUtils.formatNumber` (e.g. 14.2K, 1.5M).
  - `CommonUtils.formatBytes` (e.g. 2.4 MB).
  - `PixGallery` widget smoke test.

---

## 4. Setup & Running Instructions

1. **Clone / Open Project:**
   ```bash
   cd image_gallery_app
   ```

2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run Application:**
   ```bash
   flutter run
   ```

4. **Run Automated Tests:**
   ```bash
   flutter test
   ```

---

## 5. Assumptions & Limitations

1. **Pixabay Free Tier Limits:** Pixabay imposes a limit of 100 requests per 60 seconds on free tier API keys. A 500ms search debounce is implemented to prevent hitting this rate limit.
2. **Download Directory:** Images are downloaded into the sandboxed application documents directory for zero-permission friction on Android 13+ and iOS.
