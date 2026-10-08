import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallery_app/main.dart';

void main() {
  testWidgets('PixGallery App smoke test renders splash branding', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify splash branding elements exist
    expect(find.text('Pix'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Discover & Download High-Res Photography'), findsOneWidget);
  });
}
