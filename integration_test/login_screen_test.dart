import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/feed/feed_screen.dart';
import 'package:pets_social/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group(
    'Login',
    () {
      testWidgets(
        'Verify login with correct username and password',
        (widgetTester) async {
          //await widgetTester.pumpWidget(const LoginScreen());
          app.main();
          await widgetTester.pumpAndSettle();
          await widgetTester.enterText(find.byType(TextFieldInput).at(0), 'egglizzy@gmail.com');
          await widgetTester.enterText(find.byType(TextFieldInput).at(1), 'Test123!');
          await widgetTester.tap(find.byType(InkWell));
          await widgetTester.pumpAndSettle();

          expect(find.byType(FeedScreen), findsOneWidget);
        },
      );
    },
  );
}
