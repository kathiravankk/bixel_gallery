import 'package:flutter_test/flutter_test.dart';
import 'package:image_gallery_app/main.dart';

void main() {
  testWidgets('PixGallery App smoke test renders splash branding', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pix'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
