import 'package:coder_application/splash.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets('Test Splash', ( WidgetTester tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(const Splash());
  expect(find.text('Sign in'), findsOneWidget);
  expect(find.text('Create an Account'), findsOneWidget);
  expect(find.text('Continue as Guest'), findsOneWidget);
});
}
